//
//  View+Extension.swift
//  BibleApp
//
//  Created by Артем Калинкин on 14.08.2023.
//

import SwiftUI

extension Image {
  // MARK: - Home Screen

  func homeScreenDefaultPrayersConfiguration(_ rect: CGSize) -> some View {
    self
      .resizable()
      .aspectRatio(contentMode: .fill)
      .frame(width: 280, height: 240)
      .cornerRadius(16)
      .clipped()
      .padding()
  }

  func homeScreenCellSetup(mainText: String) -> some View {
    self
      .homeScreenDefaultPrayersConfiguration(
        .init(width: 280, height: 240)
      )
      .overlay(
        VStack {
          Text(mainText)
            .foregroundColor(.white)
            .font(.title)
            .bold()
            .shadow(color: .black, radius: 10)
        }
      )
      .overlay(
        VStack(alignment: .trailing) {
          Spacer()
          HStack {
            Spacer()
            Text("Перейти →")
              .padding(30)
              .foregroundColor(.white)
              .shadow(color: .black, radius: 5)
          }
        }
      )
  }
}
