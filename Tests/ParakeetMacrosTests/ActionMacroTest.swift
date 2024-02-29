import Foundation
import Parakeet
import ParakeetMacros
import SwiftSyntax
import SwiftSyntaxMacroExpansion
import SwiftSyntaxMacros
import XCTest

class ActionMacroTest: XCTestCase {
  func testActionMacro() {
    let source: SourceFileSyntax =
      """
      @Action
      struct MyAction {
        let firstProperty: String
        let secondProperty: String
      }
      """

    let file = BasicMacroExpansionContext.KnownSourceFile(
      moduleName: "MyModule",
      fullFilePath: "test.swift"
    )

    let context = BasicMacroExpansionContext(sourceFiles: [source: file])

    let transformedSF = source.expand(
      macros: ["Action": ActionMacro.self],
      in: context
    )

    let expectedDescription =
      """
      struct MyAction: Actionable {
        let firstProperty: String
        let secondProperty: String
      }

      extension MyAction: Actionable {
            @Action func myAction() {}
        }
      """

    XCTAssertEqual(transformedSF.description, expectedDescription)
  }
}
