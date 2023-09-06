import 'package:flutter/material.dart';

class DetailedLectureProperty extends StatelessWidget {
  final String description;
  final String value;
  final Color color;
  const DetailedLectureProperty({
    required this.description,
    required this.value,
    required this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '• $description:',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(width: 4),
        Container(
          constraints: const BoxConstraints(maxWidth: 200),
          child: Text(
            value,
            style: TextStyle(color: color, fontSize: 16),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
