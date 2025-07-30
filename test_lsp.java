import java.util.*;
import java.util.stream.Collectors;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutionException;
import java.util.function.Function;
import java.util.function.Predicate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;

/**
 * Test Java class for LSP features
 * This class exercises various Java language features to test:
 * - Auto-completion
 * - Error detection
 * - Method signatures
 * - Import organization
 * - Type inference
 * - Code navigation
 */
public class TestLSP {
    
    private static final String APP_NAME = "Java LSP Test";
    private static final List<Person> people = new ArrayList<>();
    private static final Map<String, Integer> scores = new HashMap<>();
    
    public static void main(String[] args) {
        System.out.println("Welcome to " + APP_NAME + "!");
        
        try {
            // Test method calls and auto-completion
            initializeSampleData();
            
            // Test streams and lambda expressions
            testStreamOperations();
            
            // Test generics and collections
            testGenericMethods();
            
            // Test async operations
            testAsyncOperations();
            
            // Test exception handling
            testExceptionHandling();
            
            // Test static methods and utility classes
            String result = StringUtils.capitalize("hello world");
            System.out.println("Capitalized: " + result);
            
        } catch (Exception e) {
            System.err.println("Error in main: " + e.getMessage());
            e.printStackTrace();
        }
        
        System.out.println("Program completed successfully!");
    }
    
    /**
     * Initialize sample data for testing
     */
    private static void initializeSampleData() {
        people.add(new Person("Alice Johnson", 28, "alice@example.com"));
        people.add(new Person("Bob Smith", 35, "bob@example.com"));
        people.add(new Person("Charlie Brown", 19, "charlie@example.com"));
        people.add(new Person("Diana Prince", 42, "diana@example.com"));
        
        scores.put("Math", 85);
        scores.put("Science", 92);
        scores.put("History", 78);
        scores.put("English", 88);
        
        System.out.println("Initialized " + people.size() + " people and " + scores.size() + " scores");
    }
    
    /**
     * Test stream operations and functional programming
     */
    private static void testStreamOperations() {
        System.out.println("\n=== Stream Operations Test ===");
        
        // Test filtering and collecting
        List<Person> adults = people.stream()
            .filter(p -> p.getAge() >= 21)
            .sorted(Comparator(Person::getName))
            .collect(Collectors.toList());
            
        System.out.println("Adults: " + adults.size());
        
        // Test mapping and reducing
        OptionalDouble averageAge = people.stream()
            .mapToInt(Person::getAge)
            .average();
            
        if (averageAge.isPresent()) {
            System.out.printf("Average age: %.2f%n", averageAge.getAsDouble());
        }
        
        // Test grouping
        Map<Boolean, List<Person>> groupedByAdult = people.stream()
            .collect(Collectors.groupingBy(p -> p.getAge() >= 21));
            
        System.out.println("Adults: " + groupedByAdult.get(true).size());
        System.out.println("Minors: " + groupedByAdult.get(false).size());
        
        // Test method references
        people.stream()
            .map(Person::getName)
            .map(String::toUpperCase)
            .forEach(System.out::println);
    }
    
    /**
     * Test generic methods and type inference
     */
    private static void testGenericMethods() {
        System.out.println("\n=== Generic Methods Test ===");
        
        // Test generic utility methods
        List<String> names = extractField(people, Person::getName);
        List<Integer> ages = extractField(people, Person::getAge);
        
        System.out.println("Names: " + names);
        System.out.println("Ages: " + ages);
        
        // Test generic filtering
        List<Person> youngPeople = filterItems(people, p -> p.getAge() < 30);
        System.out.println("Young people: " + youngPeople.size());
        
        // Test Optional operations
        Optional<Person> oldestPerson = people.stream()
            .max(Comparator.comparing(Person::getAge));
            
        oldestPerson.ifPresent(p -> 
            System.out.println("Oldest person: " + p.getName() + " (" + p.getAge() + ")"));
    }
    
    /**
     * Test async operations with CompletableFuture
     */
    private static void testAsyncOperations() {
        System.out.println("\n=== Async Operations Test ===");
        
        try {
            // Test async method calls
            CompletableFuture<String> future1 = processDataAsync("Hello");
            CompletableFuture<String> future2 = processDataAsync("World");
            
            CompletableFuture<String> combined = future1.thenCombine(future2, 
                (s1, s2) -> s1 + " " + s2);
                
            String result = combined.get(); // This will block
            System.out.println("Combined result: " + result);
            
        } catch (InterruptedException | ExecutionException e) {
            System.err.println("Async operation failed: " + e.getMessage());
        }
    }
    
