import Foundation

public protocol ActionContextContaining {
    associatedtype Context
    
    func createContext() -> Context
}
