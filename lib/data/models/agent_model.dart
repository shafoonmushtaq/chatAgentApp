import 'package:flutter/material.dart';
import '../../domain/entities/agent.dart';

class AgentModel extends Agent {
  AgentModel({
    required super.id,
    required super.name,
    required super.description,
    required super.personality,
    required super.color,
  });

  factory AgentModel.fromJson(Map<String, dynamic> json) {
    return AgentModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      personality: json['personality'],
      color: Color(json['color']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'personality': personality,
      'color': color.value,
    };
  }

  factory AgentModel.fromEntity(Agent agent) {
    return AgentModel(
      id: agent.id,
      name: agent.name,
      description: agent.description,
      personality: agent.personality,
      color: agent.color,
    );
  }
}