//
//  File.swift
//
//
//  Created by David Taylor on 10/14/23.
//

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
    //        return try [.init("")]
    [
      try ExtensionDeclSyntax(
        """
        extension \(type): Actionable {

        }
        """),
      try ExtensionDeclSyntax(
        """
        extension Actionable where Self == \(type) {
            static func \(type.formatted())() -> \(type) {
                \(type)(\(node.arguments?.firstToken(viewMode: .fixedUp) ?? ""))
            }
        }
        """),
    ]
  }

  static func actionableExtension(
    of node: AttributeSyntax, attachedTo declaration: some DeclGroupSyntax,
    providingExtensionsOf type: some TypeSyntaxProtocol
  ) throws -> [ExtensionDeclSyntax] {
    let properties = declaration.memberBlock.members
      .map(\.decl)
      .compactMap { declaration -> String? in
        guard
          let property = declaration.as(VariableDeclSyntax.self)?.bindings.first
        else { return nil }

        property.typeAnnotation?.type
      }
  }
}

// extension Actionable where Self == AddIngredientAction {
//   static func add(ingredient: Ingredient) -> AddIngredientAction {
//     AddIngredientAction(ingredient: ingredient)
//   }
// }
