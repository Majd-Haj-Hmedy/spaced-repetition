import 'package:flutter/material.dart';

class LectureProperty extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color;

  const LectureProperty({
    required this.text,
    required this.icon,
    required this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: color,
        ),
        const SizedBox(width: 8),
        Container(
          constraints: const BoxConstraints(maxWidth: 80),
          child: Text(
            text,
            style: TextStyle(color: color),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
