import ProjectDescription

let project = Project(
    name: "MyApp",
    targets: [
        .target(
            name: "MyApp",
            destinations: .macOS,
            product: .app,
            bundleId: "com.gyoge.MyApp",
            infoPlist: .default,
            sources: ["MyApp/Sources/**"],
            resources: ["MyApp/Resources/**"],
            dependencies: [
                .xcframework(path: "../zig-out/MylibKit.xcframework")
            ],
            settings: .settings()
        ),
        .target(
            name: "MyAppTests",
            destinations: .macOS,
            product: .unitTests,
            bundleId: "io.tuist.MyAppTests",
            infoPlist: .default,
            sources: ["MyApp/Tests/**"],
            resources: [],
            dependencies: [.target(name: "MyApp")],
            settings: .settings()
        ),
    ]
)
