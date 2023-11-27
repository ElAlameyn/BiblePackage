//
//  File.swift
//
//
//  Created by Артем Калинкин on 17.11.2023.
//

import ComposableArchitecture
import SwiftUI

public struct ScrollReducer: Reducer {
  public struct State: Equatable {
    var isScrolling = false
    var currentScrollValue: CGFloat = .zero
  }
  
  public enum Action: Hashable {
    case scrolling(CGFloat)
    case endScroll
  }
  
  enum CancelID { case scroll }
  
  @Dependency(\.mainQueue) var mainQueue
  
  public func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .scrolling(let cgFloat):
      state.isScrolling = true
      state.currentScrollValue = cgFloat
//      print("Current scroll: \(cgFloat)")
      return .send(.endScroll).debounce(id: CancelID.scroll, for: 0.2, scheduler: mainQueue)
    case .endScroll:
      state.isScrolling = false
    }
    return .none
  }
}

extension ScrollReducer {
  struct OffsetKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
      value += nextValue()
    }
  }
}
