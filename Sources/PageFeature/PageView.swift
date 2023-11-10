//
//  SwiftUIView.swift
//
//
//  Created by Артем Калинкин on 08.09.2023.
//

import ComposableArchitecture
import SwiftUI
import Extensions_GenericViews

public struct PageView: View {
  public init() {
    UINavigationBar.appearance().tintColor = .white
  }

  public var body: some View {
    GeometryReader { proxy in
      ScrollView {
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


struct PageView_Preview: PreviewProvider {
  static var previews: some View {
    PageView()
  }
}

