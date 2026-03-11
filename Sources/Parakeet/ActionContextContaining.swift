import Foundation

/// A protocol that defines a provider of an execution context for an action.
///
/// Types conforming to `ActionContextContaining` (e.g., ViewModels or Coordinators)
/// are responsible for creating the context required by an `Actionable`.
///
/// ### Example
/// ```swift
/// class MyViewModel: ActionContextContaining {
///     typealias Context = MyContext
///
///     func createContext() -> MyContext {
///         return MyContext(apiService: self.apiService)
///     }
/// }
/// ```
public protocol ActionContextContaining: Sendable {
  /// The type of context provided by this container.
  associatedtype Context: Sendable

  /// Creates and returns a new context for executing an action.
  func createContext() -> Context
}
