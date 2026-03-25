import Foundation
import SwiftSyntax
import SwiftSyntaxMacros

public struct ActionMacro: ExtensionMacro {
  public static func expansion(
    of node: AttributeSyntax,
    attachedTo declaration: some DeclGroupSyntax,
    providingExtensionsOf type: some TypeSyntaxProtocol,
    conformingTo protocols: [TypeSyntax],
    in context: some MacroExpansionContext
  ) throws -> [ExtensionDeclSyntax] {
    
    // Generate the method name: MyAction -> myAction, or CreateUserAction -> createUser
    let typeName = type.trimmedDescription
    var methodName = typeName
    if methodName.hasSuffix("Action") && methodName.count > 6 {
        methodName = String(methodName.dropLast(6))
    }
    methodName = methodName.prefix(1).lowercased() + methodName.dropFirst()
    
    // Find the ActionContext type from act(withContext:) or typealias ActionContext
    var contextType: String? = nil
    
    // Check for act(withContext:)
    for member in declaration.memberBlock.members {
      if let function = member.decl.as(FunctionDeclSyntax.self),
         function.name.text == "act" {
        for parameter in function.signature.parameterClause.parameters {
          if parameter.firstName.text == "withContext" {
            contextType = parameter.type.trimmedDescription
            break
          }
        }
      }
      if contextType != nil { break }
    }
    
    // Check for typealias ActionContext
    if contextType == nil {
      for member in declaration.memberBlock.members {
        if let typeAlias = member.decl.as(TypeAliasDeclSyntax.self),
           typeAlias.name.text == "ActionContext" {
          contextType = typeAlias.initializer.value.trimmedDescription
          break
        }
      }
    }
    
    // Construct the parameters and initializer arguments
    var extensions: [ExtensionDeclSyntax] = []

    // 1. Add conformance to Actionable and factory method on the type itself
    extensions.append(try ExtensionDeclSyntax(
      """
      extension \(type): Actionable { }    
      """))

    return extensions
  }
}
