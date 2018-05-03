//
//  ViewController2.swift
//  Hello Shared Kotlin
//
//  Created by Jake on 2018-05-03.
//  Copyright © 2018 WillowTree. All rights reserved.
//

import UIKit
import KotlinHello
import SocketIO

class ViewControllerTwo: UIViewController {
    @IBOutlet weak var red: UIControl!
    @IBOutlet weak var green: UIControl!
    @IBOutlet weak var blue: UIControl!
    @IBOutlet weak var yello: UIControl!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var playersLabel: UILabel!

    var socket: SocketIOClient!

    deinit {
        socket.emit("leave", "iOS")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        socket = SocketIOClient(socketURL: URL(string: "http://10.0.1.2:3000")!)

        socket.on(clientEvent: .connect) { _, _ in
            self.socket.emit("join", "iOS")
        }

        socket.on(clientEvent: .disconnect) { _, _ in
        }


        socket.on(clientEvent: .reconnect) { _, _ in
        }


//        response = "response",
//        selectionSet = "selectionSet",
//        guessSet = "guessSet",
//        users = "users",
//        error = "errorSent" // gotta use a name that isn't just error

        socket.on("response") { data, _ in
            guard let errorDict = data[0] as? [String: Any], let message = errorDict["message"] as? String else {
                return
            }

            self.label.text = message

            if message.contains("New match") {
                self.red.backgroundColor = .red
                self.blue.backgroundColor = .blue
                self.green.backgroundColor = .green
                self.yello.backgroundColor = .yellow
            }

//            label.text = message
        }

        socket.on("selectionSet") { data, _ in
            self.label.text = "selection set, start guessing!"
        }

        socket.on("guessSet") { data, _ in
//            self.label.text = "guess was set!"
        }

        socket.on("users") { data, _ in
            // do nothing
            guard let errorDict = data[0] as? [String: Any], let message = errorDict["users"] as? [String] else {
                return
            }

            self.playersLabel.text = message.joined(separator: ", ")
        }

        socket.on("error") { data, _ in
//            label.text = error
        }

        red.backgroundColor = .red
        blue.backgroundColor = .blue
        green.backgroundColor = .green
        yello.backgroundColor = .yellow

        socket.connect()

        red.addTarget(self, action: #selector(sendColor(_:)), for: .touchUpInside)
        green.addTarget(self, action: #selector(sendColor(_:)), for: .touchUpInside)
        blue.addTarget(self, action: #selector(sendColor(_:)), for: .touchUpInside)
        yello.addTarget(self, action: #selector(sendColor(_:)), for: .touchUpInside)
    }

    func sendSelection(string: String) {
        socket.emit("selection", string)
    }

    @objc func sendColor(_ sender: Any) {
        if socket.status != .connected {
            socket.connect()
        }
        guard let button = sender as? UIControl else {
            return
        }
        red.backgroundColor = .red
        blue.backgroundColor = .blue
        green.backgroundColor = .green
        yello.backgroundColor = .yellow
        button.backgroundColor = UIColor.gray
        if button == red {
            sendSelection(string: "red")
        } else if button == blue {
            sendSelection(string: "blue")

        } else if button == yello {
            sendSelection(string: "yellow")
        } else if button == green {
            sendSelection(string: "green")
        }
    }
}
