//
//  File.swift
//  
//
//  Created by Артем Калинкин on 20.11.2023.
//

import ComposableArchitecture
import SwiftUI
import Extensions_GenericViews

public struct ParagraphView: View {
  let store: StoreOf<ParagraphFeature>
  @ObservedObject var viewStore: ViewStoreOf<ParagraphFeature>

  init(store: StoreOf<ParagraphFeature>) {
    self.store = store
    self.viewStore = ViewStore(store, observe: { $0 })
  }

  public var body: some View {
    Menu {
      Button("Показать сноски", action: {
        viewStore.send(.showReferences)
      })
      Button("Сохранить в заметки", action: {
        viewStore.send(.saveToNotes)
      })
    } label: {
      Text(verbatim: viewStore.description)
        .multilineTextAlignment(.leading)
        .font(.system(.body))
        .padding(.leading, 10)
        .padding(.trailing, 10)
    }
    .foregroundColor(.black)
  }
}

#Preview {
  ParagraphView(store: .init(
    initialState: .init(number: 1, text: String.loremIpsum5),
    reducer: {
    ParagraphFeature()
  }))
}
