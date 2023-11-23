// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "BiblePackage",
  platforms: [.iOS(.v16), .macOS(.v11)],
  products: [
    .library(name: "BiblePackage", targets: ["BiblePackage"]),
    .library(name: "PageFeature", targets: ["PageFeature"]),
    .library(name: "Extensions+GenericViews", targets: ["Extensions+GenericViews"]),
    .library(name: "HomeFeature", targets: ["HomeFeature"]),
  ],
  dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.1.0"),
    .package(url: "https://github.com/pointfreeco/swift-overture", from: "0.5.0"),
    .package(url: "https://github.com/pointfreeco/swift-parsing", from: "0.13.0"),
  ],
  targets: [
    .target(name: "ParserClient", dependencies: [
      "Helpers",
      .product(name: "Parsing", package: "swift-parsing"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ], resources: [
      .process("Resources"),
    ]),
    .target(name: "BiblePackage", dependencies: [
      "HomeFeature",
      "PageFeature",
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(
      name: "HomeFeature",
      dependencies: [
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        "Extensions+GenericViews",
      ]),
    .target(name: "Helpers"),
    .target(
      name: "PageFeature",
      dependencies: [
        "ParserClient",
        "Extensions+GenericViews",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        .product(name: "Overture", package: "swift-overture"),
      ]),
    .target(name: "Extensions+GenericViews", dependencies: []),
    .testTarget(name: "BiblePackageTests", dependencies: ["BiblePackage"]),
    .testTarget(name: "ParserClientTests", dependencies: ["ParserClient"]),
  ])
