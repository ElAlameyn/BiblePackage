//
//  File.swift
//
//
//  Created by Артем Калинкин on 07.11.2023.
//

import Combine
import PDFKit


class BibleManager {
  private let pdf = PDFDocument(url:
    Bundle.module.url(forResource: "Bible", withExtension: "pdf")!
  )!

  private var currentPageNumber: Int = 0
  private var currentLoadingState = PageState.none
  private var cancellables = Set<AnyCancellable>()
  public var loadPage = CurrentValueSubject<Int, Never>(0)

  public var shownBookName: Book?
  public var shownChapter: Chapter?
  @Published public var shownParagraphs = [Paragraph]()

  init() {
    bind()
  }

  enum PageState {
    case additionalLoading
    case nextPage
    case none
  }
  
  private func clearState() {
    shownChapter = nil
    shownBookName = nil
    shownParagraphs.removeAll()
  }

  private func bind() {
    
    
    loadPage
      .subscribe(on: DispatchQueue.global())
      .dropFirst(1)
      .handleEvents(receiveOutput: { [weak self] in
        guard let self else { return }
        if currentLoadingState != .additionalLoading { clearState() }
        currentPageNumber = $0
      })
      .compactMap { [weak self] in
        self?.pdf.page(at: $0 + 34)?.string
      }
      .subscribe(on: DispatchQueue.global())
      .tryMap {
        try PageParser().parse($0[...])
      }
      .printThread()
//      .receive(on: DispatchQueue.main)
      .sink(
        receiveCompletion: {
          if case let .failure(error) = $0 {
            print(error)
          }
        },
        receiveValue: { [weak self] in
          self?.update(page: $0)
        })
      .store(in: &cancellables)
  }

  private func update(page: Page) {
    switch page {
    case let .start((book, chapter, paragraphs)):
      shownBookName = book
      shownChapter = chapter
      shownParagraphs += paragraphs
      currentLoadingState = .additionalLoading
      loadPage.send(currentPageNumber + 1)
    case let .continious((extra, previousParagraphs, currentChapter, currentParagraph)):
      switch currentLoadingState {
      case .additionalLoading:
        shownParagraphs[shownParagraphs.endIndex - 1].text += " " + (extra ?? "")
        shownParagraphs += previousParagraphs
        currentLoadingState = .nextPage
      case .nextPage, .none:
        shownChapter = currentChapter
        shownParagraphs = currentParagraph
        currentLoadingState = .additionalLoading
        loadPage.send(currentPageNumber + 1)
      }
    }
  }
}
