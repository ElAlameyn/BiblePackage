//
//  SwiftUIView.swift
//
//
//  Created by Артем Калинкин on 08.09.2023.
//

import ComposableArchitecture
import Extensions_GenericViews
import SwiftUI

public struct PageView: View {
  let store: StoreOf<PageFeature>
  @ObservedObject var viewStore: ViewStoreOf<PageFeature>
  @State var isScrolling = false
  private let action: PageFeature.Action
  @State var isPresented = false

  @MainActor public init(store: StoreOf<PageFeature>, action: PageFeature.Action = .loadPage(at: 1)) {
    self.store = store
    self.viewStore = ViewStore(store, observe: { $0 })
    self.action = action
    UINavigationBar.appearance().tintColor = .white
  }

  public var body: some View {
    ScrollViewReader { scrolling in
      GeometryReader { proxy in
        if !viewStore.paragraphs.isEmpty {
          ScrollView {
            Image("matfey", bundle: .module)
              .resizable()
              .interpolation(.medium)
              .aspectRatio(contentMode: .fill)
              .frame(width: proxy.width, height: proxy.height / 3, alignment: .top)
              .clipped(antialiased: true)
              .overlay {
                WhiteOverlay(model: .init(
                  title: viewStore.chapter?.description ?? "",
                  subtitle: viewStore.book?.name ?? ""
                ))
              }
              .id(1)

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


            HStack {


              Image(systemName: "arrow.left")
                .font(.system(size: 40))
                .foregroundStyle(.gray)
                .onTapGesture {
                  viewStore.send(.previousPage)
                }

              Spacer()
              Image(systemName: "arrow.up")
                .font(.system(size: 40))
                .foregroundStyle(.gray)
                .onTapGesture {
                  withAnimation {
                    scrolling.scrollTo(1)
                  }
                }

              Spacer()


              Image(systemName: "arrow.right")
                .font(.system(size: 40))
                .foregroundStyle(.gray)
                .onTapGesture {
                  viewStore.send(.nextPage)
                }
            }
            .padding()
          }
        } else {
          Centralized {
            ProgressView()
              .scaleEffect(3.2)
          }
        }
      }
      .edgesIgnoringSafeArea(.top)
    }
    .transition(.slide)
    .onLoad {
      viewStore.send(action)
    }
    .overlay(isPresented ? EmptyView().transition(.move(edge: .leading)) : nil)
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

// MARK: - Maybe later

//                NavigationLink {
//                  PageView(store: self.store, action: .nextPage)
//                } label: {
//                                  Image(systemName: "arrow.right")
//                                    .font(.system(size: 40))
//                                    .foregroundStyle(.gray)
//                }

//              NavigationLink {
//                PageView(store: self.store, action: .previousPage)
//              } label: {
//                Image(systemName: "arrow.left")
//                  .font(.system(size: 40))
//                  .foregroundStyle(.gray)
//              }
