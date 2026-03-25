import Foundation

/// A protocol that defines a provider of an execution context for an action.
///
/// Types conforming to `ActionContextProviding`
/// are responsible for creating the context required by an `Actionable`.
///
public protocol ActionContextProviding {
  /// The type of context provided by this container.
  associatedtype ActionContext

  /// Creates and returns a new context for executing an action.
  func createActionContext() -> ActionContext
}

/// A protocol that defines a container of an execution context for an action.
///
/// An alternative to `ActionContextProviding` when the context is accessible as a member.
public protocol ActionContextContaining: ActionContextProviding {
  /// The type of context provided by this container.
  associatedtype ActionContext
  
  /// Creates and returns a new context for executing an action.
  var actionContext: ActionContext { get }
}
