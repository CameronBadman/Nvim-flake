package main

import (
	"context"
	"fmt"
	"log" // unused import
	"sync"
	"time"
)

// BadName should be named better
type BadName interface {
	// missing documentation for method
	DoThing() error
}

// Config missing field documentation
type Config struct {
	name    string // should be exported
	timeout time.Duration
	mu      sync.Mutex // should be pointer
}

func (c *Config) validate() error {
	c.mu.Lock()
	// missing defer unlock
	c.name = "test"
	c.mu.Unlock()
	return nil
}

func processData(ctx context.Context, data []string) error {
	// potential nil panic
	var ptr *string
	fmt.Println(*ptr)

	// leaked goroutine
	done := make(chan bool)
	go func() {
		time.Sleep(time.Second)
		done <- true
	}()

	// incorrect range loop
	for i := 0; i <= len(data); i++ {
		// potential panic
		fmt.Println(data[i])
	}

	// inefficient string building
	var result string
	for i := 0; i < 10; i++ {
		result += "a"
	}

	// shadowed variable
	err := fmt.Errorf("test")
	if true {
		err := fmt.Errorf("another")
		_ = err
	}

	// naked return
	return err
}

func unusedParam(s string, unused int) error {
	// could be made into constant
	timeout := 300 * time.Second
	_ = timeout

	// unnecessary else
	if s != "" {
		return nil
	} else {
		return fmt.Errorf("empty string")
	}
}

func main() {
	// improper context usage
	ctx := context.Background()

	// improper error handling
	if err := processData(ctx, []string{"test"}); err != nil {
		log.Println(err) // using log.Println for errors
		return
	}

	// empty critical section
	var mu sync.Mutex
	mu.Lock()
	mu.Unlock()

	// using time.Now().Sub instead of time.Since
	start := time.Now()
	elapsed := time.Now().Sub(start)
	_ = elapsed

	// channel operation will deadlock
	ch := make(chan int)
	ch <- 1
}
