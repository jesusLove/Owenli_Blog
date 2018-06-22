// 
const circle = require('./lib/circle')
console.log(`半径为4的圆的面积是${circle.area(4)}周长是${circle.circumference(4)}`)

// 引入和创建实例
const Square = require('./lib/square')
const square = new Square(4)
console.log(`square的面积是${square.area()}`)


// 访问主模块
// 直接运行一个文件时， require.main被设为module
// 这意味着可以通过 require.main === module 来判断一个文件是否被直接运行：
// 对于 foo.js 文件，如果通过 node foo.js 运行则为 true，
// 但如果通过 require('./foo') 运行则为 false。
console.log(require.main === module)

// module提供了一个filename属性，所以可以通过检查require.main.filename来获取当前程序的入口点
console.log(require.main.filename)

//获取调用require()时加载的确切的文件名，使用require.resolve()函数
// require.resolve()做了什么？
//http://nodejs.cn/api/modules.html#modules_all_together


// 模块在第一次加载后会被缓存。 这也意味着（类似其他缓存机制）如果每次调用 require('foo') 都解析到同一文件，则返回相同的对象。
