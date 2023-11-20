//
//  File.swift
//  
//
//  Created by Артем Калинкин on 20.11.2023.
//

import ComposableArchitecture
import ParserClient


public struct ParagraphFeature: Reducer {
  public typealias State = Paragraph
  
  public enum Action {
    case saveToNotes
    case showReferences
  }
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .saveToNotes:
        print("Saved to Notes")
        break
      case .showReferences:
        print("Show references")
        break
      }
      return .none
    }
  }
}
