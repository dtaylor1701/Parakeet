# Parakeet Design Documentation

## 1. Overview
Parakeet is a lightweight, protocol-oriented framework for Swift designed to encapsulate business logic into reusable, testable units called "Actions." By leveraging the Command pattern and Swift's advanced macro system, Parakeet provides a structured way to handle dependency injection, asynchronous execution, and centralized error handling with minimal boilerplate.

## 2. Core Design Philosophies & Patterns
*   **Command Pattern**: Every unit of work is encapsulated in an `Actionable` struct or class, separating the "what to do" from the "how to trigger it."
*   **Protocol-Oriented Design**: Behavior is defined through composable protocols (`Actionable`, `ActionContextProviding`, `ActionErrorHandlerProviding`), allowing for flexible integration into existing architectures like MVVM or TCA.
*   **Functional Results**: Actions can return results (`ActionResponse`), allowing for a more functional approach to business logic without relying on side effects in the context.
*   **Dependency Injection (Contextual)**: Actions do not hold onto long-lived dependencies. Instead, they receive an `ActionContext` object at execution time, ensuring clean separation of concerns and easy mockability.
*   **Macro-Driven Development**: Swift Macros are used to generate boilerplate code for action conformance with an eye toward future features.

## 3. High-Level Architecture

### Core Components
1.  **Actionable**: The fundamental protocol defining a unit of work.
    ```swift
    public protocol Actionable: Sendable {
        associatedtype ActionContext
        associatedtype ActionResponse = Void
        func act(withContext context: ActionContext) async throws -> ActionResponse
    }
    ```
2.  **ActionContext**: A generic associated type on `Actionable` that represents the dependencies (Services, Repositories, etc.) required to execute the action.
3.  **Performers (`ActionContextProviding`)**: Objects (usually View Models or Coordinators) that conform to this protocol. They are responsible for providing the `ActionContext` and triggering the action.

### Interaction Flow
1.  A **Performer** (e.g., `ProfileView`) identifies a need for an action (e.g., `UpdateEmailAction`).
2.  The Performer calls `perform(_:)`, passing the Action instance.
3.  The framework automatically injects the `ActionContext` created by the Performer into the Action's `act(withContext:)` method.
4.  The Action executes its logic asynchronously and returns an `ActionResponse`.
5.  If the Performer also conforms to `ActionErrorHandlerProviding`, any thrown errors are automatically routed to a centralized handler.

## 4. Technical Specifications

### Concurrency Model
Parakeet is built on Swift Concurrency (`async/await`). 
*   Actions are naturally asynchronous and isolated via `Sendable` requirements.
*   The `perform(_:)` extension provides a non-isolated `Task` wrapper for fire-and-forget actions, returning the `Task` to allow for lifecycle management (e.g., cancellation).

### Error Handling
Parakeet supports two tiers of error handling:
1.  **Local**: The `perform` method can be awaited, allowing the caller to use `do-catch` blocks.
2.  **Centralized**: By conforming to `ActionErrorHandlerProviding`, a Performer can delegate error processing to a dedicated `ActionErrorHandling` object, ensuring consistent UI alerts or logging across the application.

### Swift Macros (`@Action`)
The `@Action` macro automates repetitive tasks:
*   Adding `Actionable` conformance and `ActionContext` typealias discovery.

## 5. Technical Environment
*   **Language**: Swift 6.0+ (Required for strict concurrency and latest Macros).
*   **Build System**: Swift Package Manager (SPM).
*   **Platforms**: iOS 13+, macOS 11+, tvOS 13+, watchOS 7+.
*   **Dependencies**: `SwiftSyntax` (for Macro implementation).

## 6. Testing Strategy
Parakeet's design is optimized for high test coverage:
*   **Unit Testing Actions**: Actions are tested by passing a "Mock ActionContext" to the `act` method and asserting on the return values or side effects.
*   **Unit Testing Macros**: The `ParakeetMacrosTests` suite uses `SwiftSyntaxMacrosTestSupport` to verify that the `@Action` macro expands into the expected Swift code.
*   **Integration Testing**: Performers can be tested using real or specialized contexts to ensure the end-to-end flow of action triggering and error handling works as intended.

## 7. Security & Scalability
*   **Statelessness**: Actions are designed to be stateless, making them thread-safe and easy to reason about.
*   **Scalability**: As the application grows, the `ActionContext` can be specialized or composed (e.g., using `typealias ActionContext = AuthServiceProviding & DatabaseProviding`) to prevent the dependency container from becoming a monolith.
*   **Namespace Protection**: Protocols and methods use specialized naming (e.g., `ActionContext`, `createActionContext`) to minimize collisions with other framework or domain symbols.
