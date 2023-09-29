import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

import '../constants/colors.dart';
import '../models/lecture.dart';

class LectureDifficulty {
  static String getDifficultyText(Lecture lecture) {
    switch (lecture.difficulty) {
      case 0:
        return 'home_lecture_difficulty_easy'.i18n();
      case 1:
        return 'home_lecture_difficulty_medium'.i18n();
      default:
        return 'home_lecture_difficulty_hard'.i18n();
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
