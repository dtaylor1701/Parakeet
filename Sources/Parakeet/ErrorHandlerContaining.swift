import Foundation

public protocol ErrorHandlerContaining {
    func errorHandler() -> ErrorHandling
}

public protocol ErrorHandling: ErrorHandlerContaining {
    func handle(_ error: Error)
}

public extension ErrorHandling {
    func errorHandler() -> ErrorHandling {
        return self
    }
}
