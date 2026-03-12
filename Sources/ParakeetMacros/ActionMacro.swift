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
    
    // Construct the parameters and initializer arguments
    let parameters = properties.map { "\($0.identifier): \($0.type)" }.joined(separator: ", ")
    let arguments = properties.map { "\($0.identifier): \($0.identifier)" }.joined(separator: ", ")
    
    return [
      try ExtensionDeclSyntax(
        """
        extension \(type): Actionable {
            static func \(raw: methodName)(\(raw: parameters)) -> \(type) {
                \(type)(\(raw: arguments))
            }
        }
        """),
    ]
  }
}
