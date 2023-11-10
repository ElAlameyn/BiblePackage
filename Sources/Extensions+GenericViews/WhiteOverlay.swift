//
//  SwiftUIView.swift
//  
//
//  Created by Артем Калинкин on 04.09.2023.
//

import SwiftUI

public struct WhiteOverlay: View {
  public struct Model {
    var title: String
    var subtitle: String

    public init(title: String?, subtitle: String) {
      self.title = title ?? ""
      self.subtitle = subtitle ?? ""
    }
  }

  var model: Model
  var isCornerRadiusEnabled = false

  public init(model: Model, isCornerRadiusEnabled: Bool = false) {
    self.model = model
    self.isCornerRadiusEnabled = isCornerRadiusEnabled
  }

  public var body: some View {
    GeometryReader { proxy in
      LinearGradient(
        stops: [
          Gradient.Stop(color: .white.opacity(0), location: 0.0),
          Gradient.Stop(color: .white, location: 0.7)
        ],
        startPoint: UnitPoint(x: 0.5, y: 0),
        endPoint: UnitPoint(x: 0.5, y: 1.05)
      )
      .frame(width: proxy.width, height: proxy.height)
      .clipped()
      .cornerRadius(isCornerRadiusEnabled ? 16 : 0)
      .overlay(alignment: .leading) {
        VStack {
          Spacer()
          VStack(alignment: .leading) {
            Text(model.title)
              .font(.title2)
              .bold()
            Text(model.subtitle)
              .font(.title3)
          }
          .padding()
        }
      }
    }
  }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
      ZStack {
        Color.blue.background()

        WhiteOverlay(model: .init(title: "Hello", subtitle: "World"))
      }
    }
}
