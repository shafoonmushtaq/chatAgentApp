import 'package:flutter/material.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../domain/entities/agent.dart';
import '../../../domain/entities/message.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
  final Agent agent;

  const MessageBubble({
    super.key,
    required this.message,
    required this.agent,
  });

  @override
  Widget build(BuildContext context) {
    final isUserMessage = message.isUser;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: isUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUserMessage) ...[
            CircleAvatar(
              backgroundColor: agent.color,
              radius: 16,
              child: Text(
                agent.name.isNotEmpty ? agent.name[0] : "?",
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              decoration: BoxDecoration(
                color: isUserMessage ? Colors.teal.shade200 : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(18.0),
              ),
              child: Column(
                crossAxisAlignment: isUserMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormatter.formatTime(message.timestamp),
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isUserMessage) ...[
            const SizedBox(width: 8),
            const CircleAvatar(
              backgroundColor: Colors.teal,
              radius: 16,
              child: Icon(
                Icons.person,
                size: 18,
                color: Colors.white,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
