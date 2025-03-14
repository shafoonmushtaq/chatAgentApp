import 'package:flutter/material.dart';

class ChatInput extends StatefulWidget {
  final Function(String) onSend;

  const ChatInput({super.key, required this.onSend});

  @override
  ChatInputState createState() => ChatInputState();
}

class ChatInputState extends State<ChatInput> {
  final TextEditingController _textController = TextEditingController();

  void _handleSubmitted() {
    if (_textController.text.isNotEmpty) {
      widget.onSend(_textController.text);
      _textController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -2),
            blurRadius: 4,
            color: Colors.grey
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: const InputDecoration(
                hintText: 'Send a message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(24.0)),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              ),
              onSubmitted: (_) => _handleSubmitted(),
            ),
          ),
          const SizedBox(width: 8.0),
          FloatingActionButton(
            onPressed: _handleSubmitted,
            elevation: 0,
            child: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}