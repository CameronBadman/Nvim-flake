public class CalculatorTest {
    
    private Calculator calculator = new Calculator();
    
    // Test 1: Type "@Test" - should auto-complete and import org.junit.jupiter.api.Test
    public void testAddition() {
        // Test 2: Type "Assert" - should show JUnit assertions and auto-import
        // Try: assertEquals, assertTrue, assertThat, etc.
        
        int result = calculator.add(2, 3);
        // Type "Assert" here and see if you get completion
        
        // Test 3: Type "assertThat" - should auto-import from Hamcrest if available
        
    }
    
    // Test 4: Type "@" - should show annotation completions
    public void testSubtraction() {
        // Test 5: Try typing "List" - should auto-complete and import java.util.List
        // Test 6: Type "Arrays." - should show static methods and auto-import java.util.Arrays
        
        // Test 7: Type "Collections." - should show static methods
        
    }
    
    // Test 8: Type "@BeforeEach" - should auto-complete and import
    public void setUp() {
        calculator = new Calculator();
    }
    
    // Test some object method completions
    public void testObjectMethods() {
        String text = "hello world";
        // Test 9: Type "text." - should show String methods
        
        // Test 10: Type "Optional." - should show Optional static methods
        
        // Test 11: Type "Stream." - should show Stream static methods
        
    }
}

// File: src
