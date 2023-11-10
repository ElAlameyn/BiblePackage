//
//  File.swift
//
//
//  Created by Артем Калинкин on 01.11.2023.
//

import Foundation
import Helpers
import Parsing
import PDFKit


struct ParagraphParser: Parser {
  var body: some Parser<Substring.UTF8View, Paragraph> {
    Parse(Paragraph.init(number:text:)) {
      Digits()
      " ".utf8
      Prefix(1...) { !$0.isDigit }.map(.string).map { (res: String) -> String in
        let replace = res.replacingOccurrences(of: "\n", with: " ")
        var excludeWhitespace = replace.replacingOccurrences(of: "  ", with: " ")
        if excludeWhitespace.last == " " { excludeWhitespace.removeLast() }
        return excludeWhitespace
      }
    }
  }
}

struct ManyParagraphsParser: Parser {
  var body: some Parser<Substring.UTF8View, [Paragraph]> {
    Whitespace()
    Many {
      ParagraphParser()
    }
    Whitespace()
  }
}

struct ChapterParser: Parser {
  var body: some Parser<Substring.UTF8View, Chapter> {
    Parse(Chapter.init(name:number:)) {
      "Глава".utf8.map { _ in "Глава" }
      " ".utf8
      Digits()
      "\n".utf8
    }
  }
}

struct BookPageParser: Parser {
  var body: some Parser<Substring.UTF8View, PageInfo> {
    Whitespace()
    // TODO: Add conformacne to all books
    Parse(Book.init(name:)) {
      PrefixUpTo("\n".utf8).map(.string)
      "\n".utf8
    }
    Whitespace()
    ChapterParser()
    Whitespace()
    ManyParagraphsParser()
  }
}

struct FirstLineParser: Parser {
  var body: some Parser<Substring.UTF8View, String> {
    Peek {
      Prefix(1) { !$0.isDigit }
    }
    Prefix(1...) { !$0.isDigit }.map(.string)
  }
}

struct ContinuePageParser: Parser {
  var body: some Parser<Substring.UTF8View, ContinuousPageInfo> {
    PrefixUpTo("Глава".utf8).pipe {
      Optionally {
        Backtracking {
          FirstLineParser()
        }
      }
      ManyParagraphsParser()
    }
    ChapterParser()
    ManyParagraphsParser()
  }
}


struct PageParser: Parser {
  var body: some Parser<Substring.UTF8View, Page> {
    OneOf {
      BookPageParser().map { Page.start($0) }
      ContinuePageParser().map { Page.continious($0) }
    }
  }
}

