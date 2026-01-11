#!/bin/bash

# MP4 to Live Photo Converter
# This script converts MP4 videos to Live Photos (HEIC + MOV pair) for iOS devices
# Requirements: ffmpeg, exiftool

set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored messages
print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Function to check if required tools are installed
check_dependencies() {
    local missing_deps=()
    
    if ! command -v ffmpeg &> /dev/null; then
        missing_deps+=("ffmpeg")
    fi
    
    if ! command -v exiftool &> /dev/null; then
        missing_deps+=("exiftool")
    fi
    
    if [ ${#missing_deps[@]} -ne 0 ]; then
        print_error "Missing required dependencies: ${missing_deps[*]}"
        echo ""
        echo "Please install them using Homebrew:"
        echo "  brew install ffmpeg exiftool"
        echo ""
        exit 1
    fi
}

# Function to display usage
usage() {
    cat << EOF
Usage: $0 [OPTIONS] <input.mp4> [output_name]

Convert MP4 video to Live Photo format (HEIC + MOV pair).

Arguments:
    input.mp4       Input MP4 video file
    output_name     Optional output name (without extension). If not provided,
                    uses the input filename.

Options:
    -h, --help      Show this help message
    -o, --output    Output directory (default: ./LivePhotos)
    -q, --quality   HEIC quality (1-100, default: 92)
    -k, --keep      Keep intermediate files

Examples:
    $0 video.mp4
    $0 video.mp4 my_livephoto
    $0 -o ~/Pictures/LivePhotos video.mp4
    $0 --quality 95 video.mp4

EOF
}

# Default values
OUTPUT_DIR="./LivePhotos"
HEIC_QUALITY=92
KEEP_TEMP=false

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            usage
            exit 0
            ;;
        -o|--output)
            if [ -z "$2" ]; then
                print_error "Option -o/--output requires a directory path"
                exit 1
            fi
            OUTPUT_DIR="$2"
            shift 2
            ;;
        -q|--quality)
            if [ -z "$2" ]; then
                print_error "Option -q/--quality requires a value (1-100)"
                exit 1
            fi
            HEIC_QUALITY="$2"
            shift 2
            ;;
        -k|--keep)
            KEEP_TEMP=true
            shift
            ;;
        -*)
            print_error "Unknown option: $1"
            usage
            exit 1
            ;;
        *)
            if [ -z "$INPUT_FILE" ]; then
                INPUT_FILE="$1"
            elif [ -z "$OUTPUT_NAME" ]; then
                OUTPUT_NAME="$1"
            else
                print_error "Too many arguments"
                usage
                exit 1
            fi
            shift
            ;;
    esac
done

# Check if input file is provided
if [ -z "$INPUT_FILE" ]; then
    print_error "No input file specified"
    usage
    exit 1
fi

# Check if input file exists
if [ ! -f "$INPUT_FILE" ]; then
    print_error "Input file not found: $INPUT_FILE"
    exit 1
fi

# Check dependencies
check_dependencies

# Validate quality parameter
if ! [[ "$HEIC_QUALITY" =~ ^[0-9]+$ ]]; then
    print_error "Quality must be a number (1-100), got: $HEIC_QUALITY"
    exit 1
fi

if [ "$HEIC_QUALITY" -lt 1 ] || [ "$HEIC_QUALITY" -gt 100 ]; then
    print_error "Quality must be between 1 and 100, got: $HEIC_QUALITY"
    exit 1
fi

# Get absolute path of input file
INPUT_FILE=$(cd "$(dirname "$INPUT_FILE")" && pwd)/$(basename "$INPUT_FILE")

# Set output name if not provided
if [ -z "$OUTPUT_NAME" ]; then
    OUTPUT_NAME=$(basename "$INPUT_FILE" | sed 's/\.[^.]*$//')
fi

# Expand tilde in OUTPUT_DIR
OUTPUT_DIR="${OUTPUT_DIR/#\~/$HOME}"

# Create output directory
mkdir -p "$OUTPUT_DIR"

print_info "Starting conversion..."
print_info "Input file: $INPUT_FILE"
print_info "Output name: $OUTPUT_NAME"
print_info "Output directory: $OUTPUT_DIR"

# Temporary directory for intermediate files
TEMP_DIR=$(mktemp -d)
if [ "$KEEP_TEMP" = false ]; then
    trap "rm -rf $TEMP_DIR" EXIT
else
    print_info "Temporary files will be kept in: $TEMP_DIR"
fi

# Step 1: Extract first frame as JPEG
print_info "Extracting first frame from video..."
OUTPUT_JPG="$OUTPUT_DIR/${OUTPUT_NAME}.JPG"
# Use quality parameter: lower q:v values mean higher quality (1-31 scale)
# Map user quality (1-100) to ffmpeg quality (31-1)
JPEG_QUALITY=$(( (100 - HEIC_QUALITY) * 31 / 100 + 1 ))
if [ $JPEG_QUALITY -lt 1 ]; then JPEG_QUALITY=1; fi
if [ $JPEG_QUALITY -gt 31 ]; then JPEG_QUALITY=31; fi
ffmpeg -i "$INPUT_FILE" -vframes 1 -q:v $JPEG_QUALITY "$OUTPUT_JPG" -y &> /dev/null

if [ ! -f "$OUTPUT_JPG" ]; then
    print_error "Failed to extract frame from video"
    exit 1
fi

# Step 3: Convert MP4 to MOV format (required for Live Photos)
print_info "Converting to MOV format..."
OUTPUT_MOV="$OUTPUT_DIR/${OUTPUT_NAME}.MOV"

# Copy video and audio streams to MOV container
# Use -map 0:v to copy video, -map 0:a? to optionally copy audio if present
ffmpeg -i "$INPUT_FILE" -map 0:v -map 0:a? -c:v copy -c:a copy -f mov "$OUTPUT_MOV" -y &> /dev/null

if [ ! -f "$OUTPUT_MOV" ]; then
    print_error "Failed to convert to MOV format"
    exit 1
fi

# Step 3: Generate UUID for pairing
print_info "Adding metadata for Live Photo pairing..."
UUID=$(uuidgen)

# Add metadata to JPG (image)
# Use Keys: prefix for QuickTime metadata keys
exiftool -overwrite_original \
    "-Keys:ContentIdentifier=$UUID" \
    "$OUTPUT_JPG" &> /dev/null

# Add metadata to MOV (video)
exiftool -overwrite_original \
    "-Keys:ContentIdentifier=$UUID" \
    "-Keys:StillImageTime=0" \
    "$OUTPUT_MOV" &> /dev/null

# Set file creation and modification times to be the same
touch "$OUTPUT_JPG" "$OUTPUT_MOV" 2>/dev/null || true

print_info "Success! Live Photo created:"
echo "  Image: $OUTPUT_JPG"
echo "  Video: $OUTPUT_MOV"
echo ""
print_info "To import to iPhone:"
echo "  1. AirDrop: Select both files (JPG + MOV) and AirDrop to iPhone"
echo "  2. iCloud Photos: Copy both files to iCloud Photos folder"
echo "  3. Finder: Connect iPhone via USB and drag both files to Photos"
echo ""
print_warning "Important: Both files must be transferred together to maintain Live Photo pairing"
