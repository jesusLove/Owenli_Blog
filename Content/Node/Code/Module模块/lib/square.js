// module.exports属性可以被赋予一个新的值（例如函数或对象）。
module.exports = class Square {
  constructor(width) {
    this.width = width
  }
  area() {
    return this.width ** 2
  }
}