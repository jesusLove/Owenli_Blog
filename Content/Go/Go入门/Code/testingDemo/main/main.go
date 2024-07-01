package main

import (
	"fmt"
	"go_code/main/chapter14/testingDemo2/modal"
)

func main() {
	// 存入数据
	monster := modal.NewMonster("owenli", 23, "ios developer")
	monsterStr, err := monster.Store()
	if err != nil {
		fmt.Println(err)
	}
	fmt.Println(monsterStr)

	// 读取数据
	m := &modal.Monster{}
	m = m.Restore()
	fmt.Println(m)
}
