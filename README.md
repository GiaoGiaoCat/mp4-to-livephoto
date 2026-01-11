# MP4 to Live Photo Converter / MP4 转实况照片工具

[English](#english) | [中文](#中文)

---

## 中文

### 简介

这是一个用于 macOS 的命令行工具，可以将 MP4 视频文件转换为 iPhone/iPad 的实况照片（Live Photo）格式。实况照片由一张 HEIC 静态图片和一个 MOV 视频文件组成，两者通过元数据配对。

### 功能特点

- ✅ 将 MP4 视频转换为实况照片格式（HEIC + MOV 配对）
- ✅ 自动提取视频首帧作为静态图片
- ✅ 添加正确的元数据以确保文件配对
- ✅ 支持自定义输出目录和图片质量
- ✅ 彩色终端输出，易于使用
- ✅ 提供详细的导入 iPhone 说明

### 系统要求

- macOS 系统（必需）
- Homebrew 包管理器
- 依赖工具：
  - `ffmpeg` - 视频处理工具
  - `exiftool` - 元数据编辑工具

### 安装

1. **安装 Homebrew**（如果尚未安装）：
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

2. **安装依赖工具**：
   ```bash
   brew install ffmpeg exiftool
   ```

3. **下载本工具**：
   ```bash
   git clone https://github.com/GiaoGiaoCat/mp4-to-livephoto.git
   cd mp4-to-livephoto
   chmod +x mp4-to-livephoto.sh
   ```

### 使用方法

#### 基本用法

```bash
./mp4-to-livephoto.sh 输入视频.mp4
```

这将在 `./LivePhotos` 目录下生成配对的 HEIC 和 MOV 文件。

#### 指定输出名称

```bash
./mp4-to-livephoto.sh 输入视频.mp4 我的实况照片
```

#### 指定输出目录

```bash
./mp4-to-livephoto.sh -o ~/Pictures/LivePhotos 输入视频.mp4
```

#### 设置图片质量

```bash
./mp4-to-livephoto.sh -q 95 输入视频.mp4
```

质量范围：1-100，默认 92（数值越高质量越好，文件越大）

#### 查看帮助

```bash
./mp4-to-livephoto.sh -h
```

### 导入到 iPhone

生成的实况照片包含两个文件：
- `文件名.HEIC` - 静态图片
- `文件名.MOV` - 视频文件

**重要：两个文件必须同时传输才能保持配对关系！**

#### 方法 1：使用 AirDrop（推荐）

1. 在 Mac 的访达中，找到生成的两个文件
2. 同时选中 `.HEIC` 和 `.MOV` 文件
3. 右键点击，选择"共享" > "隔空投送"
4. 选择你的 iPhone
5. 在 iPhone 上接受文件，它们会自动保存到照片应用中

#### 方法 2：使用 iCloud 照片

1. 确保 Mac 和 iPhone 都开启了 iCloud 照片同步
2. 将两个文件复制到 Mac 的"照片"应用中
3. 等待 iCloud 自动同步到 iPhone（需要网络连接）

#### 方法 3：使用访达（USB 连接）

1. 使用数据线将 iPhone 连接到 Mac
2. 打开访达，在侧边栏选择你的 iPhone
3. 点击"照片"标签
4. 将两个文件拖拽到照片列表中
5. 点击"同步"按钮

### 验证实况照片

1. 在 iPhone 的照片应用中打开导入的照片
2. 长按照片，如果能看到动态效果，说明实况照片配对成功
3. 在相册浏览时，照片左上角会显示"LIVE"标记

### 常见问题

**Q: 为什么导入后不显示为实况照片？**  
A: 确保同时传输了 .HEIC 和 .MOV 两个文件，且文件名相同（除了扩展名）。

**Q: 可以转换任意长度的视频吗？**  
A: 可以，但实况照片通常只有 3 秒左右。如果视频较长，建议先剪辑到合适长度。

**Q: 转换后的文件可以在 Mac 上查看吗？**  
A: 可以分别打开 HEIC 图片和 MOV 视频，但 Mac 的照片应用不会将它们显示为实况照片。

**Q: 支持 Windows 或 Linux 吗？**  
A: 本工具专为 macOS 设计。某些步骤（如 HEIC 编码）依赖 macOS 的硬件加速功能。

### 许可证

MIT License - 详见 [LICENSE](LICENSE) 文件

---

## English

### Introduction

This is a command-line tool for macOS that converts MP4 video files into Live Photo format for iPhone/iPad. Live Photos consist of a HEIC static image and a MOV video file, paired together through metadata.

### Features

- ✅ Convert MP4 videos to Live Photo format (paired HEIC + MOV)
- ✅ Automatically extract first frame as static image
- ✅ Add correct metadata to ensure file pairing
- ✅ Support custom output directory and image quality
- ✅ Colored terminal output for better usability
- ✅ Detailed instructions for importing to iPhone

### System Requirements

- macOS (required)
- Homebrew package manager
- Dependencies:
  - `ffmpeg` - video processing tool
  - `exiftool` - metadata editing tool

### Installation

1. **Install Homebrew** (if not already installed):
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

2. **Install dependencies**:
   ```bash
   brew install ffmpeg exiftool
   ```

3. **Download this tool**:
   ```bash
   git clone https://github.com/GiaoGiaoCat/mp4-to-livephoto.git
   cd mp4-to-livephoto
   chmod +x mp4-to-livephoto.sh
   ```

### Usage

#### Basic Usage

```bash
./mp4-to-livephoto.sh input_video.mp4
```

This will generate paired HEIC and MOV files in the `./LivePhotos` directory.

#### Specify Output Name

```bash
./mp4-to-livephoto.sh input_video.mp4 my_livephoto
```

#### Specify Output Directory

```bash
./mp4-to-livephoto.sh -o ~/Pictures/LivePhotos input_video.mp4
```

#### Set Image Quality

```bash
./mp4-to-livephoto.sh -q 95 input_video.mp4
```

Quality range: 1-100, default 92 (higher values = better quality but larger file size)

#### Show Help

```bash
./mp4-to-livephoto.sh -h
```

### Import to iPhone

The generated Live Photo consists of two files:
- `filename.HEIC` - static image
- `filename.MOV` - video file

**Important: Both files must be transferred together to maintain the pairing!**

#### Method 1: Using AirDrop (Recommended)

1. In Finder on Mac, locate the two generated files
2. Select both `.HEIC` and `.MOV` files
3. Right-click and choose "Share" > "AirDrop"
4. Select your iPhone
5. Accept the files on iPhone - they'll automatically save to Photos app

#### Method 2: Using iCloud Photos

1. Ensure iCloud Photos is enabled on both Mac and iPhone
2. Copy both files to the Photos app on Mac
3. Wait for iCloud to sync to iPhone (requires internet connection)

#### Method 3: Using Finder (USB Connection)

1. Connect iPhone to Mac with USB cable
2. Open Finder and select your iPhone from the sidebar
3. Click the "Photos" tab
4. Drag both files to the photo list
5. Click the "Sync" button

### Verify Live Photo

1. Open the imported photo in iPhone Photos app
2. Long-press the photo - if you see animation, the Live Photo pairing was successful
3. When browsing, you'll see a "LIVE" badge in the top-left corner of the photo

### FAQ

**Q: Why doesn't it show as a Live Photo after import?**  
A: Make sure both .HEIC and .MOV files were transferred together with matching filenames (except extension).

**Q: Can I convert videos of any length?**  
A: Yes, but Live Photos are typically around 3 seconds. For longer videos, consider trimming first.

**Q: Can I view the Live Photo on Mac?**  
A: You can open the HEIC image and MOV video separately, but Mac Photos app won't display them as a Live Photo.

**Q: Does it work on Windows or Linux?**  
A: This tool is designed for macOS. Some steps (like HEIC encoding) rely on macOS hardware acceleration.

### License

MIT License - see [LICENSE](LICENSE) file for details