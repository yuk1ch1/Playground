// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription


/*
 これでやってるwork aroundを理解したかった
 https://github.com/tgrapperon/swift-dependencies-additions/pull/65
 */

let package = Package(
    name: "PackageExample",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "DependenciesAdditionsLibrary",
            targets: ["DependenciesAdditionsTarget"]
        ),
        .library(
            name: "DependenciesLibrary",
            targets: ["DependenciesTarget"]
        ),
    ],
    // このパッケージが依存する外部のパッケージを定義
    dependencies: [
        .package(url: "https://github.com/tgrapperon/swift-dependencies-additions", exact: "0.4.0"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "0.1.0"),
        // https://github.com/tgrapperon/swift-dependencies-additions/pull/65
        .package(url: "https://github.com/pointfreeco/xctest-dynamic-overlay", from: "0.8.0"),
    ],
    targets: [
        .target(
            name: "DependenciesAdditionsTarget",
            // このtargetが依存するtargetやproductを定義
            dependencies: [
                .product(name: "DependenciesAdditions", package: "swift-dependencies-additions"),
                // https://github.com/tgrapperon/swift-dependencies-additions/pull/65
                .product(name: "XCTestDynamicOverlay", package: "xctest-dynamic-overlay")
            ]
        ),
        .target(
            name: "DependenciesTarget",
            dependencies: [
                .product(name: "Dependencies", package: "swift-dependencies"),
            ]
        ),
    ]
)
