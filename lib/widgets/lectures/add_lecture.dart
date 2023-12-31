import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:repet/util/date_format.dart';

import '../../models/lecture.dart';

class AddLecture extends StatefulWidget {
  final String folderID;
  final void Function(
    String name,
    int difficulty,
    String folder,
    int stage,
    DateTime start,
  )? addLectureHandler;

  final void Function(String name, int difficulty)? renameLectureHandler;
  final Lecture? editedLecture;

  const AddLecture({
    required this.folderID,
    this.addLectureHandler,
    this.renameLectureHandler,
    this.editedLecture,
    super.key,
  });

  @override
  State<AddLecture> createState() => _AddLectureState();
}

class _AddLectureState extends State<AddLecture> {
  final _formKey = GlobalKey<FormState>();
  var _enteredName = '';
  var _selectedDifficulty = 0;
  var _selectedStage = 1;
  var _selectedDate = DateTime.now();

  // This boolean is used to show dynamic text guiding the user to choose a date
  var _hasChosenDate = false;

  @override
  void initState() {
    _enteredName =
        widget.editedLecture != null ? widget.editedLecture!.name : '';
    _selectedDifficulty =
        widget.editedLecture != null ? widget.editedLecture!.difficulty : 0;
    super.initState();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (widget.addLectureHandler != null) {
        widget.addLectureHandler!(_enteredName, _selectedDifficulty,
            widget.folderID, _selectedStage, _selectedDate);
      } else {
        widget.renameLectureHandler!(_enteredName, _selectedDifficulty);
      }
    }
  }

  void _showDatePicker() async {
    final dateNow = DateTime.now();
    showDatePicker(
      context: context,
      initialDate: dateNow,
      firstDate: dateNow.subtract(const Duration(days: 1095)),
      lastDate: dateNow.add(const Duration(days: 1095)),
    ).then((date) {
      if (date != null) {
        _selectedDate = date;
        setState(() {
          _hasChosenDate = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var isEditMode = widget.renameLectureHandler != null;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          top: 20,
          left: 20,
          right: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isEditMode
                        ? 'lectures_edit_dialog_title'.i18n()
                        : 'lectures_add_dialog_title'.i18n(),
                    style: const TextStyle(fontSize: 24),
                  ),
                  TextFormField(
                    autofocus: true,
                    initialValue: _enteredName,
                    maxLength: 25,
                    decoration: InputDecoration(
                      label: Text('lectures_add_dialog_name_hint'.i18n()),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().length < 2) {
                        return 'lectures_add_dialog_name_validation_hint'
                            .i18n();
                      }
                      return null;
                    },
                    onSaved: (newValue) => _enteredName = newValue!,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      DropdownButton(
                        icon: const Icon(Icons.arrow_drop_down),
                        value: _selectedDifficulty,
                        items: [
                          DropdownMenuItem(
                            value: 0,
                            child: Text(
                              'lectures_add_dialog_difficulty_easy'.i18n(),
                              style: const TextStyle(
                                color: Color.fromARGB(255, 73, 159, 104),
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                          DropdownMenuItem(
                            value: 1,
                            child: Text(
                              'lectures_add_dialog_difficulty_medium'.i18n(),
                              style: const TextStyle(
                                color: Color.fromARGB(255, 255, 175, 33),
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                          DropdownMenuItem(
                            value: 2,
                            child: Text(
                              'lectures_add_dialog_difficulty_hard'.i18n(),
                              style: const TextStyle(
                                color: Color.fromARGB(255, 221, 81, 71),
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedDifficulty = value ?? _selectedDifficulty;
                          });
                        },
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: isEditMode ? null : _showDatePicker,
                        child: Row(
                          children: [
                            Text(
                              _hasChosenDate
                                  ? MultipleDateFormat.simpleYearFormatDate(
                                      _selectedDate)
                                  : 'lectures_add_dialog_select_date'.i18n(),
                            ),
                            const SizedBox(width: 6),
                            const Icon(Icons.calendar_month),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'lectures_add_dialog_did_progress'.i18n(),
                    style: TextStyle(
                      fontSize: 16,
                      color: isEditMode ? Colors.grey : null,
                    ),
                  ),
                  Slider.adaptive(
                    value: _selectedStage.toDouble(),
                    min: 1,
                    divisions: 4,
                    max: 5,
                    label: '$_selectedStage',
                    onChanged: isEditMode
                        ? null
                        : (value) {
                            setState(() {
                              _selectedStage = value.toInt();
                            });
                          },
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('lectures_add_dialog_cancel'.i18n()),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          _submit();
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          foregroundColor:
                              Theme.of(context).colorScheme.onPrimary,
                        ),
                        child: Text(
                          isEditMode
                              ? 'lectures_edit_dialog_edit'.i18n()
                              : 'lectures_add_dialog_add'.i18n(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
