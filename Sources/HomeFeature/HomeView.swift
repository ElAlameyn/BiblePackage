//  ContentView.swift
//  BibleApp
//
//  Created by Артем Калинкин on 28.04.2023.
//

import ComposableArchitecture
import Extensions_GenericViews
import SwiftUI

struct Appearance {
  static func whiteBoldTitleTextStyle() {
    UIBarButtonItem.appearance()
      .setTitleTextAttributes([
        .foregroundColor: UIColor.white.withAlphaComponent(0.9),
      ], for: .normal)

    UIBarButtonItem.appearance().tintColor = UIColor.white.withAlphaComponent(0.9)
  }

}

public struct HomeView: View {
  let store: StoreOf<HomeFeature>

  public init(store: StoreOf<HomeFeature>) {
    self.store = store
    Appearance.whiteBoldTitleTextStyle()
  }

  // TODO: Add morning & evening rule
  // TODO: Think about loading info from server
  public var body: some View {
    WithViewStore(store, observe: { $0 }) { _ in
      NavigationStack {
        ZStack {
          Color.gray.opacity(0.3)
            .opacity(0.3)
            .ignoresSafeArea()

          VStack {
            NavigationLink {
//              PageVC(pages: [
//                EmptyView()
//              ])
//              .ignoresSafeArea()
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
      .tint(.black)
    }
  }
}

struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    HomeView(store: .init(initialState: .init(), reducer: { HomeFeature() }))
  }
}


