const EventEmitter = require('events') // 引入事件模块

const event = new EventEmitter() // 创建实例

// 注册监听器
event.on('event', () => {
  console.log('触发了一个事件！')
})

// 触发事件
event.emit('event')

// > 执行和结果
// node test_01.js
// 触发了一个事件！


// 注册监听器，并接受内容
event.on('message', (message) => {
  console.log('接收到的信息：' + message);
})
// 触发
event.emit('message', 'Hello world')


// 注意
// 使用ES6的箭头函数时，this不再执行events实例。
// 做个测试

event.on('test1', function () {
  console.log('this的指向：')
  console.log(this)
})
event.emit('test1')

// this的指向：
// EventEmitter {
//   _events:
//    { event: [Function],
//      message: [Function],
//      test1: [Function],
//      test2: [Function] },
//   _eventsCount: 4,
//   _maxListeners: undefined }


event.on('test2', () => {
  console.log('this的指向：')
  console.log(this)
})
event.emit('test2')

// this的指向：
// {}


let count = 0
event.on('add', () => {
  console.log(++count)
})
event.emit('add')
// count = 1
event.emit('add')
// count = 2


let onceCount = 0
event.once('once', () => {
  console.log(++onceCount) // 先 加 1 在输出
})
event.emit('once')
// 1 
event.emit('once')
// 忽略

//所有事件明后才能
console.log(event.eventNames())
// [ 'event', 'message', 'test1', 'test2', 'add' ]

// 最大监听器数量
console.log(event.getMaxListeners()) 
// 10
event.setMaxListeners(11)
console.log(event.getMaxListeners()) 
// 11


