import 'package:flutter/material.dart';
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
  var _selectedStartDate = DateTime.now();
  var _selectedDueDate = DateTime.now().add(const Duration(days: 30));

  // This boolean is used to show dynamic text guiding the user to choose a date
  var _hasChosenStartDate = false;
  var _hasChosenDueDate = false;

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
            widget.folderID, _selectedStage, _selectedStartDate);
      } else {
        widget.renameLectureHandler!(_enteredName, _selectedDifficulty);
      }
    }
  }

  void _showDatePicker({required String mode}) async {
    final date = mode == 'start' ? _selectedStartDate : _selectedDueDate;
    final dateNow = DateTime.now();
    showDatePicker(
      context: context,
      initialDate: date,
      firstDate: mode == 'start'
          ? dateNow.subtract(const Duration(days: 1095))
          : _selectedStartDate.add(
              const Duration(days: 14),
            ),
      lastDate: mode == 'start'
          ? dateNow.add(const Duration(days: 1095))
          : _selectedStartDate.add(const Duration(days: 30)),
    ).then((pickedDate) {
      if (pickedDate != null) {
        if (mode == 'due') {
          _selectedDueDate = pickedDate;
          return;
        }
        _selectedStartDate = pickedDate;
        _selectedDueDate = _selectedStartDate.add(const Duration(days: 30));
        setState(() {
          _hasChosenDueDate = true;
          if (mode == 'start') {
            _hasChosenStartDate = true;
          }
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
                    isEditMode ? 'Edit Lecture' : 'Add lecture',
                    style: const TextStyle(fontSize: 24),
                  ),
                  TextFormField(
                    autofocus: true,
                    initialValue: _enteredName,
                    maxLength: 25,
                    decoration: const InputDecoration(
                      label: Text('Lecture Name'),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().length < 2) {
                        return 'Name must be longer than 2 characters';
                      }
                      return null;
                    },
                    onSaved: (newValue) => _enteredName = newValue!,
                  ),
                  const SizedBox(height: 12),
                  DropdownButton(
                    icon: const Icon(Icons.arrow_drop_down),
                    value: _selectedDifficulty,
                    items: const [
                      DropdownMenuItem(
                        value: 0,
                        child: Text(
                          'Easy',
                          style: TextStyle(
                            color: Color.fromARGB(255, 73, 159, 104),
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 1,
                        child: Text(
                          'Medium',
                          style: TextStyle(
                            color: Color.fromARGB(255, 255, 175, 33),
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 2,
                        child: Text(
                          'Hard',
                          style: TextStyle(
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
                  Row(
                    children: [
                      TextButton(
                        onPressed: isEditMode
                            ? null
                            : () => _showDatePicker(mode: 'start'),
                        child: Row(
                          children: [
                            Text(
                              _hasChosenStartDate
                                  ? MultipleDateFormat.simpleYearFormatDate(
                                      _selectedStartDate)
                                  : 'Select start date',
                            ),
                            const SizedBox(width: 6),
                            const Icon(Icons.calendar_month),
                          ],
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: isEditMode
                            ? null
                            : () => _showDatePicker(mode: 'due'),
                        child: Row(
                          children: [
                            Text(
                              _hasChosenDueDate
                                  ? MultipleDateFormat.simpleYearFormatDate(
                                      _selectedDueDate)
                                  : 'Select due date',
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
                    'Have already progressed? Pick up where you left off',
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
                        child: const Text('Cancel'),
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
                          isEditMode ? 'Edit' : 'Add',
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
