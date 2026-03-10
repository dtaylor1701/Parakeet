import Foundation

public protocol Actionable: Sendable {
  associatedtype Context: Sendable

  func act(withContext context: Context) async throws
}
