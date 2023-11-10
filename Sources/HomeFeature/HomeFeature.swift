//
//  File.swift
//
//
//  Created by Артем Калинкин on 17.08.2023.
//

import ComposableArchitecture
import Foundation
import PDFKit

public struct HomeFeature: Reducer {
  public init() {}

  public struct State: Equatable {
    public init() { }
  }

  public enum Action {
    case openBibleButtonTapped
    case openRules(RuleType)
  }

  public enum RuleType { case morning, evening }

  public var body: some Reducer<State, Action> {
    Reduce { _, action in
      switch action {
        case .openBibleButtonTapped:
          break
        case .openRules: break
      }
      return .none
    }
  }
}
