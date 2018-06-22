var fs = require('fs')

var readerStream = fs.createReadStream('input.txt')
var writerStream = fs.createWriteStream('output.txt', {'flags': 'a'})
// 管道读写操作
// 读取input.txt内容，写入到output.txt文件中
readerStream.pipe(writerStream)

console.log('程序执行完毕')
