# 使用示例

### 示例 1: 最简单的使用方式

假设你有一个视频文件 `vacation.mp4`：

```bash
./mp4-to-livephoto.sh vacation.mp4
```

输出：
```
[INFO] Starting conversion...
[INFO] Input file: /path/to/vacation.mp4
[INFO] Output name: vacation
[INFO] Output directory: ./LivePhotos
[INFO] Extracting first frame from video...
[INFO] Converting to HEIC format...
[INFO] Converting to MOV format...
[INFO] Adding metadata for Live Photo pairing...
[INFO] Success! Live Photo created:
  Image: ./LivePhotos/vacation.HEIC
  Video: ./LivePhotos/vacation.MOV
```

### 示例 2: 批量转换多个视频

创建一个批处理脚本 `batch_convert.sh`：

```bash
#!/bin/bash
for video in *.mp4; do
    echo "Converting $video..."
    ./mp4-to-livephoto.sh "$video"
done
```

运行：
```bash
chmod +x batch_convert.sh
./batch_convert.sh
```

### 示例 3: 自定义输出位置和质量

```bash
# 输出到特定目录，使用高质量设置
./mp4-to-livephoto.sh -o ~/Desktop/MyLivePhotos -q 98 myvideo.mp4

# 指定输出文件名
./mp4-to-livephoto.sh -o ~/Desktop/MyLivePhotos myvideo.mp4 summer_2024
```

### 示例 4: 使用视频剪辑工具预处理

如果你想只转换视频的前 3 秒（实况照片的标准长度）：

```bash
# 使用 ffmpeg 先剪辑视频
ffmpeg -i long_video.mp4 -t 3 -c copy short_video.mp4

# 然后转换
./mp4-to-livephoto.sh short_video.mp4
```

## 常见工作流程

### 工作流程 1: 从 iPhone 拍摄的视频创建实况照片

1. 将 iPhone 拍摄的视频传到 Mac
2. （可选）使用 QuickTime Player 或 iMovie 剪辑到 3 秒
3. 导出为 MP4 格式
4. 运行转换脚本
5. 使用 AirDrop 传回 iPhone

### 工作流程 2: 从社交媒体视频创建实况照片

1. 下载视频（MP4 格式）
2. 如果需要，剪辑到合适长度
3. 运行转换脚本
4. 传输到 iPhone

## 故障排除

### 问题: "command not found: ffmpeg"

**解决方案:**
```bash
brew install ffmpeg exiftool
```

### 问题: HEIC 转换失败

**解决方案:** 确保你使用的是 macOS 系统。HEIC 编码需要 Apple 的硬件加速支持。

### 问题: 导入后不是实况照片

**检查清单:**
- [ ] 同时传输了 .HEIC 和 .MOV 文件
- [ ] 两个文件名称相同（除扩展名）
- [ ] 文件没有被重命名或分开传输
- [ ] iPhone 运行 iOS 9 或更高版本
