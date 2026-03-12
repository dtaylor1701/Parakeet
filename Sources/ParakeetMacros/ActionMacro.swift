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
    
    // Get stored properties to create the factory method
    let properties = declaration.memberBlock.members
      .compactMap { $0.decl.as(VariableDeclSyntax.self) }
      .flatMap { varDecl -> [(identifier: TokenSyntax, type: TypeSyntax)] in
        // Filter for stored properties (no accessors)
        // Skip properties with attributes (like property wrappers)
        guard varDecl.attributes.isEmpty else { return [] }
        
        return varDecl.bindings.compactMap { binding in
          guard let identifier = binding.pattern.as(IdentifierPatternSyntax.self)?.identifier,
                let type = binding.typeAnnotation?.type else {
            return nil
          }
          // Simple check for stored vs computed: if there's an accessor block, it's likely computed
          if binding.accessorBlock != nil { return nil }
          return (identifier, type)
        }
      }
    
    // Generate the method name: MyAction -> myAction, or CreateUserAction -> createUser
    let typeName = type.trimmedDescription
    var methodName = typeName
    if methodName.hasSuffix("Action") && methodName.count > 6 {
        methodName = String(methodName.dropLast(6))
    }
    methodName = methodName.prefix(1).lowercased() + methodName.dropFirst()
    
    // Find the Context type from act(withContext:) or typealias Context
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
    
    // Check for typealias Context
    if contextType == nil {
      for member in declaration.memberBlock.members {
        if let typeAlias = member.decl.as(TypeAliasDeclSyntax.self),
           typeAlias.name.text == "Context" {
          contextType = typeAlias.underlyingType.trimmedDescription
          break
        }
      }
    }
    
    // Construct the parameters and initializer arguments
    let parameters = properties.map { "\($0.identifier): \($0.type)" }.joined(separator: ", ")
    let arguments = properties.map { "\($0.identifier): \($0.identifier)" }.joined(separator: ", ")
    
    var extensions: [ExtensionDeclSyntax] = []
    
    // 1. Add conformance to Actionable and factory method on the type itself
    let contextAlias = contextType.map { "typealias Context = \($0)" } ?? ""
    extensions.append(try ExtensionDeclSyntax(
      """
      extension \(type): Actionable {
          \(raw: contextAlias)
          static func \(raw: methodName)(\(raw: parameters)) -> \(type) {
              \(type).init(\(raw: arguments))
          }
      }
      """))
    
    // 2. Add factory method on Actionable constrained to this type to enable leading-dot syntax
    extensions.append(try ExtensionDeclSyntax(
      """
      extension Actionable where Self == \(type) {
          static func \(raw: methodName)(\(raw: parameters)) -> \(type) {
              \(type).\(raw: methodName)(\(raw: arguments))
          }
      }
      """))
    
    return extensions
  }
}
