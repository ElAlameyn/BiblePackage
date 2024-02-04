//
//  SwiftUIView.swift
//
//
//  Created by Артем Калинкин on 08.09.2023.
//

import ComposableArchitecture
import Extensions_GenericViews
import SwiftUI

enum Status {
  case next, previous, current, start, end
}

public struct PageView: View {
  let store: StoreOf<PageFeature>
  @ObservedObject var viewStore: ViewStoreOf<PageFeature>

  var navState = [Status.previous, .current, .next]
  @State var navSelection = Status.current
  @State var count = 0

  @MainActor public init(store: StoreOf<PageFeature>) {
    self.store = store
    self.viewStore = ViewStore(store, observe: { $0 })

    UINavigationBar.appearance().tintColor = .white
  }

  public var body: some View {
    GeometryReader { proxy in
      contentView(proxy: proxy)
    }
  }

  private var loaderView: some View {
    ProgressView()
      .scaleEffect(3.2)
  }

  private var paragraphsView: some View {
    LazyVStack(alignment: .leading, spacing: 20) {
      ForEachStore(
        store.scope(state: \.paragraphs, action: PageFeature.Action.paragraphAction),
        content: ParagraphView.init(store:)
      )
      .minimumScaleFactor(0.1)
    }
    .background(GeometryReader(content: { geometry in
      Color.clear.preference(key: ScrollReducer.OffsetKey.self, value: geometry.frame(in: .global).origin.y)
    }))
    .onPreferenceChange(ScrollReducer.OffsetKey.self) { value in
      viewStore.send(.scrollAction(.scrolling(value)))
    }
    .padding(.leading, 10)
    .padding(.trailing, 10)
  }

  private func contentView(proxy: GeometryProxy) -> some View {
    ScrollViewReader { scrolling in
      ScrollView {
        WithViewStore(store, observe: { $0 }) { viewStore in
          Image("matfey", bundle: .module)
            .resizable()
            .interpolation(.medium)
            .aspectRatio(contentMode: .fill)
            .clipped(antialiased: true)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .ignoresSafeArea(edges: .top)
            .overlay {
              WhiteOverlay(model: .init(
                title: viewStore.chapter?.description ?? "",
                subtitle: viewStore.book?.name ?? ""
              ))
            }
            .id(1)

          paragraphsView

          Image(systemName: "arrow.up")
            .font(.system(size: 40))
            .foregroundStyle(.gray)
            .onTapGesture {
              withAnimation {
                scrolling.scrollTo(1)
              }
            }
        }
      }
    }
    .onLoad {
        viewStore.send(.loadPage(at: 1))
    }
  }
}

struct PageView_Preview: PreviewProvider {
  static var previews: some View {
    PageView(store: .init(initialState: .init(), reducer: {
      TestPageFeature()
        .dependency(\.parseClient, .singleValue)
    }))
  }
}

