import 'package:flutter/material.dart';
import 'package:repet/constants/colors.dart';

class ProgressItem extends StatelessWidget {
  final int index;
  final int status;
  final String date;
  const ProgressItem({
    required this.index,
    required this.status,
    required this.date,
    super.key,
  });

  IconData getIcon() {
    switch (status) {
      case -1:
        return Icons.question_mark;
      case 0:
        return Icons.close;
      case 1:
        return Icons.timer_outlined;
      case 2:
        return Icons.check;
      default:
        return Icons.home;
    }
  }

  Color getColor() {
    switch (status) {
      case -1:
        return RepetColors.status_no_data;
      case 0:
        return RepetColors.status_skipped;
      case 1:
        return RepetColors.status_delayed;
      case 2:
        return RepetColors.status_check;
      default:
        return Colors.black;
    }
  }

  String getDay() {
    switch (index) {
      case 0:
        return '1 Day';
      case 1:
        return '3 Day';
      case 2:
        return '1 Week';
      case 3:
        return '2 Week';
      case 4:
        return '1 Month';
      default:
        return 'Default value';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: getColor(),
              ),
              child: Icon(getIcon()),
            ),
            const Spacer(),
            Text(
              getDay(),
              style: const TextStyle(fontSize: 16),
            ),
            const Spacer(),
            Text(
              date,
              style: TextStyle(fontSize: 14, color: RepetColors.status_no_data),
            ),
          ],
        ),
      ),
    );
  }
}
