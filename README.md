# Parakeet

Parakeet is a Swift library designed to decouple business logic (Actions) from their execution environment using the Command Pattern with Context Injection and Structured Error Handling.

## Key Features

- **Actionable Protocol**: Define tasks as independent units that require a context for execution and can return results.
- **Action Context Injection**: Use `ActionContextProviding` to provide the necessary dependencies to an action at runtime.
- **Structured Error Handling**: Centralize error management using the `ActionErrorHandling` and `ActionErrorHandlerProviding` protocols.
- **Swift Macro**: Simplify the creation of `Actionable` types with the `@Action` macro, including automatic static factory methods.
- **SwiftUI Support**: Trigger actions directly from views with built-in error handling.

## Installation

Add Parakeet as a dependency in your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/RambleLogic/Parakeet.git", from: "1.1.0")
]
```

## Core Components

### Actionable
The `Actionable` protocol defines a unit of work. It requires an `ActionContext` to perform its task and can return an `ActionResponse`.

```swift
public protocol Actionable: Sendable {
    associatedtype ActionContext
    associatedtype ActionResponse = Void
    func act(withContext context: ActionContext) async throws -> ActionResponse
}
```

### ActionContextProviding
The execution environment (e.g., a ViewModel or Coordinator) conforms to this protocol to provide the context required by an action.

```swift
public protocol ActionContextProviding {
    associatedtype ActionContext
    func createActionContext() -> ActionContext
}
```

### ActionErrorHandling
Parakeet provides a mechanism for centralized error handling, allowing the environment to handle errors thrown by actions.

```swift
public protocol ActionErrorHandlerProviding {
    func actionErrorHandler() -> any ActionErrorHandling
}

public protocol ActionErrorHandling {
    func handle(_ error: any Error)
}
```

## Usage

### 1. Define your Action Context
The context contains the dependencies required by your actions.

```swift
struct MyActionContext {
    let apiService: APIService
    let database: Database
}
```

### 2. Create an Action
Implement the `Actionable` protocol or use the `@Action` macro to define your business logic.

```swift
@Action
struct FetchUserAction {
    let userId: String

    func act(withContext context: MyActionContext) async throws -> User {
        return try await context.apiService.getUser(id: userId)
    }
}
```

### 3. Execute the Action
Conform your execution environment to `ActionContextProviding` and use the `perform` extension methods.

```swift
class UserViewModel: ActionContextProviding, ActionErrorHandlerProviding {
    typealias ActionContext = MyActionContext
    
    // ... dependencies ...
    
    func createActionContext() -> MyActionContext {
        return MyActionContext(apiService: apiService, database: database)
    }
    
    func actionErrorHandler() -> any ActionErrorHandling {
        return self // Conform to ActionErrorHandling to handle errors here
    }
    
    func loadUser() {
        // Asynchronous execution with automatic error handling
        perform(FetchUserAction.fetchUser(userId: "123")) 
    }
}
```

### 4. SwiftUI Integration
Trigger actions directly from your SwiftUI views.

```swift
struct MyView: View {
    @Environment(MyActionContext.self) var context
    
    var body: some View {
        Button("Refresh") {
            perform(FetchUserAction.fetchUser(userId: "123"), withContext: context)
        }
    }
}
```

## Project Structure

- `Sources/Parakeet`: Core protocols, extensions, and SwiftUI support.
- `Sources/ParakeetMacros`: Swift Syntax macros for simplifying `Actionable` definitions.
- `Tests`: Comprehensive unit tests for both the core library and macros.

## Requirements

- Swift 6.0+
- Foundation
- SwiftSyntax (for macros)

## License

This project is available under the MIT license. See the LICENSE file for more info.
