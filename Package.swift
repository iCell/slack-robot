// swift-tools-version:3.1

import PackageDescription

let package = Package(
    name: "shanbay-ios-robot",
    dependencies: [
	    .Package(url: "https://github.com/SlackKit/SlackKit.git", majorVersion: 4),
    ]
)
