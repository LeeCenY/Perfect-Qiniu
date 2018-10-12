# Perfect-Qiniu：Swift Perfect 服务器上传文件到七牛云

依赖库：

```swift
.package(url: "https://github.com/PerfectlySoft/Perfect-CURL.git", from: "3.0.6"),
.package(url: "https://github.com/PerfectlySoft/Perfect-Crypto.git", from: "3.1.2") 
```
安装：
```swift
.package(url: "https://github.com/LeeCenY/Perfect-Qiniu.git", from: "1.0.4") 
```
使用：
```swift

let config = QiniuConfiguration(accessKey: AccessKey, secretKey: SecretKey, scope: scope, fixedZone: .HNzone, DEBUG: false)
_ = try Qiniu.upload(fileName: zipName, file: thisZipFile, config: config)

```

异常处理：
```swift
public enum UploadError: Error {
case badToken
case RequestfFailed(String)
}
```
