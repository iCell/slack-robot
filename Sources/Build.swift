//
//  Build.swift
//  shanbay-ios-robot
//
//  Created by Xiaoyu Li on 06/07/2017.
//
//

import Foundation
import SlackKit

enum BuildType: Int {
    case word = 1
    case news
    case listen
    case speak
    case sentence
    case poetry
}

struct Build: Action {
    var stepIndex: Int = 0
    let triggerCommand: String = "build"
    let steps: [Step] = [BuildStepOne(), BuldStepTwo()]
    
    func robot(_ robot: SlackKit, respondTo message: Message) {
        guard let channel = message.channel else {
            return
        }
        robot.webAPI?.sendMessage(channel: channel, text: "你想 build 哪个？\n直接告诉我序号，不然我不懂。\n1. 单词\n2. 阅读\n3. 听力\n4. 口语\n5. 炼句\n6. 诗词", success: nil, failure: { (error) in
            print(error)
        })
    }
    
    mutating func robot(_ robot: SlackKit, runStepWithMessage message: Message) {
        guard let text = message.text, let channel = message.channel else {
            return
        }
        if 0..<steps.count ~= stepIndex {
            let currentStep = steps[stepIndex]
            if currentStep.isValid(msg: text) {
                currentStep.run(robot: robot, msg: text, channel: channel)
            } else {
                robot.angryInChannel(channel)
            }
            if stepIndex == steps.count - 1 {
                robot.finishInChannel(channel)
            }
            stepIndex += 1
        } else {
            fatalError("out of range")
        }
    }
}

struct BuildStepOne: Step {
    func isValid(msg: String) -> Bool {
        if let type = Int(msg), let _ = BuildType.init(rawValue: type) {
            return true
        } else {
            return false
        }
    }
    
    func run(robot: SlackKit, msg: String, channel: String) {
        robot.webAPI?.sendMessage(channel: channel, text: "按照 1.0.0/20 这样的格式回复版本号和 build 号", success: nil, failure: { (error) in
            print(error)
        })
    }
}

struct BuldStepTwo: Step {
    func isValid(msg: String) -> Bool {
        if msg.contains("/") == false {
            return false
        }
        let subs = msg.split("/").filter { $0.characters.count != 0 }
        return subs.count == 2
    }
    
    func run(robot: SlackKit, msg: String, channel: String) {
        robot.webAPI?.sendMessage(channel: channel, text: "回复你要 build 的分支名", success: nil, failure: { (error) in
            print(error)
        })
    }
}
