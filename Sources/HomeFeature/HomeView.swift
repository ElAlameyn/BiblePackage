//  ContentView.swift
//  BibleApp
//
//  Created by Артем Калинкин on 28.04.2023.
//

import ComposableArchitecture
import SwiftUI
import Extensions_GenericViews



public struct HomeView: View {
  let store: StoreOf<HomeFeature>

  public init(store: StoreOf<HomeFeature>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { _ in
      NavigationStack {
        ZStack {
          Color.gray.opacity(0.3)
            .opacity(0.3)
            .ignoresSafeArea()

          VStack {
            NavigationLink {
              PageVC(pages: [
                ChapterPage()
              ])
            } label: {
              Image("bible", bundle: .module)
                .homeScreenDefaultPrayersConfiguration(
                  .init(width: 320, height: 240)
                )
                .overlay(
                  WhiteOverlay(
                    model: .init(
                      title: "Продолжить чтение",
                      subtitle: "Глава 3 / Стр. 23"
                    ),
                    isCornerRadiusEnabled: true
                  )
                )
            }

            Text("Молитвенные правила")
              .font(.title)
              .bold()
              .padding(.leading, -40)

            ScrollView(.horizontal, showsIndicators: false) {
              HStack {
                Image("morning_rule", bundle: .module)
                  .homeScreenCellSetup(mainText: "Утреннее\n правило")

                Image("evening_rule", bundle: .module)
                  .homeScreenCellSetup(mainText: "Вечернее\n правило")
              }
            }

            Spacer()
          }
          .navigationBarTitleDisplayMode(.large)
          .navigationTitle("Библия")
        }
      }
    }
  }
}

struct ChapterPage: View {
  var body: some View {
    GeometryReader { proxy in
      VStack {
        Image("matfey", bundle: .module)
          .resizable()
          .interpolation(.medium)
          .aspectRatio(contentMode: .fill)
          .frame(width: proxy.width, height: proxy.height / 3, alignment: .top)
          .clipped(antialiased: true)
          .overlay {
            WhiteOverlay(model: .init(title: "Глава 1", subtitle: "Евангелие от Матфея"))
          }

        VStack(spacing: 20) {
          ForEach(0 ... 5, id: \.self) { _ in
            Menu {
              Button("Показать толкование", action: {})
              Button("Сохранить в заметки", action: {})
            } label: {
              Text(verbatim: .loremIpsum5)
                .multilineTextAlignment(.leading)
                .font(.system(.body))
                .padding(.leading, 10)
                .padding(.trailing, 10)
            }
            .foregroundColor(.black)
          }
          .minimumScaleFactor(0.1)
        }
        .background(.white)
      }
    }
    .edgesIgnoringSafeArea(.top)
  }
}


struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
//    HomeView(store: .init(initialState: .init(), reducer: { HomeFeature() }))
    PageVC(pages: [
      ChapterPage()
    ])
    .edgesIgnoringSafeArea(.top)
  }
}

extension String {
  static let loremIpsum5 = """
  Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
  """
}
