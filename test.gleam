// Gleam Syntax Highlighting Test File
// This file demonstrates various Gleam language features

import gleam/io
import gleam/list
import gleam/string
import gleam/result
import gleam/option.{type Option, None, Some}

// Custom types and type aliases
pub type User {
  User(id: Int, name: String, email: String, active: Bool)
}

pub type UserError {
  NotFound
  InvalidEmail
  DatabaseError(String)
}

type alias UserId = Int

// Constants
const max_users = 1000
const default_timeout = 5000

// Public function with pattern matching
pub fn create_user(id: UserId, name: String, email: String) -> Result(User, UserError) {
  case validate_email(email) {
    True -> {
      let user = User(id: id, name: name, email: email, active: True)
      Ok(user)
    }
    False -> Error(InvalidEmail)
  }
}

// Private function with guards
fn validate_email(email: String) -> Bool {
  case string.contains(email, "@") && string.contains(email, ".") {
    True -> True
    False -> False
  }
}

// Function with multiple clauses and recursion
pub fn find_user_by_id(users: List(User), target_id: UserId) -> Option(User) {
  case users {
    [] -> None
    [user, ..rest] -> 
      case user.id == target_id {
        True -> Some(user)
        False -> find_user_by_id(rest, target_id)
      }
  }
}

// Function with pipe operator and higher-order functions
pub fn get_active_user_names(users: List(User)) -> List(String) {
  users
  |> list.filter(fn(user) { user.active })
  |> list.map(fn(user) { user.name })
  |> list.sort(string.compare)
}

// Function with use expressions and error handling
pub fn update_user_email(users: List(User), id: UserId, new_email: String) -> Result(List(User), UserError) {
  use valid_email <- result.try(case validate_email(new_email) {
    True -> Ok(new_email)
    False -> Error(InvalidEmail)
  })
  
  case find_user_by_id(users, id) {
    None -> Error(NotFound)
    Some(_user) -> {
      let updated_users = list.map(users, fn(user) {
        case user.id == id {
          True -> User(..user, email: valid_email)
          False -> user
        }
      })
      Ok(updated_users)
    }
  }
}

// Function with external function calls and string interpolation
pub fn print_user_info(user: User) -> Nil {
  let status = case user.active {
    True -> "active"
    False -> "inactive"
  }
  
  io.println("User ID: " <> string.inspect(user.id))
  io.println("Name: " <> user.name)
  io.println("Email: " <> user.email)
  io.println("Status: " <> status)
}

// Function with list comprehension-like operations
pub fn get_user_summaries(users: List(User)) -> List(String) {
  list.map(users, fn(user) {
    let status_emoji = case user.active {
      True -> "✅"
      False -> "❌"
    }
    user.name <> " (" <> user.email <> ") " <> status_emoji
  })
}

// Main function with let bindings and case expressions
pub fn main() {
  // Creating test data
  let users = [
    User(1, "Alice Smith", "alice@example.com", True),
    User(2, "Bob Jones", "bob@test.org", False),
    User(3, "Charlie Brown", "charlie@demo.net", True),
  ]
  
  // Demonstrating various operations
  io.println("=== User Management System ===")
  
  // Print all users
  list.each(users, print_user_info)
  
  // Get active user names
  let active_names = get_active_user_names(users)
  io.println("\nActive users:")
  list.each(active_names, io.println)
  
  // Try to find a user
  case find_user_by_id(users, 2) {
    Some(user) -> {
      io.println("\nFound user:")
      print_user_info(user)
    }
    None -> io.println("\nUser not found")
  }
  
  // Try to update a user's email
  case update_user_email(users, 1, "alice.smith@newdomain.com") {
    Ok(updated_users) -> {
      io.println("\nEmail updated successfully!")
      case find_user_by_id(updated_users, 1) {
        Some(user) -> print_user_info(user)
        None -> io.println("Error: Updated user not found")
      }
    }
    Error(InvalidEmail) -> io.println("\nError: Invalid email format")
    Error(NotFound) -> io.println("\nError: User not found")
    Error(DatabaseError(msg)) -> io.println("\nDatabase error: " <> msg)
  }
  
  // Get user summaries
  io.println("\nUser summaries:")
  users
  |> get_user_summaries()
  |> list.each(io.println)
}

// Generic function with type parameters
pub fn maybe_map(option: Option(a), func: fn(a) -> b) -> Option(b) {
  case option {
    None -> None
    Some(value) -> Some(func(value))
  }
}

// Function with bit string patterns (for binary data)
pub fn parse_header(data: BitArray) -> Result(#(Int, String), String) {
  case data {
    <<version:8, length:16, name:bytes-size(length), _rest:bytes>> -> {
      case bit_array.to_string(name) {
        Ok(name_string) -> Ok(#(version, name_string))
        Error(_) -> Error("Invalid UTF-8 in name")
      }
    }
    _ -> Error("Invalid header format")
  }
}

// External function declaration (for JavaScript/Erlang FFI)
@external(javascript, "./ffi.mjs", "getCurrentTimestamp")
@external(erlang, "os", "system_time")
pub fn get_timestamp() -> Int

// Function with assertions (for testing)
pub fn test_user_creation() {
  let assert Ok(user) = create_user(1, "Test User", "test@example.com")
  let assert user.name == "Test User"
  let assert user.active == True
  io.println("All tests passed!")
}
