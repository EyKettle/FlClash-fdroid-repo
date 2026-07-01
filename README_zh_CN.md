<div>

[**English**](README.md)

</div>

## FlClash F-Droid Repo

FlClash 官方 F-Droid 仓库。

## Usage

将你所需要的内容粘贴到你的 F-Droid 客户端中：

|          |                                                                                |
| -------- | ------------------------------------------------------------------------------ |
| 直接链接 | `https://EyKettle.github.io/flclash-fdroid-repo/repo?fingerprint=B3CDD351E9835637EDF4F22FF2B79A608BFCAC535646D843F0DE9A8DD01E6E08` |
| 仓库名   | FlClash                                                                        |
| 地址     | `https://EyKettle.github.io/FlClash-fdroid-repo/repo`                         |
| 指纹     | `B3CDD351E9835637EDF4F22FF2B79A608BFCAC535646D843F0DE9A8DD01E6E08`                                                                  |

你也可以扫描下方二维码来添加：
![二维码](https://EyKettle.github.io/flclash-fdroid-repo/repo/index.png)

## 发布 Release APK

下载 FlClash release APK 到 `tmp/`，然后提交并推送，触发 deploy workflow：

```bash
scripts/fetch-flclash-release-apk.sh 0.8.94
git add tmp/FlClash-*-android-*.apk
git commit -m "Update from v0.8.94"
git push origin main
```
