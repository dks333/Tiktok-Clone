# TikTok Clone



## Structure

<p align="center">
  <img src="/Images/Notes/Structure.png" />
</p>

## Video Cache (L2 Cache)

All videos downloaded from Network Model are stored in both memory(**NSCache**) and disk(**FileManager**). 

1. Hash the key using the `SHA-2` method provided by `CryptoKit`. 
2. Check if this encrypted key exists in either memory cache or disk cache.
3. If found in memory cache, return the url path of the file location.
4. If found in disk cache,  return the url path of the file location and store data in memory cache.
5. If not found in neither of them, request to download the video. 

### Read

```Swift
func queryDataFromCache(key: String, fileExtension: String?, completion: @escaping (_ data: Any?) -> Void){
        if let data = dataFromMemoryCache(key: key) {
            completion(data)
        } else if let data = dataFromDiskCache(key: key, fileExtension: fileExtension) {
            storeDataToMemoryCache(data: data, key: key)
            completion(data)
        } else {
            completion(nil)
        }
}
```

### Write

``` Swift
func storeDataToCache(data: Data?, key: String, fileExtension: String?) {
		dispatchQueue?.async {
        self.storeDataToMemoryCache(data: data, key: key)
        self.storeDataToDiskCache(data: data, key: key, fileExtension: fileExtension)
    }
}
```

### Delete

```Swift
func clearCache(completion: @escaping (_ size: String) -> Void){
    dispatchQueue?.async {
        self.clearMemoryCache()
        let size = self.clearDiskCache()
        DispatchQueue.main.async {
            completion(size)
        }
    }
}
```

### Encryption

```swift
private func sha2(key: String) -> String {
    let inputData = Data(key.utf8)
    let hashed = SHA256.hash(data: inputData)
    let hashString = hashed.compactMap { String(format: "%02x", $0) }.joined()
    return hashString
}
```



## Home

### UI Structure

<p align="center">
  <img src="/Images/Notes/HomeUI.png" />
</p>

Home page is mainly build with a table view that has full screen cells `HomeTableViewCell`. The cells contains multiple UIButtons and UILabel to present information acquired from viewmodel.

#### Comment PopUp View

A table view that contains comment information. I used a tap gesture and a pan gesture to handle the dismiss of the comment popup view. 

### Downloading Video While Streaming

Resource: [Downloading Video While Streaming using AVAssetResourceLoaderDelegate and URLSession](https://medium.com/@EugeneZZI/understanding-avassetresourceloaderdelegate-b90b3fe2c059)

### Pause and Like Animation using gestures

I used to `UITapGestureRecognizer` to detect single taps and double taps. By using gesture's property `numberOfTapsRequired`, I am able to distinguish between different user interactions.

### Design Pattern

I am using MVVM with RxSwift in this module. The ViewModel manages all logic in network and user interaction bindings.

## Profile

### UI Structure

- Profile
  - Collection View Flow Layout
  - Stretchy Header





// Transition Animation between views

// Firebase Database Design (NoSQL Database)

- User, Post, Comment, Video

