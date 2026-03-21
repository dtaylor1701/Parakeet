import Foundation

/// A protocol that defines a provider of an execution context for an action.
///
/// Types conforming to `ActionContextProviding` (e.g., ViewModels or Coordinators)
/// are responsible for creating the context required by an `Actionable`.
///
/// ### Example
/// ```swift
/// class MyViewModel: ActionContextProviding {
///     typealias ActionContext = MyContext
///
///     func createActionContext() -> MyContext {
///         return MyContext(apiService: self.apiService)
///     }
/// }
/// ```
public protocol ActionContextProviding {
  /// The type of context provided by this container.
  associatedtype ActionContext

  /// Creates and returns a new context for executing an action.
  func createActionContext() -> ActionContext
}
