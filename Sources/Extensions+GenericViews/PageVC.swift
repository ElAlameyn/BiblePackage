//
//  UIKit+UIPageController.swift
//  DrawDemo
//
//  Created by Артем Калинкин on 27.04.2023.
//
  
import SwiftUI
import UIKit

// TODO: Try PageVC
public struct PageVC: UIViewControllerRepresentable {

  public var pages: [AnyView]
  
  public init(pages: [some View])  {
    self.pages = pages.compactMap(AnyView.init)
  }

  public func makeUIViewController(context: Context) -> some UIPageViewController {
    let pageVC = UIPageViewController(
      transitionStyle: .scroll,
      navigationOrientation: .horizontal
    )
    pageVC.dataSource = context.coordinator
    return pageVC
  }

  public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    uiViewController.setViewControllers([context.coordinator.controllers[0]], direction: .forward, animated: true)
  }

  public func makeCoordinator() -> Coordinator {
    Coordinator(parent: self)
  }
}

extension PageVC {
  public final class Coordinator: NSObject, UIPageViewControllerDataSource {

    public init(parent: PageVC) {
      self.parent = parent
      self.controllers = parent.pages.map(UIHostingController.init(rootView:))
      self.controllers.forEach { $0.title = "\(Int.random(in: 0 ... 100))" }
    }

    public var parent: PageVC
    public var controllers = [UIViewController]()

    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
      guard let index = controllers.firstIndex(of: viewController) else { return nil }
      print("Index: \(index)")
      return index == 0 ? controllers[controllers.count - 1] : controllers[index - 1]
    }

    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
      guard let index = controllers.firstIndex(of: viewController) else { return nil }
      print("Index: \(index)")
      return index + 1 == controllers.count ? controllers[0] : controllers[index + 1]
    }
  }
}
