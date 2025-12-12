---
title: 全网最强白嫖！Cloudflare R2 双桶流保姆级教程
subtitle: NovaEdge · 创作与实验
description: ""                # 首页摘要 / SEO 描述，可空
cover: /img/default-cover.jpg  # 封面图路径，不用的话可以删掉这一行
date: 2025-12-12 10:00:00      # 记得改今天时间
updated: 2025-12-12 10:00:00   # 一般和 date 相同，后面更新再改
categories:
  - 会员教程                     # 改成：教程 / 实战 / 会员教程 等
tags:
  -cloudflare                           # 按需添加：比如 AI / Sora / ChatGPT
toc: true                      # 是否显示目录
password: ""                   # 以后真做加密再用
paywall: false                 # false=免费；true=付费（给会员模板用）
---

# 全网最强白嫖！Cloudflare R2 双桶流保姆级教程

> 想拥有一个**永不限速、完全私密**的个人云盘，外加一个**全球CDN加速**的博客图床？而且这一切还都是**免费**的？
>
> 通过本教程，你将实现：
>
> - 🔒 **数字保险箱**：本地挂载 Z 盘，文件自动加密上传，黑客拿到也是乱码。
> - ⚡ **极速图床**：绑定自定义域名，全球 CDN 加速，写博客神器。

---

## 🔥 摘要（Summary）

**核心优势：** Cloudflare R2 免费层包含 10GB 存储 + 1000万次读取/月。对于个人文档和博客图床，这几乎是永久免费的。

---

## 📌 正文开始（Start）

## 🛠️ 第一步：工具下载

工欲善其事，必先利其器。请先下载并安装以下工具：

[🌐 注册 Cloudflare 账号](https://dash.cloudflare.com/)[📥 下载 Rclone (Windows 64Bit)](https://rclone.org/downloads/)[📥 下载 WinFSP (挂载必须)](https://github.com/winfsp/winfsp/releases)[📥 下载 PicGo (图床工具)](https://github.com/Molunerfinn/PicGo/releases)

\* Rclone 下载后请解压到 `C:\rclone` 目录下。

## ☁️ 第二步：Cloudflare 后台配置 (双桶策略)

### 1. 创建私有桶 (保险箱)

1. 登录 Cloudflare R2，点击 **Create bucket**。
2. 名称：`my-safe-box` (请起一个你喜欢的独一无二的名字)。
3. 位置：**Automatic**。
4. **注意：** 这个桶保持默认，不要开启公开访问。

### 2. 创建公有桶 (图床)

1. 再次点击 **Create bucket**。
2. 名称：`my-img-bed`。
3. 进入该桶的 **Settings** -> **Public Access**。
4. 点击 **Connect Domain** (推荐)，输入你的二级域名 (如 `img.example.com`)。
5. *(如果没有域名，可以开启 R2.dev subdomain，但速度和美观度较差)*。

### 3. 获取 API 令牌 (通用钥匙)

- 回到 R2 首页，点击右侧 **Manage R2 API Tokens** -> **Create API Token**。

- **Permissions**: 选 **Admin Read & Write** (管理员读写)。

- **Specify bucket(s)**: 选 **All buckets**。

- **TTL**: 选 **Forever**。

- 创建后，

  务必复制以下三个信息(只显示一次)：

  ```text
  Access Key ID: (你的ID)
  Secret Access Key: (你的密钥)
  Endpoint: https://(你的账户ID).r2.cloudflarestorage.com
  ```

### 4. (省钱必做) 配置 CDN 缓存

为了防止 R2 免费读取额度被刷爆，我们需要设置缓存。

- 进入域名主页 -> **Caching** -> **Cache Rules**。
- 创建规则：匹配 Hostname 等于 `img.example.com`。
- **Edge TTL**: 选择 `Ignore cache-control...` 并设置为 **1 Month** (一个月)。

## 💻 第三步：部署私有云盘 (Rclone + WinFSP)

确保你已经安装了 WinFSP，并将 Rclone 解压到了 `C:\rclone`。

### 1. 配置连接

在 `C:\rclone` 文件夹内右键打开终端 (PowerShell)，输入：

```powershell
.\rclone config
```

**交互式配置流程：**

```text
n  (新建)
name: cf-base
Type: 搜索 Amazon S3 (通常是4或5)
Provider: 搜索 Cloudflare R2 (通常是6)
Access Key ID: 粘贴你的 Key ID
Secret Access Key: 粘贴你的 Secret Key
Region: auto
Endpoint: 粘贴你的 Endpoint 链接
(其余回车保持默认)
```

### 2. 配置加密层 (Crypt)

继续在 config 中新建一个配置：

```text
n (新建)
name: safe-encrypted
Type: 搜索 Encrypt/Decrypt (通常是15左右)
Remote to encrypt: cf-base:my-safe-box  (基础配置名:私有桶名)
Filename Encryption: standard
Directory Name Encryption: true
Password: 设置一个强密码 (一定要记住！丢失无法找回数据)
```

### 3. 备份配置文件 (⚠️重要)

你的密码和连接信息都保存在配置文件中，换电脑或重装系统时需要它。请运行以下命令找到它的位置并进行备份：

```powershell
.\rclone config file复制
```

*屏幕会显示 `rclone.conf` 的具体路径，请务必将该文件复制一份保存到安全的地方（如邮箱、U盘）。*

### 4. 一键挂载脚本

在 `C:\rclone` 目录下新建一个文本文件，重命名为 `mount-z.bat`，右键编辑，复制以下代码：

```
@echo off
title Private Safe Box Mounter

cd /d C:\rclone

:: 挂载为本地 Z 盘，配置 5G 本地缓存确保流畅
rclone mount safe-encrypted: Z: ^
 --vfs-cache-mode full ^
 --vfs-cache-max-size 5G ^
 --vfs-cache-max-age 24h ^
 --dir-cache-time 15m ^
 --transfers 4 ^
 --network-mode ^
 --no-modtime ^
 --links ^
 --volname "My_Safe_Box"

pause
```

**使用方法：** 双击这个 `bat` 文件，你的“我的电脑”里就会出现一个 Z 盘！往里面拖文件会自动加密上传。

## 🖼️ 第四步：部署极速图床 (PicGo)

### 1. 安装插件

打开 PicGo -> 插件设置 -> 搜索并安装 `picgo-plugin-s3`。

### 2. 配置参数

点击左侧 **Amazon S3**，填入：

- **配置名**: R2-Public
- **应用密钥 ID / 密钥**: 填之前的 Key ID 和 Secret。
- **桶名**: `my-img-bed` (注意是公有桶的名字)。
- **文件路径**: `img/{year}/{month}/{fileName}.{ext}`
- **自定义域名**: `https://img.example.com` (注意加 https)。
- **自定义节点**: 填 Endpoint 链接。

### 3. 享受成果

设置快捷键 (如 `Ctrl+Shift+P`) 为“上传剪贴板图片”。
截图 -> 复制 -> 按快捷键 -> 粘贴，你将获得一个全球加速的图片链接！
