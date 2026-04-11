// swift-tools-version: 6.3

import Foundation
import PackageDescription

let package = Package(
    name: "Shared",
    platforms: [
        .iOS(.v18),
        .macOS(.v15),
    ],
    products: [
        .library(
            name: "DottoAPI",
            type: .dynamic,
            targets: ["DottoAPI"]
        ),
        .library(
            name: "DottoModel",
            type: .dynamic,
            targets: ["DottoModel"]
        ),
    ],
    dependencies: [
      .package(url: "https://github.com/swiftlang/swift-java", from: "0.1.2"),
      .package(url: "https://github.com/apple/swift-openapi-generator", from: "1.6.0"),
      .package(url: "https://github.com/apple/swift-openapi-runtime", from: "1.7.0"),
      .package(url: "https://github.com/apple/swift-openapi-urlsession", from: "1.0.0"),
      .package(url: "https://github.com/swift-server/swift-openapi-async-http-client", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "DottoAPI",
            dependencies: [
                .target(name: "DottoModel"),
                .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
                .product(name: "OpenAPIURLSession", package: "swift-openapi-urlsession", condition: .when(platforms: [.iOS, .macOS])),
                .product(name: "OpenAPIAsyncHTTPClient", package: "swift-openapi-async-http-client", condition: .when(platforms: [.android])),
                .product(name: "SwiftJava", package: "swift-java", condition: .when(platforms: [.android]))
            ],
            plugins: [
                .plugin(name: "OpenAPIGenerator", package: "swift-openapi-generator"),
            ]
        ),
        .target(name: "DottoModel"),
    ],
    swiftLanguageModes: [.v6]
)

if ProcessInfo.processInfo.environment["ANDROID_NDK_ROOT"] != nil {
    package.targets.first { $0.name == "DottoAPI" }?.plugins?.append(
        .plugin(name: "JExtractSwiftPlugin", package: "swift-java")
    )
}
