import '../../domain/entities/message.dart';

class MessageModel extends Message {
  MessageModel({
    required super.id,
    required super.text,
    required super.isUser,
    required super.timestamp,
    required super.agentId,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      text: json['text'],
      isUser: json['isUser'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp']),
      agentId: json['agentId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'isUser': isUser,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'agentId': agentId,
    };
  }

  factory MessageModel.fromEntity(Message message) {
    return MessageModel(
      id: message.id,
      text: message.text,
      isUser: message.isUser,
      timestamp: message.timestamp,
      agentId: message.agentId,
    );
  }
}