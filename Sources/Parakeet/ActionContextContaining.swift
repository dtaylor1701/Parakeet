import Foundation

public protocol ActionContextContaining: Sendable {
  associatedtype Context: Sendable

  func createContext() -> Context
}
