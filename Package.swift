// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "SNSSchoolsApp",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "SNSSchoolsApp",
            targets: ["SNSSchoolsApp"]
        )
    ],
    targets: [
        .target(
            name: "SNSSchoolsApp",
            dependencies: [],
            path: "Sources"
        )
    ]
)
