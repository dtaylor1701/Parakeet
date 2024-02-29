import Foundation

extension ActionContextContaining {
  public func perform<Action: Actionable>(_ action: Action) async throws
  where Action.Context == Self.Context {
    try await action.act(withContext: createContext())
  }
}

public typealias ActionContextContainingErrorHandling = ActionContextContaining
  & ErrorHandlerContaining

extension ActionContextContaining where Self: ErrorHandlerContaining {
  public func perform<Action: Actionable>(_ action: Action) async
  where Action.Context == Self.Context {
    do {
      try await action.act(withContext: createContext())
    } catch {
      errorHandler().handle(error)
    }
  }

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
