import ParakeetMacros
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import Testing

@Suite struct ActionMacroTests {
  let testMacros: [String: Macro.Type] = [
    "Action": ActionMacro.self
  ]

  @Test func actionMacro() {
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
            
        }
        """,
      macros: testMacros
    )
  }

  @Test func simpleActionMacro() {
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
            
        }
        """,
      macros: testMacros
    )
  }
}
