import ProjectDescription

let project = Project(
    name: "SNSSchoolsApp",
    targets: [
        .target(
            name: "SNSSchoolsApp",
            destinations: .iOS,
            product: .app,
            bundleId: "com.snsschools.app",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [:],
                    "NSLocalNetworkUsageDescription": "This app needs to access your local network to communicate with the SNS Schools server",
                    "NSBonjourServices": ["_http._tcp", "_https._tcp"]
                ]
            ),
            sources: ["SNSSchoolsApp/**"],
            resources: ["Resources/**"],
            dependencies: []
        ),
        .target(
            name: "SNSSchoolsAppTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.snsschools.app.tests",
            infoPlist: .default,
            sources: ["Tests/**"],
            dependencies: [
                .target(name: "SNSSchoolsApp")
            ]
        )
    ]
)
