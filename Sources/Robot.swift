//
//  Robot.swift
//  shanbay-ios-robot
//
//  Created by Xiaoyu Li on 06/07/2017.
//
//

import SlackKit

class Robot {
    let bot: SlackKit
    
    var currentAction: Action?
    lazy var actions: [Action] = {
        return [Build()]
    }()
    
    init(token: String) {
        bot = SlackKit()
        bot.addRTMBotWithAPIToken(token)
        bot.addWebAPIAccessWithToken(token)
        bot.notificationForEvent(.message) { (event, _) in
            // 做这个判断是因为及当 bot 自动回复的时候也会出发这个 event，所以这里只处理用户输入的 event
            guard let _ = event.user?.id else {
                return
            }
            guard let message = event.message else {
                return
            }
            self.handleMessage(message)
        }
    }
    
    func handleMessage(_ message: Message) {
        guard let text = message.text, let channel = message.channel else {
            return
        }
        if text.hasPrefix("exit") {
            currentAction = nil
            bot.byebye(inChannel: channel)
            return
        }
        if currentAction == nil {
            actions.forEach {
                if $0.canRespond(text) {
                    $0.tip(robot: bot, inChannel: channel)
                    currentAction = $0
                    return
                }
            }
            if let action = currentAction {
                action.robot(bot, respondTo: message)
            } else {
                bot.justForFun(message: text, inChannel: channel)
            }
        } else {
            currentAction?.robot(bot, runStepWithMessage: message)
        }
    }
}

extension SlackKit {
    func byebye(inChannel channel: String) {
        webAPI?.sendMessage(channel: channel, text: "👋👋", success: nil, failure: { error in
            print(error)
        })
    }
    
    func justForFun(message: String, inChannel channel: String) {
        webAPI?.sendMessage(channel: channel, text: "\(message)~~你真调皮😝", success: nil, failure: { error in
            print(error)
        })
    }
    
    func angryInChannel(_ channel: String) {
        webAPI?.sendMessage(channel: channel, text: "你这孩子怎么这么不听话，让你按要求回复你偏要瞎回", success: nil, failure: { error in
            print(error)
        })
    }
    
    func finishInChannel(_ channel: String) {
        webAPI?.sendMessage(channel: channel, text: "你所设置的任务都结束了，输入 exit 退出当前命令", success: nil, failure: { error in
            print(error)
        })
    }
}


