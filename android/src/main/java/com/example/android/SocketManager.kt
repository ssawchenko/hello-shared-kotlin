package com.example.android

import com.github.nkzawa.emitter.Emitter
import com.github.nkzawa.socketio.client.IO
import com.github.nkzawa.socketio.client.Socket
import com.willowtreeapps.hellokotlin.Sockets
import com.willowtreeapps.hellokotlin.parseMessage


class SocketManager: Sockets {
    private var ref: Socket? = null

    private val event = "users"
    private val server = "http://10.0.1.2:3001/"

    init {
        ref = try {
            //IO.socket("https://socket-io-chat.now.sh/")
            IO.socket(server)
        } catch (e: Exception) {
            null
        }
    }

    fun connect() {
        ref?.let {
            it.on(event, onNewMessage)
            it.connect()
            it.emit("join", "Player2")
        }
    }

    fun disconnect() {
        ref?.let {
            it.disconnect();
            it.off(event, onNewMessage)
          }
    }

    override fun onMessage(objects: Array<Any>) {
        parseMessage(objects)
    }

    private val onNewMessage = Emitter.Listener { args ->
        onMessage(args)
    }

//
//    private Emitter.Listener onNewMessage = new Emitter.Listener() {
//        @Override
//        public void call(final Object.. args) {
//            getActivity().runOnUiThread(new Runnable() {
//                @Override
//                public void run() {
//                    JSONObject data = (JSONObject) args[0];
//                    String username;
//                    String message;
//                    try {
//                        username = data.getString("username");
//                        message = data.getString("message");
//                    } catch (JSONException e) {
//                        return;
//                    }
//
//                    // add the message to view
//                    addMessage(username, message);
//                }
//            });
//        }
//    };
}

