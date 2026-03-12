import Foundation
import Testing

@testable import Parakeet

@Suite("Parakeet Tests")
struct ParakeetTests {
  @Test func simpleAction() async throws {
    let context = TestContext()
    let action = TestAction()

    try await action.act(withContext: context)
    #expect(context.didAct)
  }

  @Test func performActionInContext() async throws {
    let provider = TestProvider()
    let action = TestAction()

    await provider.perform(action)
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
}

final class TestContext: @unchecked Sendable {
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
  typealias Context = TestContext
  let message: String

  func act(withContext context: TestContext) async throws {
    context.lastMessage = message
  }
}

struct TestAction: Actionable {
  typealias Context = TestContext

  func act(withContext context: TestContext) async throws {
    context.didAct = true
  }
}

final class TestProvider: ActionContextContaining, ErrorHandlerContaining, @unchecked Sendable {
  let context = TestContext()
  let errorLogger = TestErrorHandler()

  func createContext() -> TestContext {
    return context
  }

  func errorHandler() -> any ErrorHandling {
    return errorLogger
  }
}

final class TestErrorHandler: ErrorHandling, @unchecked Sendable {
  var lastError: (any Error)?

  func handle(_ error: any Error) {
    lastError = error
  }
}
