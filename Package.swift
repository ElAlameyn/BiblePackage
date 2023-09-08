// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "BiblePackage",
  platforms: [.iOS(.v16)],
  products: [
    // Products define the executables and libraries a package produces, and make them visible to other packages.
    .library(
      name: "BiblePackage",
      targets: ["BiblePackage"]),
    .library(
      name: "HomeFeature",
      targets: ["HomeFeature"]),
    .library(
      name: "Extensions+GenericViews",
      targets: ["Extensions+GenericViews"]),
  ],
  dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.1.0"),
    .package(url: "https://github.com/pointfreeco/swift-overture", from: "0.5.0"),
  ],
  targets: [
    .target( name: "BiblePackage", dependencies: [ "HomeFeature", ]),
    .target(
      name: "HomeFeature",
      dependencies: [
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        "Extensions+GenericViews"
      ], resources: [
        .copy("Bible.pdf"),
      ]),
    .target(name: "Extensions+GenericViews", dependencies: []),
    .testTarget(name: "BiblePackageTests", dependencies: ["BiblePackage"]),
  ])
