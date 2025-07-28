using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.IO;

namespace TestProject
{
    /// <summary>
    /// Main program class for testing C# LSP features
    /// </summary>
    public class Program
    {
        private static readonly string AppName = "LSP Test App";
        private static List<Person> people = new List<Person>();

        public static async Task Main(string[] args)
        {
            Console.WriteLine($"Welcome to {AppName}!");
            
            // Test auto-completion and method signatures
            await InitializePeopleAsync();
            
            // Test LINQ and extension methods
            var adults = people.Where(p => p.Age >= 18).ToList();
            Console.WriteLine($"Found {adults.Count} adults");
            
            // Test error detection (uncomment to see errors)
            // Person invalidPerson = null;
            // Console.WriteLine(invalidPerson.Name); // Should show null reference warning
            
            // Test async/await patterns
            var result = await ProcessDataAsync("test data");
            Console.WriteLine($"Processing result: {result}");
            
            // Test exception handling
            try
            {
                RiskyMethod();
            }
            catch (InvalidOperationException ex)
            {
                Console.WriteLine($"Caught exception: {ex.Message}");
            }
            
            Console.WriteLine("Press any key to exit...");
            Console.ReadKey();
        }
        
        private static async Task InitializePeopleAsync()
        {
            // Simulate async data loading
            await Task.Delay(100);
            
            people.Add(new Person("John Doe", 25, "john@example.com"));
            people.Add(new Person("Jane Smith", 30, "jane@example.com"));
            people.Add(new Person("Bob Wilson", 17, "bob@example.com"));
            
            Console.WriteLine($"Initialized {people.Count} people");
        }
        
        private static async Task<string> ProcessDataAsync(string input)
        {
            if (string.IsNullOrWhiteSpace(input))
                throw new ArgumentException("Input cannot be null or empty", nameof(input));
                
            // Simulate async processing
            await Task.Delay(50);
            
            return input.ToUpperInvariant();
        }
        
        private static void RiskyMethod()
        {
            // Intentionally throws exception for testing
            throw new InvalidOperationException("This is a test exception");
        }
    }
    
    /// <summary>
    /// Person data class for testing properties and constructors
    /// </summary>
    public class Person
    {
        public string Name { get; private set; }
        public int Age { get; private set; }
        public string Email { get; private set; }
        public DateTime CreatedAt { get; private set; }
        
        public Person(string name, int age, string email)
        {
            Name = name ?? throw new ArgumentNullException(nameof(name));
            Age = age;
            Email = email ?? throw new ArgumentNullException(nameof(email));
            CreatedAt = DateTime.Now;
        }
        
        public bool IsAdult => Age >= 18;
        
        public string GetDisplayName()
        {
            return $"{Name} ({Age} years old)";
        }
        
        public override string ToString()
        {
            return $"Person: {Name}, Age: {Age}, Email: {Email}";
        }
        
        // Test method overloading
        public void UpdateEmail(string newEmail)
        {
            if (string.IsNullOrWhiteSpace(newEmail))
                throw new ArgumentException("Email cannot be empty", nameof(newEmail));
                
            Email = newEmail;
        }
        
        public void UpdateEmail(string newEmail, bool sendNotification)
        {
            UpdateEmail(newEmail);
            
            if (sendNotification)
            {
                Console.WriteLine($"Email notification sent to {newEmail}");
            }
        }
    }
    
    /// <summary>
    /// Generic utility class for testing generics and constraints
    /// </summary>
    public static class DataProcessor<T> where T : class
    {
        public static async Task<List<T>> ProcessItemsAsync<U>(IEnumerable<T> items, Func<T, U> selector) 
            where U : IComparable<U>
        {
            if (items == null)
                throw new ArgumentNullException(nameof(items));
                
            await Task.Delay(10); // Simulate async work
            
            return items.OrderBy(selector).ToList();
        }
        
        public static T FindFirst(IEnumerable<T> items, Predicate<T> condition)
        {
            return items?.FirstOrDefault(item => condition(item));
        }
    }
    
    // Test interface for LSP features
    public interface INotificationService
    {
        Task SendNotificationAsync(string message, string recipient);
        bool IsServiceAvailable { get; }
    }
    
    // Test abstract class
    public abstract class BaseService
    {
        protected string ServiceName { get; }
        
        protected BaseService(string serviceName)
        {
            ServiceName = serviceName;
        }
        
        public abstract Task InitializeAsync();
        
        protected virtual void LogMessage(string message)
        {
            Console.WriteLine($"[{ServiceName}] {message}");
        }
    }
    
    // Test enum
    public enum LogLevel
    {
        Debug = 1,
        Info = 2,
        Warning = 3,
        Error = 4,
        Critical = 5
    }
}
