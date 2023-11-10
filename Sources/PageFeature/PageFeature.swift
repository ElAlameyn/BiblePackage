//
//  File.swift
//  
//
//  Created by Артем Калинкин on 29.10.2023.
//

import ComposableArchitecture


struct Paragraph {
  var text: String
}

struct PageFeature: Reducer {
  struct State {
    var paragraphs = [Paragraph]()
  }

  struct Action {
  }

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
        default: break
      }
      return .none
    }
  }
}

