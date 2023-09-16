import 'package:flutter/material.dart';
import 'package:repet/constants/colors.dart';

class ProgressItem extends StatefulWidget {
  final int index;
  final int status;
  final String date;
  final String? delayedDate;
  const ProgressItem({
    required this.index,
    required this.status,
    required this.date,
    this.delayedDate,
    super.key,
  });

  @override
  State<ProgressItem> createState() => _ProgressItemState();
}

class _ProgressItemState extends State<ProgressItem> {
  IconData getIcon() {
    switch (widget.status) {
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
    switch (widget.status) {
      case -1:
        return RepetColors.statusNoData;
      case 0:
        return RepetColors.statusSkipped;
      case 1:
        return RepetColors.statusDelayed;
      case 2:
        return RepetColors.statusCheck;
      default:
        return Colors.black;
    }
  }

  String getDay() {
    switch (widget.index) {
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

  String getTooltipText() {
    switch (widget.status) {
      case -1:
        return 'No data';
      case 0:
        return 'Skipped';
      case 1:
        return widget.delayedDate!;
      case 2:
        return 'Completed in time';
      default:
        return '...';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Tooltip(
                  message: getTooltipText(),
                  preferBelow: false,
                  showDuration: const Duration(seconds: 2),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  textStyle: const TextStyle(
                    color: Colors.white,
                  ),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: getColor(),
                    ),
                    child: Icon(
                      getIcon(),
                      color: Colors.white,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  getDay(),
                  style: const TextStyle(fontSize: 16),
                ),
                const Spacer(),
                Text(
                  widget.date,
                  style:
                      TextStyle(fontSize: 14, color: RepetColors.statusNoData),
                ),
              ],
            ),
          ),
        ),
        // if (index != 4) Image.asset('assets/chain.png'),
      ],
    );
  }
}
