<div>

[**简体中文**](README_zh_CN.md)

</div>

## FlClash F-Droid Repo

The official F-Droid repository for FlClash.

## Usage

Copy what your need to your F-Droid client:

|             |                                                                                |
| ----------- | ------------------------------------------------------------------------------ |
| Direct Link | `https://EyKettle.github.io/FlClash-fdroid-repo/repo?fingerprint=B3CDD351E9835637EDF4F22FF2B79A608BFCAC535646D843F0DE9A8DD01E6E08` |
| Repo name   | FlClash                                                                      |
| URL         | `https://EyKettle.github.io/FlClash-fdroid-repo/repo`                         |
| fingerprint | `B3CDD351E9835637EDF4F22FF2B79A608BFCAC535646D843F0DE9A8DD01E6E08`                                                                  |

Also you can scan the QR Code to add this repo:

![QR Code](https://EyKettle.github.io/FlClash-fdroid-repo/repo/index.png)

## Publish a Release APK

Fetch a FlClash release APK into `tmp/`, then commit and push it to trigger the deploy workflow:

```bash
scripts/fetch-flclash-release-apk.sh 0.8.94
git add tmp/FlClash-0.8.94-android-arm64-v8a.apk
git commit -m "Update from v0.8.94"
git push origin main
```
