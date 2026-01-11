# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a macOS command-line tool that converts MP4 videos to iPhone/iPad Live Photo format. Live Photos consist of a paired HEIC image and MOV video file linked via metadata (UUID-based pairing).

## Core Architecture

The conversion pipeline in `mp4-to-livephoto.sh`:

1. **Frame Extraction**: Uses ffmpeg to extract first frame as JPEG
2. **HEIC Conversion**: Converts JPEG to HEIC using ffmpeg with `hevc_videotoolbox` (macOS hardware acceleration)
3. **MOV Conversion**: Remuxes MP4 to MOV container (stream copy, no re-encoding)
4. **Metadata Pairing**: Uses exiftool to add matching `MediaGroupUUID` and `ContentIdentifier` to both files

**Critical pairing requirements:**
- Both files must have identical UUID in metadata
- Files must have same base name (different extensions)
- Both files must be transferred together to iOS device

## Running the Tool

Basic usage:
```bash
./mp4-to-livephoto.sh input.mp4
```

With options:
```bash
./mp4-to-livephoto.sh -o ~/output -q 95 input.mp4 custom_name
```

Options:
- `-o, --output`: Output directory (default: ./LivePhotos)
- `-q, --quality`: HEIC quality 1-100 (default: 92)
- `-k, --keep`: Keep intermediate files
- `-h, --help`: Show help

## Dependencies

Required tools (installed via Homebrew):
- `ffmpeg`: Video processing and HEIC encoding
- `exiftool`: Metadata manipulation

The script checks for these dependencies on startup.

## Quality Settings

The `-q` parameter (1-100) is inverted for ffmpeg's `hevc_videotoolbox`:
- User quality 92 → ffmpeg `-q:v 8` (100 - 92)
- Higher user values = better quality, larger files

## Testing Changes

After modifying the script:
1. Test with a sample MP4: `./mp4-to-livephoto.sh demo.mp4`
2. Verify output files exist in `./LivePhotos/`
3. Check metadata: `exiftool -MediaGroupUUID -ContentIdentifier ./LivePhotos/demo.{HEIC,MOV}`
4. Verify UUIDs match between files
5. Test on iOS device by AirDropping both files together

## Common Modifications

When adding features:
- Argument parsing is in lines 83-119 (case statement)
- Validation logic is in lines 121-135
- Conversion steps are sequential (lines 157-210)
- Error handling uses `set -e` and explicit checks after each ffmpeg/exiftool call
