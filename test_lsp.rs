// test.rs - Comprehensive Rust LSP test file
use std::collections::HashMap;
use std::fmt::Display;

// Test trait definition and implementation
trait Drawable {
    fn draw(&self) -> String;
    fn area(&self) -> f64;
}

// Test struct with generics
#[derive(Debug, Clone)]
struct Rectangle<T> 
where 
    T: Copy + Display + std::ops::Mul<Output = T>,
{
    width: T,
    height: T,
    name: String,
}

impl<T> Rectangle<T> 
where 
    T: Copy + Display + std::ops::Mul<Output = T>,
{
    fn new(width: T, height: T, name: &str) -> Self {
        Self {
            width,
            height,
            name: name.to_string(),
        }
    }

    fn get_dimensions(&self) -> (T, T) {
        (self.width, self.height)
    }
}

impl<T> Drawable for Rectangle<T> 
where 
    T: Copy + Display + std::ops::Mul<Output = T> + Into<f64>,
{
    fn draw(&self) -> String {
        format!("Drawing {} ({}x{})", self.name, self.width, self.height)
    }

    fn area(&self) -> f64 {
        let w: f64 = self.width.into();
        let h: f64 = self.height.into();
        w * h
    }
}

// Test enum with methods
#[derive(Debug, PartialEq)]
enum Shape {
    Circle { radius: f64 },
    Square { side: f64 },
    Triangle { base: f64, height: f64 },
}

impl Shape {
    fn area(&self) -> f64 {
        match self {
            Shape::Circle { radius } => std::f64::consts::PI * radius * radius,
            Shape::Square { side } => side * side,
            Shape::Triangle { base, height } => 0.5 * base * height,
        }
    }

    fn perimeter(&self) -> f64 {
        match self {
            Shape::Circle { radius } => 2.0 * std::f64::consts::PI * radius,
            Shape::Square { side } => 4.0 * side,
            Shape::Triangle { base, height } => {
                // Assuming isosceles triangle for simplicity
                let side = (height * height + (base / 2.0) * (base / 2.0)).sqrt();
                base + 2.0 * side
            }
        }
    }
}

// Test async function
async fn fetch_data(url: &str) -> Result<String, Box<dyn std::error::Error>> {
    // Simulate network request
    tokio::time::sleep(tokio::time::Duration::from_millis(100)).await;
    Ok(format!("Data from {}", url))
}

// Test macro usage
macro_rules! create_shape {
    (circle, $radius:expr) => {
        Shape::Circle { radius: $radius }
    };
    (square, $side:expr) => {
        Shape::Square { side: $side }
    };
    (triangle, $base:expr, $height:expr) => {
        Shape::Triangle { base: $base, height: $height }
    };
}

// Test closure and iterator usage
fn process_numbers(numbers: Vec<i32>) -> Vec<i32> {
    numbers
        .into_iter()
        .filter(|&x| x > 0)
        .map(|x| x * 2)
        .collect()
}

// Test error handling
#[derive(Debug)]
enum MathError {
    DivisionByZero,
    NegativeSquareRoot,
}

impl std::fmt::Display for MathError {
    fn fmt(&self, f: &mut std::fmt::Formatter) -> std::fmt::Result {
        match self {
            MathError::DivisionByZero => write!(f, "Cannot divide by zero"),
            MathError::NegativeSquareRoot => write!(f, "Cannot take square root of negative number"),
        }
    }
}

impl std::error::Error for MathError {}

fn safe_divide(a: f64, b: f64) -> Result<f64, MathError> {
    if b == 0.0 {
        Err(MathError::DivisionByZero)
    } else {
        Ok(a / b)
    }
}

fn safe_sqrt(x: f64) -> Result<f64, MathError> {
    if x < 0.0 {
        Err(MathError::NegativeSquareRoot)
    } else {
        Ok(x.sqrt())
    }
}

// Test main function with various LSP features
#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    println!("Testing Rust LSP features!");

    // Test struct creation and method calls
    let rect = Rectangle::new(10.0, 5.0, "MyRectangle");
    println!("{}", rect.draw());
    println!("Area: {}", rect.area());

    // Test enum and pattern matching
    let shapes = vec![
        create_shape!(circle, 5.0),
        create_shape!(square, 4.0),
        create_shape!(triangle, 6.0, 3.0),
    ];

    let mut shape_areas = HashMap::new();
    for (i, shape) in shapes.iter().enumerate() {
        shape_areas.insert(i, shape.area());
        println!("Shape {}: {:?}, Area: {:.2}", i, shape, shape.area());
    }

    // Test closure and iterator
    let numbers = vec![-2, -1, 0, 1, 2, 3, 4, 5];
    let processed = process_numbers(numbers);
    println!("Processed numbers: {:?}", processed);

    // Test error handling
    match safe_divide(10.0, 2.0) {
        Ok(result) => println!("10 / 2 = {}", result),
        Err(e) => eprintln!("Error: {}", e),
    }

    match safe_divide(10.0, 0.0) {
        Ok(result) => println!("10 / 0 = {}", result),
        Err(e) => eprintln!("Error: {}", e),
    }

    // Test async function
    let data = fetch_data("https://api.example.com/data").await?;
    println!("Fetched: {}", data);

    // Test Option and Result chaining
    let maybe_number = Some("42");
    let result = maybe_number
        .and_then(|s| s.parse::<i32>().ok())
        .map(|n| n * 2)
        .filter(|&n| n > 50);
    
    println!("Chained result: {:?}", result);

    Ok(())
}

// Test module and visibility
mod utils {
    pub fn double(x: i32) -> i32 {
        x * 2
    }

    pub(crate) fn triple(x: i32) -> i32 {
        x * 3
    }

    #[allow(dead_code)]
    fn private_function() -> String {
        "This is private".to_string()
    }
}

// Test unit tests
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_rectangle_area() {
        let rect = Rectangle::new(4.0, 5.0, "TestRect");
        assert_eq!(rect.area(), 20.0);
    }

    #[test]
    fn test_shape_areas() {
        let circle = Shape::Circle { radius: 2.0 };
        let square = Shape::Square { side: 3.0 };
        
        assert!((circle.area() - (std::f64::consts::PI * 4.0)).abs() < 0.001);
        assert_eq!(square.area(), 9.0);
    }

    #[test]
    fn test_error_handling() {
        assert!(safe_divide(10.0, 0.0).is_err());
        assert!(safe_sqrt(-1.0).is_err());
        assert!(safe_divide(10.0, 2.0).is_ok());
        assert!(safe_sqrt(4.0).is_ok());
    }

    #[tokio::test]
    async fn test_async_function() {
        let result = fetch_data("test-url").await;
        assert!(result.is_ok());
        assert!(result.unwrap().contains("test-url"));
    }
}
