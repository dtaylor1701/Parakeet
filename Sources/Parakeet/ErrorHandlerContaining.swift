import Foundation

public protocol ErrorHandlerContaining: Sendable {
  func errorHandler() -> any ErrorHandling
}

public protocol ErrorHandling: ErrorHandlerContaining {
  func handle(_ error: any Error)
}

extension ErrorHandling {
  public func errorHandler() -> any ErrorHandling {
    return self
  }
}
