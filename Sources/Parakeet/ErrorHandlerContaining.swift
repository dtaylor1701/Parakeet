import Foundation

public protocol ErrorHandling {
    func handle(_ error: Error)
}

public protocol ErrorHandlerContaining {
    func errorHandler() -> ErrorHandling
}
