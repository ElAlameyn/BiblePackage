//
//  File.swift
//
//
//  Created by Артем Калинкин on 29.10.2023.
//

import ComposableArchitecture
import Overture
import ParserClient
import PDFKit

public struct PageFeature: Reducer {
  public init() {}

  public struct State: Equatable {
    var pageNumber: Int = 0
    var chapter: Chapter?
    var book: Book?
    var paragraphs = IdentifiedArrayOf<Paragraph>()
    var loadingState: LoadingPageState = .none
    var scrollState: ScrollReducer.State = .init()

    public init() {}
  }

  enum LoadingPageState {
    case additionalLoading
    case nextPage
    case none
  }

  @Dependency(\.parseClient) var parseClient

  public enum Action: Hashable {
    case loadPage(at: Int)
    case nextPage
    case previousPage
    case parsingResult(TaskResult<Page>)
    case scrollAction(ScrollReducer.Action)
    case paragraphAction(Int, ParagraphFeature.Action)
  }

  public var body: some Reducer<State, Action> {
    Scope(state: \.scrollState, action: /Action.scrollAction) {
      ScrollReducer()
    }

    Reduce { state, action in
      switch action {
      case .loadPage(at: let number):
        state.pageNumber = number
        if state.loadingState != .additionalLoading { clear(&state) }

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
          return .run { [number = state.pageNumber] send in
            await send(.loadPage(at: number + 1))
          }
        case .continious(let continuousPageInfo):
          switch state.loadingState {
          case .additionalLoading:
            state.paragraphs[state.paragraphs.endIndex - 1].text += " " + (continuousPageInfo.extraParagraph ?? "")
            state.paragraphs += continuousPageInfo.previousChapterParagraphs
            state.loadingState = .nextPage
          case .nextPage, .none:
            state.chapter = continuousPageInfo.currentChapter
            state.paragraphs = IdentifiedArray(uniqueElements: continuousPageInfo.currentChapterParagraphs)
            state.loadingState = .additionalLoading
            
            return .run { [number = state.pageNumber] send in
              await send(.loadPage(at: number + 1))
            }
          }
        }
      case .parsingResult(.failure(let error)):
        // TODO: Handle error
        break
      case .nextPage:
        return .send(.loadPage(at: state.pageNumber))
      case .previousPage:
        return state.pageNumber > 2 ? .send(.loadPage(at: state.pageNumber - 2)) : .none
      case .scrollAction: break
      case .paragraphAction: break
      }
      return .none
    }
    .forEach(\.paragraphs, action: /Action.paragraphAction) {
      ParagraphFeature()
    }
    
  }
//  
//   let clear = concat(
//    mut(\State.chapter, nil),
//    mver(\.paragraphs) { $0.removeAll() }
//  )
  private func clear(_ state: inout State) {
    state.chapter = nil
    state.paragraphs.removeAll()
  }

}
