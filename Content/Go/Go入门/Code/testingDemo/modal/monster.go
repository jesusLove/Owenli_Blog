package modal

import (
	"bufio"
	"encoding/json"
	"fmt"
	"os"
)

var filePath = "/Users/lqq/go/src/go_code/main/chapter14/testingDemo2/modal/monster.txt"

type Monster struct {
	Name  string `json:"name"`
	Age   int    `json:"age"`
	Skill string `json:"skill"`
}

func NewMonster(name string, age int, skill string) *Monster {
	return &Monster{
		Name:  name,
		Age:   age,
		Skill: skill,
	}
}

func (m *Monster) Store() (string, error) {
	// 1. 序列化m
	data, err := json.Marshal(m)
	if err != nil {
		fmt.Println("转换失败err=", err)
		return "", err
	}
	// 2. 打开文件
	file, err := os.OpenFile(filePath, os.O_WRONLY|os.O_CREATE, 0666)
	if err != nil {
		fmt.Println("文件打开失败err=", err)
		return "", err
	}
	defer file.Close()
	// 3. 创建Bwriter
	writer := bufio.NewWriter(file)
	_, writerErr := writer.WriteString(string(data))
	if err != nil {
		fmt.Println("写入文件失败err=", writerErr)
		return "", err
	}
	// 4. 写入到磁盘
	writer.Flush()
	return string(data), nil
}
func (m *Monster) Restore() *Monster {
	// 1. 打开文件
	file, err := os.OpenFile(filePath, os.O_RDONLY, 0666)
	if err != nil {
		fmt.Println("文件打开失败err=", err)
	}
	defer file.Close()

	// 2. reader
	reader := bufio.NewReader(file)

	data, err := reader.ReadString('\n')

	// 3. 反序列化
	err = json.Unmarshal([]byte(data), &m)
	if err != nil {
		fmt.Println("反序列化失败err=", err)
	}
	return m
}
