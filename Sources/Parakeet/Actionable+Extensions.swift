import Foundation

extension ActionContextProviding {
  /// Executes the provided action within the context provided by this container.
  /// - Parameter action: The action to execute.
  /// - Returns: The result of the action.
  /// - Throws: An error if the action fails to execute.
  @discardableResult
  public func perform<Action: Actionable>(_ action: Action) async throws -> Action.ActionResponse
  where Action.ActionContext == Self.ActionContext {
    try await action.act(withContext: createActionContext())
  }
}

/// A composite type that requires both `ActionContextProviding` and `ActionErrorHandlerProviding`.
public typealias ActionContextProvidingErrorHandling = ActionContextProviding
  & ActionErrorHandlerProviding

extension ActionContextProviding where Self: ActionErrorHandlerProviding {
  /// Executes the provided action asynchronously within the context provided by this container.
  ///
  /// Any errors thrown by the action are automatically handled by the error handler provided by this container.
  /// - Parameter action: The action to execute.
  /// - Returns: The result of the action, or nil if an error occurred.
  @discardableResult
  public func perform<Action: Actionable>(_ action: Action) async -> Action.ActionResponse?
  where Action.ActionContext == Self.ActionContext {
    do {
      return try await action.act(withContext: createActionContext())
    } catch {
      actionErrorHandler().handle(error)
      return nil
    }
  }

  /// Executes the provided action within a detached `Task`, using the context provided by this container.
  ///
  /// Any errors thrown by the action are automatically handled by the error handler provided by this container.
  /// - Parameter action: The action to execute.
  /// - Returns: The task performing the action.
  @discardableResult
  public func perform<Action: Actionable>(_ action: Action) -> Task<Action.ActionResponse?, Never>
  where Action.ActionContext == Self.ActionContext {
    Task {
      do {
        return try await action.act(withContext: createActionContext())
      } catch {
        actionErrorHandler().handle(error)
        return nil
      }
    }
  }
}
