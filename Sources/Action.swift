//
//  Action.swift
//  shanbay-ios-robot
//
//  Created by Xiaoyu Li on 06/07/2017.
//
//

import Foundation
import SlackKit

protocol Action {
    var stepIndex: Int { get set }
    var triggerCommand: String { get }
    var steps: [Step] { get }
    
    func robot(_ robot: SlackKit, respondTo message: Message)
    mutating func robot(_ robot: SlackKit, runStepWithMessage message: Message)
}

extension Action {
    func canRespond(_ command: String) -> Bool {
        return command == triggerCommand
    }
    
    func tip(robot: SlackKit, inChannel channel: String) {
        robot.webAPI?.sendMessage(channel: channel, text: "你当前处于\(triggerCommand) 命令中，想退出的话请输入 exit 即可", success: nil, failure: { error in
            print(error)
        })
    }
}

protocol Step {
    func isValid(msg: String) -> Bool
    func run(robot: SlackKit, msg: String, channel: String)
}
