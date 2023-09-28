import 'package:flutter/material.dart';

class ActiveFolder extends StatelessWidget {
  final int rank;
  final String name;
  const ActiveFolder({
    required this.rank,
    required this.name,
    super.key,
  });

  Color get rankColor {
    switch (rank) {
      case 1:
        return Colors.yellow;
      case 2:
        return Colors.grey;
      case 3:
        return Colors.brown;
      // Note: Will never execute
      default:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(
        '#$rank',
        style: TextStyle(color: rankColor, fontSize: 14),
      ),
      title: Text(name),
    );
  }
}
