import Foundation
import ParakeetMacros
import SwiftSyntax
import SwiftSyntaxMacroExpansion
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

let testMacros: [String: Macro.Type] = [
    "Action": ActionMacro.self
]

final class ActionMacroTest: XCTestCase {
  func testActionMacro() {
    assertMacroExpansion(
      """
      @Action
      struct CreateUserAction {
        let id: UUID
        let name: String
        
        var computedProperty: String {
          name
        }
      }
      """,
      expandedSource: """
      struct CreateUserAction {
        let id: UUID
        let name: String
        
        var computedProperty: String {
          name
        }
      }

      extension CreateUserAction: Actionable {
          static func createUser(id: UUID, name: String) -> CreateUserAction {
              CreateUserAction(id: id, name: name)
          }
      }
      """,
      macros: testMacros
    )
  }
  
  func testSimpleActionMacro() {
      assertMacroExpansion(
        """
        @Action
        struct SimpleAction {
        }
        """,
        expandedSource: """
        struct SimpleAction {
        }

        extension SimpleAction: Actionable {
            static func simple() -> SimpleAction {
                SimpleAction()
            }
        }
        """,
        macros: testMacros
      )
    }
}
