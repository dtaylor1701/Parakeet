import Foundation

extension ActionContextContaining {
  /// Executes the provided action within the context provided by this container.
  /// - Parameter action: The action to execute.
  /// - Throws: An error if the action fails to execute.
  public func perform<Action: Actionable>(_ action: Action) async throws
  where Action.Context == Self.Context {
    try await action.act(withContext: createContext())
  }
}

/// A composite type that requires both `ActionContextContaining` and `ErrorHandlerContaining`.
public typealias ActionContextContainingErrorHandling = ActionContextContaining
  & ErrorHandlerContaining

extension ActionContextContaining where Self: ErrorHandlerContaining {
  /// Executes the provided action asynchronously within the context provided by this container.
  ///
  /// Any errors thrown by the action are automatically handled by the error handler provided by this container.
  /// - Parameter action: The action to execute.
  public func perform<Action: Actionable>(_ action: Action) async
  where Action.Context == Self.Context {
    do {
      try await action.act(withContext: createContext())
    } catch {
      errorHandler().handle(error)
    }
  }

  /// Executes the provided action within a detached `Task`, using the context provided by this container.
  ///
  /// Any errors thrown by the action are automatically handled by the error handler provided by this container.
  /// - Parameter action: The action to execute.
  public func perform<Action: Actionable>(_ action: Action) where Action.Context == Self.Context {
    Task {
      do {
        try await action.act(withContext: createContext())
      } catch {
        errorHandler().handle(error)
      }
    }
  }
}
