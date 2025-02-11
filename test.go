package main

import (
	"fmt"
	"sync"
)

// Person represents a person with a name and age
type Person struct {
	name string // This will test field alignment hints
	Age  int    // This will test exported field hints
}

// This function will test unused parameter warnings
func unusedParamTest(name string, age int) {
	fmt.Println("Hello")
}

// This will test nil pointer detection
func nilTest(p *Person) {
	fmt.Println(p.name) // LSP should warn about possible nil pointer
}

// This will test shadow variable detection
func shadowTest() {
	x := 5
	{
		x := 10 // LSP should warn about shadowed variable
		fmt.Println(x)
	}
}

// This will test lock copying detection
type Counter struct {
	mu sync.Mutex
	count int
}

// This should trigger a copylocks warning
func (c Counter) increment() { // LSP should warn about copying mutex
	c.mu.Lock()
	defer c.mu.Unlock()
	c.count++
}

func main() {
	// Test completion
	p := Person{
		// LSP should provide completion here
	}

	// Test type hints
	nums := []int{1, 2, 3} // LSP should show type information
	for _, num := range nums {
		// LSP should show type hints for range variables
		fmt.Println(num)
	}

	// Test unused variable warning
	unused := "test"

	// Test interface assertion
	var i interface{} = "hello"
	_, ok := i.(string)
	if !ok {
		fmt.Println("not a string")
	}

	nilTest(nil) // Should trigger nil warning
}
