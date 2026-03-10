# Parakeet

Parakeet is a Swift library designed to decouple business logic (Actions) from their execution environment using the Command Pattern with Context Injection and Structured Error Handling.

## Key Features

- **Actionable Protocol**: Define tasks as independent units that require a context for execution.
- **Context Injection**: Use `ActionContextContaining` to provide the necessary dependencies to an action at runtime.
- **Structured Error Handling**: Centralize error management using the `ErrorHandling` and `ErrorHandlerContaining` protocols.
- **Experimental Swift Macro**: Simplify the creation of `Actionable` types with the `@Action` macro.

## Installation

Add Parakeet as a dependency in your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/RambleLogic/Parakeet.git", from: "1.0.0")
]
```

## Core Components

### Actionable
The `Actionable` protocol defines a unit of work. It requires a `Context` to perform its task.

```swift
public protocol Actionable {
    associatedtype Context
    func act(withContext context: Context) async throws
}
```

### ActionContextContaining
The execution environment (e.g., a ViewModel or Coordinator) conforms to this protocol to provide the context required by an action.

```swift
public protocol ActionContextContaining {
    associatedtype Context
    func createContext() -> Context
}
```

### ErrorHandling
Parakeet provides a mechanism for centralized error handling, allowing the environment to handle errors thrown by actions.

```swift
public protocol ErrorHandlerContaining {
    func errorHandler() -> ErrorHandling
}

public protocol ErrorHandling {
    func handle(_ error: Error)
}
```

## Usage

### 1. Define your Context
The context contains the dependencies required by your actions.

```swift
struct MyContext {
    let apiService: APIService
    let database: Database
}
```

### 2. Create an Action
Implement the `Actionable` protocol to define your business logic.

```swift
struct FetchUserAction: Actionable {
    let userId: String

    func act(withContext context: MyContext) async throws {
        let user = try await context.apiService.getUser(id: userId)
        try await context.database.save(user)
    }
}
```

### 3. Execute the Action
Conform your execution environment to `ActionContextContaining` and use the `perform` extension methods.

```swift
class UserViewModel: ActionContextContaining, ErrorHandlerContaining {
    typealias Context = MyContext
    
    private let apiService: APIService
    private let database: Database
    
    func createContext() -> MyContext {
        return MyContext(apiService: apiService, database: database)
    }
    
    func errorHandler() -> ErrorHandling {
        return self // Conform to ErrorHandling to handle errors here
    }
    
    func loadUser() {
        let action = FetchUserAction(userId: "123")
        
        // Asynchronous execution with error handling
        perform(action) 
    }
}
```

## Project Structure

- `Sources/Parakeet`: Core protocols and extensions.
- `Sources/ParakeetMacros`: Swift Syntax macros for simplifying `Actionable` definitions.
- `Tests`: Comprehensive unit tests for both the core library and macros.

## Requirements

- Swift 5.9+
- Foundation
- SwiftSyntax (for macros)

## License

This project is available under the MIT license. See the LICENSE file for more info.
