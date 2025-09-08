import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BasicMessenger extends StatefulWidget {
  @override
  State<BasicMessenger> createState() => _BasicMessengerState();
}

class _BasicMessengerState extends State<BasicMessenger> {
  static final _channel = BasicMessageChannel<String>(
    'samples.flutter.dev/basic',
    const StringCodec(),
  );
  final List<String> _messages = [];
  final TextEditingController _textController = TextEditingController();
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    _channel.setMessageHandler((message) async {
      setState(() {
        _messages.add("Native: $message");
      });
      _counter++; // Increment counter for Flutter's reply
      final String flutterReply =
          "Flutter replies: Got your message ✅ $_counter";
      setState(() {
        _messages.add("Flutter Reply: $flutterReply");
      });
      return flutterReply;
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Basic Messenger")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true, // Show latest messages at the bottom
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
                  child: Text(_messages[_messages.length - 1 - index]),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: "Send a message",
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _sendCustomMessage(),
                  ),
                ),
                SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: _sendCustomMessage,
                  child: Text("Send"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _sendCustomMessage() async {
    final String messageToSend = _textController.text;
    if (messageToSend.isNotEmpty) {
      setState(() {
        _messages.add("Flutter: $messageToSend");
      });
      _textController.clear();
      final reply = await _channel.send(messageToSend);
      if (reply != null) {
        setState(() {
          _messages.add("Native Reply: $reply");
        });
      }
    }
  }
}
