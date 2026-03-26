# 🎬 yt-dlp Smart Downloader（Windows BAT）

一个 **真正开箱即用的 yt-dlp 自动化下载脚本**

无需安装环境 → 无需命令行经验 → 输入视频地址即可下载

---

## ✨ 项目特色

✅ 自动检测并安装所有依赖工具
✅ 自动安装 Node.js（用于解析 YouTube JS）
✅ 自动下载 / 更新 yt-dlp
✅ 自动下载完整 FFmpeg 工具包
✅ 支持 cookies 登录视频下载
✅ 自动显示全部格式 → 手动选择
✅ 默认优先下载 4K + 音频
✅ 自动封装 MKV + 嵌入字幕 + 封面 + 元数据
✅ 高并发下载（16线程）
✅ 失败智能提示

---

## 📦 所需文件结构

将以下文件放入 **同一文件夹**

```
yt-downloader/
│
├── yt.bat
├── www.youtube.com_cookies.txt
```

> 其他工具（yt-dlp / ffmpeg / node）
> 脚本会自动下载安装 ✔

---

## 🧰 自动安装的工具

脚本会自动检测：

| 工具      | 用途                    |
| ------- | --------------------- |
| Node.js | 解析 YouTube JavaScript |
| yt-dlp  | 视频下载核心                |
| FFmpeg  | 合并音视频 / 转封装           |

如果缺失：

👉 会自动下载安装最新版

---

## 🍪 Cookies 文件说明（非常重要）

必须提供：

```
www.youtube.com_cookies.txt
```

用于：

* 下载会员视频
* 下载年龄限制视频
* 下载私人视频
* 防止限速
* 防止403错误

### 如何获取 Cookies

推荐浏览器插件：

⭐ Get cookies.txt LOCALLY

导出：

```
youtube.com
```

保存为：

```
www.youtube.com_cookies.txt
```

---

## 🚀 使用方法（超级简单）

### 方法 1（推荐）

双击：

```
yt.bat
```

然后：

```
输入视频链接 → 回车
```

脚本会：

```
① 自动获取所有清晰度格式
② 你选择格式
③ 自动下载
```

---

### 方法 2（更快）

直接拖动视频链接到 bat 文件

或命令行：

```
yt.bat https://youtube.com/xxxx
```

---

## 🎯 默认下载策略

如果直接回车不选格式：

脚本会自动按顺序尝试：

```
315+140 → 401+140 → 313+140 → bestvideo+bestaudio → best
```

也就是：

👉 优先 4K
👉 再 2K
👉 再最佳质量

---

## 📁 输出文件示例

```
My Video Title [abc123] [3840x2160].mkv
```

包含：

✅ 视频
✅ 音频
✅ 字幕（全部语言）
✅ 封面
✅ 元数据
✅ 章节

---

## ⚡ 下载优化参数

脚本内置高性能配置：

```
--concurrent-fragments 16
--retries 15
--fragment-retries 10
```

适合：

* 大视频
* 4K HDR
* 长直播回放

---

## ❗ 常见问题

### ❌ 下载失败

可能原因：

1️⃣ 选的格式不存在
👉 直接回车使用默认

2️⃣ cookies 过期
👉 重新导出

3️⃣ 网络被限制
👉 使用代理

4️⃣ FFmpeg 未正确下载
👉 删除 ffmpeg.exe 重新运行

---

### ❌ Node.js 未检测到

脚本会自动安装

若仍失败：

手动安装：

```
https://nodejs.org
```

---

## ❤️ 适合人群

✔ 不会命令行
✔ 想一键下载 YouTube
✔ 想自动下载 4K
✔ 想下载会员视频
✔ 想长期使用稳定方案

---

## ⭐ 项目目标

打造：

> **Windows 最强 yt-dlp 一键下载脚本**

真正做到：

```
下载 = 输入链接
```

---

## 📜 License

MIT License
