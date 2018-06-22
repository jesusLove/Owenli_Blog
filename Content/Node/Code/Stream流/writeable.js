// 可写流
var fs = require('fs') // 引入文件系统模块

let data = 'Stream流：可写流代码实例'

// 创建一个可写流，写入到文件output.txt
var writerStream = fs.createWriteStream('output.txt')
// 使用UTF8编码写入数据
writerStream.write(data, 'utf8')

// 标记文件末尾
writerStream.end() 

// 处理流事件 ---> data, end, finish,and error

writerStream.on('finish', () => {
  console.log('写入成功')
})

writerStream.on('error', (err) => {
  console.log('写入失败' + err.stack)
})

console.log('程序执行完毕')

// * `data` - 当有数据可读时触发。

// * `end` - 没有更多的数据可读时触发。

// * `error` - 在接收和写入过程中发生错误时触发。

// * `finish` - 所有数据已被写入到底层系统时触发。