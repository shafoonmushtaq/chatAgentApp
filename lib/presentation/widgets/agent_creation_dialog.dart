import 'package:flutter/material.dart';
import '../../../domain/entities/agent.dart';

class AgentCreationDialog extends StatefulWidget {
  final Function(Agent) onAgentCreated;

  const AgentCreationDialog({super.key, required this.onAgentCreated});

  @override
  AgentCreationDialogState createState() => AgentCreationDialogState();
}

class AgentCreationDialogState extends State<AgentCreationDialog> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String description = '';
  String personality = '';
  Color color = Colors.teal;

  final List<Color> colorOptions = [
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.indigo,
    Colors.blue,
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create New Agent'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
                onSaved: (value) {
                  name = value ?? '';
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
                onSaved: (value) {
                  description = value ?? '';
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Personality',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter personality traits';
                  }
                  return null;
                },
                onSaved: (value) {
                  personality = value ?? '';
                },
              ),
              const SizedBox(height: 16),
              const Text('Choose a color:'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: colorOptions.map((colorOption) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        color = colorOption;
                      });
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: colorOption,
                        shape: BoxShape.circle,
                        border: color == colorOption
                            ? Border.all(color: Colors.black, width: 2)
                            : null,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('CANCEL'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              final agent = Agent(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                name: name,
                description: description,
                personality: personality,
                color: color,
              );
              widget.onAgentCreated(agent);
              Navigator.of(context).pop();
            }
          },
          child: const Text('CREATE'),
        ),
      ],
    );
  }
}
