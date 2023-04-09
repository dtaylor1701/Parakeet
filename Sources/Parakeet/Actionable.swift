import Foundation

public protocol Actionable {
    associatedtype Context
    
    func act(withContext context: Context) async throws
}

