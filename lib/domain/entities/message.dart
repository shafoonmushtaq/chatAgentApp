class Message {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final String agentId;

  Message({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
    required this.agentId,
  });
}