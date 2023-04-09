import Foundation

public extension ActionContextContaining {
    func perform<Action: Actionable>(_ action: Action) async throws where Action.Context == Self.Context  {
        try await action.act(withContext: createContext())
    }
}

public typealias ActionContextContainingErrorHandling = ActionContextContaining & ErrorHandlerContaining

public extension ActionContextContaining where Self: ErrorHandlerContaining {
    func perform<Action: Actionable>(_ action: Action) where Action.Context == Self.Context {
        Task {
            do {
                try await action.act(withContext: createContext())
            } catch {
                errorHandler().handle(error)
            }
        }
    }
}
