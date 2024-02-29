import Foundation

public protocol ErrorHandlerContaining {
  func errorHandler() -> ErrorHandling
}

public protocol ErrorHandling: ErrorHandlerContaining {
  func handle(_ error: Error)
}

extension ErrorHandling {
  public func errorHandler() -> ErrorHandling {
    return self
  }
}
