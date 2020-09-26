# TikTok Clone



## Structure

![](/Images/Notes/Structure.png)

## Home

### UI Structure



// UI Flow of each page

- Home
  - Feed 
  - Comment Pop Up
- Profile
  - Collection View Flow Layout
  - Stretchy Header

// Transition Animation between views

// Smooth Scrolling

// Network(Post & Get) （SHA-2 Hashing）

//  Caching

1. 当图片下载完成之后除了保存到内存缓存中之外,还需要保存一份到磁盘缓存中

2. 当图片需要显示的时候,先检查内存缓存,如果内存缓存中有数据那么就直接设置

3. 如果内存缓存中没有数据,那么再去检查磁盘缓存

4.  如果有数据,那么就直接拿来设置就可以 | 保存一份到内存缓存中

5.  如果没有数据,那么这个时候再去下载数据

// Play While Download

- https://medium.com/@EugeneZZI/understanding-avassetresourceloaderdelegate-b90b3fe2c059

// Firebase Database Design (NoSQL Database)

- User, Post, Comment, Video

