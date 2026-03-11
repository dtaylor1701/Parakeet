import Foundation

/// A protocol that defines a provider of an error handler.
///
/// Types conforming to `ErrorHandlerContaining` can provide an `ErrorHandling` implementation
/// to handle errors thrown by actions during execution.
///
/// ### Example
/// ```swift
/// class MyViewModel: ActionContextContaining, ErrorHandlerContaining {
///     func errorHandler() -> any ErrorHandling {
///         return self
///     }
/// }
///
/// extension MyViewModel: ErrorHandling {
///     func handle(_ error: Error) {
///         self.errorMessage = error.localizedDescription
///     }
/// }
/// ```
public protocol ErrorHandlerContaining: Sendable {
  /// Returns the error handler responsible for processing errors.
  func errorHandler() -> any ErrorHandling
}

/// A protocol that defines an error handler.
///
/// Implementations of this protocol are responsible for processing errors,
/// such as logging them or presenting them to the user.
public protocol ErrorHandling: ErrorHandlerContaining {
  /// Processes the provided error.
  /// - Parameter error: The error that occurred during action execution.
  func handle(_ error: any Error)
}

extension ErrorHandling {
  /// Default implementation that returns self as the error handler.
  public func errorHandler() -> any ErrorHandling {
    return self
  }
}
