//
//  File.swift
//
//
//  Created by Артем Калинкин on 23.12.2023.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct ManyPagesFeature {
  public init() {}
  
  @ObservableState
  public struct State: Equatable {
    var navState = [Status.previous, .current, .next]
//    @BindingState var navSelection = Status.current
    
    var number = 0
    var pages = IdentifiedArrayOf<PageFeature.State>()
    
    public init(pages: IdentifiedArrayOf<PageFeature.State>) {
      self.pages = pages
    }
  }
  
  public enum Action: Equatable, BindableAction {
    case binding(BindingAction<State>)
    case pageFeature(id: Int, action: PageFeature.Action)
  }
  
  public var body: some Reducer<State, Action> {
    Reduce { _, _ in
      .none
    }
  }
}

public struct ManyPagesView: View {
  let store: StoreOf<ManyPagesFeature>
  
  public var body: some View {
    var number = 0
    TabView(selection: .constant(Status.previous)) {
      ForEachStore(store.scope(
        state: \.pages,
        action: \.pageFeature),
      content: { store in
        PageView(store: store)
          .onLoad {
            store.send(.loadPage(at: number))
            number += 1
          }
      })
    }
    .tabViewStyle(.page(indexDisplayMode: .never))
  }
}

private var  pages = IdentifiedArray(uniqueElements: [
  PageFeature.State(),
  PageFeature.State(),
  PageFeature.State(),
  PageFeature.State(),
])

#Preview {
  return ManyPagesView(
    store: .init(
      initialState: .init(pages: pages),
      reducer: {
        ManyPagesFeature()
      })
  )
}
