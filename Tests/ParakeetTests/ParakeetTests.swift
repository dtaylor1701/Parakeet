import Foundation
import Testing

@testable import Parakeet

@Suite("Parakeet Tests")
struct ParakeetTests {
  @Test func simpleAction() async throws {
    let context = TestActionContext()
    let action = TestAction()

    try await action.act(withContext: context)
    #expect(context.didAct)
  }

  @Test func performActionInContext() async throws {
    let provider = TestProvider()
    let action = TestAction()

    try await provider.perform(action)
    #expect(provider.context.didAct)
  }

  @Test func performActionWithErrorHandler() async {
    let provider = TestProvider()
    let action = TestAction()

    await provider.perform(action)
    #expect(provider.context.didAct)
  }

  @Test func actionWithMacro() async throws {
    let provider = TestProvider()
    let action = MacroAction(message: "Hello")

    await provider.perform(action)
    #expect(provider.context.lastMessage == "Hello")
  }

  @Test func actionWithMacroStaticFactory() async throws {
    let provider = TestProvider()

    await provider.perform(MacroAction.macro(message: "Static"))
    #expect(provider.context.lastMessage == "Static")
  }

  @Test func actionWithReturnValue() async throws {
    let provider = TestProvider()
    let action = ReturningAction()

    let result = try await provider.perform(action)
    #expect(result == "Success")
  }

  @Test func actionWithReturnValueStaticFactory() async throws {
    let provider = TestProvider()

    let result = try await provider.perform(ReturningAction.returning())
    #expect(result == "Success")
  }
}

final class TestActionContext: @unchecked Sendable {
  private let lock = NSLock()
  private var _didAct = false
  private var _lastMessage: String?

  var didAct: Bool {
    get {
      lock.lock()
      defer { lock.unlock() }
      return _didAct
    }
    set {
      lock.lock()
      defer { lock.unlock() }
      _didAct = newValue
    }
  }

  var lastMessage: String? {
    get {
      lock.lock()
      defer { lock.unlock() }
      return _lastMessage
    }
    set {
      lock.lock()
      defer { lock.unlock() }
      _lastMessage = newValue
    }
  }
}

@Action
struct MacroAction {
  typealias ActionContext = TestActionContext
  let message: String

  func act(withContext context: TestActionContext) async throws {
    context.lastMessage = message
  }
}

@Action
struct ReturningAction {
  typealias ActionContext = TestActionContext
  typealias ActionResponse = String

  func act(withContext context: TestActionContext) async throws -> String {
    return "Success"
  }
}

struct TestAction: Actionable {
  typealias ActionContext = TestActionContext

  func act(withContext context: TestActionContext) async throws {
    context.didAct = true
  }
}

final class TestProvider: ActionContextProviding, ActionErrorHandlerProviding, @unchecked Sendable {
  let context = TestActionContext()
  let errorLogger = TestActionErrorHandler()

  func createActionContext() -> TestActionContext {
    return context
  }

  func actionErrorHandler() -> any ActionErrorHandling {
    return errorLogger
  }
}

final class TestActionErrorHandler: ActionErrorHandling, @unchecked Sendable {
  var lastError: (any Error)?

  func handle(_ error: any Error) {
    lastError = error
  }
}
