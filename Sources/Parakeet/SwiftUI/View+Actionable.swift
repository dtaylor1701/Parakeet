#if canImport(SwiftUI)
import SwiftUI

extension View {
  /// Executes the provided action using a context provided by the environment.
  /// - Parameters:
  ///   - action: The action to execute.
  ///   - context: The context required by the action.
  ///   - errorHandler: An optional error handler to process any errors.
  /// - Returns: A task performing the action.
  @discardableResult
  public func perform<Action: Actionable>(
    _ action: Action,
    withContext context: Action.ActionContext,
    errorHandler: (any ActionErrorHandling)? = nil
  ) -> Task<Action.ActionResponse?, Never> {
    Task {
      do {
        return try await action.act(withContext: context)
      } catch {
        if let errorHandler = errorHandler {
          errorHandler.handle(error)
        } else {
          print("Parakeet Action Error: \(error)")
        }
        return nil
      }
    }
  }
}
#endif
