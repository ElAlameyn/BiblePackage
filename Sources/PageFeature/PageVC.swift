//
//  UIKit+UIPageController.swift
//  DrawDemo
//
//  Created by Артем Калинкин on 27.04.2023.
//

import SwiftUI
import UIKit

struct PageVC<Page: View>: UIViewControllerRepresentable {
  final class Coordinator: NSObject, UIPageViewControllerDataSource {
    // MARK: Lifecycle

    init(parent: PageVC) {
      self.parent = parent
      self.controllers = parent.pages.map(UIHostingController.init(rootView:))
    }

    // MARK: Internal

    var parent: PageVC
    var controllers = [UIViewController]()

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
      guard let index = controllers.firstIndex(of: viewController) else { return nil }
      return index == 0 ? nil : controllers[index - 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
      guard let index = controllers.firstIndex(of: viewController) else { return nil }
      return index + 1 == controllers.count ? nil : controllers[index + 1]
    }
  }

  var pages: [Page]

  func makeUIViewController(context: Context) -> some UIPageViewController {
    let pageVC = UIPageViewController(
      transitionStyle: .scroll,
      navigationOrientation: .horizontal
    )
    pageVC.dataSource = context.coordinator
    return pageVC
  }

  func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    uiViewController.setViewControllers([context.coordinator.controllers[0]], direction: .forward, animated: true)
  }

  func makeCoordinator() -> Coordinator {
    Coordinator(parent: self)
  }
}
