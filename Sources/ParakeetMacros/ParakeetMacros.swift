import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

@main
struct ParakeetMacroPlugin: CompilerPlugin {
  let providingMacros: [Macro.Type] = [
    ActionMacro.self
  ]
}
