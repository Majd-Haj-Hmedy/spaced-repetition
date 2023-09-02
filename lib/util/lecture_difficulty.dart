import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../models/lecture.dart';

class LectureDifficulty {
  static String getDifficultyText(Lecture lecture) {
    switch (lecture.difficulty) {
      case 0:
        return 'Easy';
      case 1:
        return 'Medium';
      default:
        return 'Hard';
    }
  }

  static Color getDifficultyColor(Lecture lecture) {
    switch (lecture.difficulty) {
      case 0:
        return RepetColors.difficultyEasy;
      case 1:
        return RepetColors.difficultyMedium;
      default:
        return RepetColors.difficultyHard;
    }
  }
}
