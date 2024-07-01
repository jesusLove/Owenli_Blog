package modal_test

import (
	"go_code/main/chapter14/testingDemo2/modal"
	"testing"
)

func TestStore(t *testing.T) {
	// 1. 创建一个monster实例
	monster := modal.NewMonster("owenli", 23, "ios developer")
	// 2.
	_, err := monster.Store()
	if err != nil {
		t.Fatalf("Store单元测试执行错误%v", err)
	}
	t.Logf("Store测试成功。。。。")
}

func TestRestore(t *testing.T) {
	var monster = &modal.Monster{}
	res := monster.Restore()
	if res.Name != "owenli" {
		t.Fatalf("monster.Restore()错误，希望为owenli，实际%v", res.Name)
	}
	t.Logf("Monster.Restore()测试通过")
}
