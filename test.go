package main

import (
    "encoding/json"
    "errors"
    "fmt"
    "io/ioutil" // deprecated package
    "net/http"
    "time"
    "unsafe"
)

// Poorly aligned struct (should trigger staticcheck's struct alignment check)
type poorlyAlignedStruct struct {
    a             int
    b             string
    c             float64
    d             bool
    longFieldName int
}

// Deprecated function
// Deprecated: Use NewCalculator instead
type Calculator struct {
    value int
}

// Deprecated: Use NewCalculator instead
func NewCalc() *Calculator {
    return &Calculator{value: 0}
}

func (c *Calculator) Add(x int) {
    c.value += x
}

func main() {
    // Unused variable
    unused := 42

    // Shadowed variable
    x := 10
    if true {
        x := 20
        fmt.Println(x)
    }

    // Deprecated package usage
    data, _ := ioutil.ReadFile("test.txt")
    fmt.Println(string(data))

    // Unhandled error
    file, _ := os.Open("missing.txt")
    defer file.Close()

    // Type mismatch
    var y int = "hello" // should trigger type check error

    // Unused parameter
    testUnusedParam(10)

    // Testing struct alignment
    s := poorlyAlignedStruct{
        a:    1,
        b:    "test",
        c:    3.14,
        d:    true,
        longFieldName: 100,
    }
    fmt.Println(s)

    // Testing deprecated function
    calc := NewCalc()
    calc.Add(5)
    calc.Subtract(2)
    fmt.Println("Calculator value:", calc.value)

    // Testing unsafe pointer usage
    ptr := unsafe.Pointer(&x)
    fmt.Println(ptr)

    // Testing HTTP response handling
    resp, err := http.Get("https://example.com")
    if err != nil {
        fmt.Println("Error making request:", err)
    }
    // Missing resp.Body.Close() (should trigger httpresponse analysis)

    // Testing time format issues
    t := time.Now()
    fmt.Println(t.Format("2006-01-02")) // Correct format
    fmt.Println(t.Format("2023-01-02")) // Incorrect format (should trigger timeformat analysis)

    // Testing unmarshal issues
    var result map[string]interface{}
    json.Unmarshal([]byte(`{"key": "value"}`), &result) // Missing error handling (should trigger unmarshal analysis)

    // Testing loop closure issues
    var funcs []func()
    for i := 0; i < 3; i++ {
        funcs = append(funcs, func() {
            fmt.Println(i) // Should trigger loopclosure analysis (captures loop variable)
        })
    }
    for _, f := range funcs {
        f()
    }
}

func testUnusedParam(a int) { // unused parameter
    var b int // unused variable
    fmt.Println("This function has unused parameters and variables")
}

func missingReturn() error {
    // This should trigger a fillreturns suggestion
}

func unusedFunction() {
    fmt.Println("This function is never used")
}

// Function with unhandled error
func writeToFile(filename string, data []byte) {
    file, _ := os.Create(filename)
    defer file.Close()
    file.Write(data)
}

// Function with incorrect return type
func incorrectReturn() int {
    return "not an int" // should trigger type check error
}

// Function with unreachable code
func unreachableCode() {
    return
    fmt.Println("This code is unreachable")
}

// Function with nil dereference potential
func nilDereference() {
    var ptr *int
    fmt.Println(*ptr) // should trigger nilness analysis
}

// Function with shadowed import
func shadowedImport() {
    fmt := "shadowed"
    fmt.Println(fmt) // should trigger shadow analysis
}
