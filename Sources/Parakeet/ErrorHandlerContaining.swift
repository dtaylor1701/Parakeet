import Foundation

/// A protocol that defines a provider of an action error handler.
///
/// Types conforming to `ActionErrorHandlerProviding` can provide an `ActionErrorHandling` implementation
/// to handle errors thrown by actions during execution.
///
/// ### Example
/// ```swift
/// class MyViewModel: ActionContextProviding, ActionErrorHandlerProviding {
///     func actionErrorHandler() -> any ActionErrorHandling {
///         return self
///     }
/// }
///
/// extension MyViewModel: ActionErrorHandling {
///     func handle(_ error: any Error) {
///         self.errorMessage = error.localizedDescription
///     }
/// }
/// ```
public protocol ActionErrorHandlerProviding: Sendable {
  /// Returns the error handler responsible for processing errors.
  func actionErrorHandler() -> any ActionErrorHandling
}

/// A protocol that defines an error handler for actions.
///
/// Implementations of this protocol are responsible for processing errors,
/// such as logging them or presenting them to the user.
public protocol ActionErrorHandling: ActionErrorHandlerProviding {
  /// Processes the provided error.
  /// - Parameter error: The error that occurred during action execution.
  func handle(_ error: any Error)
}

extension ActionErrorHandling {
  /// Default implementation that returns self as the error handler.
  public func actionErrorHandler() -> any ActionErrorHandling {
    return self
  }
}
