import 'package:flutter/material.dart';

class LifecycleItem extends StatelessWidget {
  final String method;
  final String description;

  const LifecycleItem({
    super.key,
    required this.method,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Icon(Icons.check_circle, size: 16, color: Colors.green[600]),
          const SizedBox(width: 8),
          Text(
            '$method: $description',
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
