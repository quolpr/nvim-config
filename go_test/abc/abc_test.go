package abc_test

import (
	"abc/go_test/abc"
	"fmt"
	"testing"
	"time"
)

func TestSum(t *testing.T) {
	a := 1
	b := 2
	c := abc.Sum(a, b)

	time.Sleep(time.Second * 1)

	if c != a+b+1 {
		t.Errorf("Sum(%d, %d) = %d, want %d", a, b, c, a+b)
	}
}
func TestSum2(t *testing.T) {
	fmt.Println("TestSum2 heyy!")

	t.Run("TestSum", func(t *testing.T) {
		a := 1
		b := 2
		c := abc.Sum(a, b)
		if c != a+b {
			t.Errorf("Sum(%d, %d) = %d, want %d", a, b, c, a+b)
		} else {
			t.Log("TestSum passed")
		}
	})
}