    /**
     * Test exception handling patterns
     */
    private static void testExceptionHandling() {
        System.out.println("\n=== Exception Handling Test ===");
        
        try {
            // This should throw an exception
            riskyOperation(-1);
        } catch (IllegalArgumentException e) {
            System.out.println("Caught expected exception: " + e.getMessage());
        }
        
        // Test try-with-resources (uncomment if you want to test file operations)
        /*
        try (Scanner scanner = new Scanner(System.in)) {
            System.out.println("Scanner created and will be auto-closed");
        }
        */
        
        // Test multiple exception types
        try {
            performFileOperation("nonexistent.txt");
        } catch (IOException e) {
            System.out.println("IO Exception: " + e.getMessage());
        } catch (SecurityException e) {
            System.out.println("Security Exception: " + e.getMessage());
        }
    }
    
    // Utility methods for testing generics and method signatures
    
    /**
     * Generic method to extract field values from a list
     */
    public static <T, R> List<R> extractField(List<T> items, Function<T, R> extractor) {
        return items.stream()
            .map(extractor)
            .collect(Collectors.toList());
    }
    
    /**
     * Generic method to filter items
     */
    public static <T> List<T> filterItems(List<T> items, Predicate<T> predicate) {
        return items.stream()
            .filter(predicate)
            .collect(Collectors.toList());
    }
    
    /**
     * Async method for testing CompletableFuture
     */
    private static CompletableFuture<String> processDataAsync(String input) {
        return CompletableFuture.supplyAsync(() -> {
            // Simulate some processing time
            try {
                Thread.sleep(100);
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
                throw new RuntimeException("Processing interrupted", e);
            }
            return input.toUpperCase();
        });
    }
    
    /**
     * Method that throws exceptions for testing
     */
    private static void riskyOperation(int value) {
        if (value < 0) {
            throw new IllegalArgumentException("Value cannot be negative: " + value);
        }
        System.out.println("Operation completed successfully with value: " + value);
    }
    
    /**
     * Method for testing file operations and multiple exception types
     */
    private static void performFileOperation(String filename) throws IOException {
        // This will likely throw IOException for nonexistent files
        List<String> lines = Files.readAllLines(Paths.get(filename));
        System.out.println("Read " + lines.size() + " lines from " + filename);
    }
}

/**
 * Person class for testing object-oriented features
 */
class Person {
    private final String name;
    private final int age;
    private final String email;
    private final LocalDateTime createdAt;
    
    public Person(String name, int age, String email) {
        this.name = Objects.requireNonNull(name, "Name cannot be null");
        this.age = age;
        this.email = Objects.requireNonNull(email, "Email cannot be null");
        this.createdAt = LocalDateTime.now();
    }
    
    // Getters
    public String getName() { return name; }
    public int getAge() { return age; }
    public String getEmail() { return email; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    
    // Computed properties
    public boolean isAdult() {
        return age >= 18;
    }
    
    public String getDisplayName() {
        return String.format("%s (%d years old)", name, age);
    }
    
    // Override methods
    @Override
    public String toString() {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
        return String.format("Person{name='%s', age=%d, email='%s', created=%s}", 
            name, age, email, createdAt.format(formatter));
    }
    
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Person person = (Person) o;
        return age == person.age && 
               Objects.equals(name, person.name) && 
               Objects.equals(email, person.email);
    }
    
    @Override
    public int hashCode() {
        return Objects.hash(name, age, email);
    }
}

/**
 * Utility class for testing static methods
 */
class StringUtils {
    private StringUtils() {
        // Utility class - prevent instantiation
    }
    
    public static String capitalize(String input) {
        if (input == null || input.isEmpty()) {
            return input;
        }
        return input.substring(0, 1).toUpperCase() + input.substring(1).toLowerCase();
    }
    
    public static boolean isValidEmail(String email) {
        return email != null && 
               email.contains("@") && 
               email.contains(".") && 
               email.length() > 5;
    }
    
    public static String truncate(String input, int maxLength) {
        if (input == null || input.length() <= maxLength) {
            return input;
        }
        return input.substring(0, maxLength - 3) + "...";
    }
}

/**
 * Interface for testing interface features
 */
interface DataProcessor<T> {
    T process(T input);e questions about our products, server, or events please post them in ⁠community-q-and-a    and we'll answer in the threads. You can start asking now :bibicat:https://discord.gg/cloudflaredev?event=1388510798376075284 @Announcements
    
    default boolean isValid(T input) {
        return input != null;
    }
    
    static <T> boolean isEmpty(Collection<T> collection) {
        return collection == null || collection.isEmpty();
    }
}

/**
 * Enum for testing enum features
 */
enum Priority {
    LOW(1, "Low Priority"),
    MEDIUM(2, "Medium Priority"), 
    HIGH(3, "High Priority"),
    CRITICAL(4, "Critical Priority");
    
    private final int level;
    private final String description;
    
    Priority(int level, String description) {
        this.level = level;
        this.description = description;
    }
    
    public int getLevel() { return level; }
    public String getDescription() { return description; }
    
    public boolean isHigherThan(Priority other) {
        return this.level > other.level;
    }
}
