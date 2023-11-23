//
//  File.swift
//  
//
//  Created by Артем Калинкин on 17.11.2023.
//

import Foundation
import ComposableArchitecture

struct TestPageFeature: Reducer {
  typealias State = PageFeature.State

  typealias Action = PageFeature.Action

  @Dependency(\.parseClient) var parseClient

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .loadPage(at: let number):
        state.pageNumber = number

        return .run { send in
          await send(.parsingResult(TaskResult {
            try parseClient.parsePage(number)
          }))
        }
      case .parsingResult(.success(let page)):
        switch page {
        case .start(let startPageInfo):
          state.book = startPageInfo.bibleBookName
          state.chapter = startPageInfo.chapter
          state.paragraphs += startPageInfo.paragraphs
          state.loadingState = .additionalLoading
          return .none
        default:
          return .none
        }
      case .nextPage:
        return .send(.loadPage(at: state.pageNumber + 1))
      default:
        return .none
      }
    }
//    .dependency(\.parseClient, .testValue)
  }
}
