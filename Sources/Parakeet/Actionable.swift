import Foundation

/// A protocol that defines an action that can be performed with a given context.
///
/// `Actionable` encapsulates a single piece of business logic or a task. It is designed
/// to be executed in an environment that provides the necessary dependencies via a `Context`.
///
/// ### Example
/// ```swift
/// struct FetchUserAction: Actionable {
///     let userId: String
///
///     func act(withContext context: MyContext) async throws {
///         let user = try await context.apiService.getUser(id: userId)
///         // ...
///     }
/// }
/// ```
@attached(extension, conformances: Actionable, names: arbitrary)
public macro Action() = #externalMacro(module: "ParakeetMacros", type: "ActionMacro")

/// A protocol that defines a unit of work that can be executed asynchronously.
public protocol Actionable: Sendable {
  /// The type of context required to execute the action.
  associatedtype Context: Sendable

  /// Executes the action with the provided context.
  /// - Parameter context: The context containing the dependencies needed for the action.
  /// - Throws: An error if the action fails to execute.
  func act(withContext context: Context) async throws
}
