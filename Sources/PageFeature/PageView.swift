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
  @State var isScrolling = false

  public init(store: StoreOf<PageFeature>) {
    self.store = store
    UINavigationBar.appearance().tintColor = .white
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
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
                WhiteOverlay(model: .init(title: viewStore.chapter?.description ?? "", subtitle: viewStore.book?.name ?? ""))
              }
            VStack(alignment: .leading, spacing: 20) {
              ForEach(viewStore.paragraphs, id: \.self) { paragraph in
                Menu {
                  Button("Показать толкование", action: {})
                  Button("Сохранить в заметки", action: {})
                } label: {
                  Text(verbatim: paragraph.description)
                    .multilineTextAlignment(.leading)
                    .font(.system(.body))
                    .padding(.leading, 10)
                    .padding(.trailing, 10)
                }
//                .allowsHitTesting(!viewStore.isScrolling)
                .foregroundColor(.black)
              }
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
              Image(systemName: "arrow.left.circle")
                .font(.system(size: 60))
                .onTapGesture {
                  viewStore.send(.previousPage)
                }
              Image(systemName: "arrow.right.circle")
                .font(.system(size: 60))
                .onTapGesture {
                  viewStore.send(.nextPage)
                }
            }
          }
          // TODO: Make UISwipeGesture()
          // TODO: Make LongPressGesture for Menu
          
//          .gesture(DragGesture(minimumDistance: 3.0, coordinateSpace: .local)
//            .onEnded { value in
//              print(value.translation)
//              switch (value.translation.width, value.translation.height) {
//              case (...0, -30...30): viewStore.send(.nextPage)
//              case (0..., -30...30): viewStore.send(.previousPage)
//              default: break
//              }
//            }
//          )
        } else {
          Centralized {
            ProgressView()
              .scaleEffect(3.2)
          }
          .onAppear {
            viewStore.send(.loadPage(at: 1))
          }
        }
      }
      .edgesIgnoringSafeArea(.top)
    }
  }
}

struct PageView_Preview: PreviewProvider {
  static var previews: some View {
    PageView(store: .init(initialState: .init(), reducer: {
      TestPageFeature()
    }))
  }
}
