import 'package:flutter/material.dart';
import 'package:repet/util/date_format.dart';

class AddLecture extends StatefulWidget {
  final String folderID;
  final void Function(
    String name,
    int difficulty,
    String folder,
    int stage,
    DateTime start,
  ) addLectureHandler;

  const AddLecture(
      {required this.folderID, required this.addLectureHandler, super.key});

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

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      widget.addLectureHandler(_enteredName, _selectedDifficulty,
          widget.folderID, _selectedStage, _selectedDate);
    }
  }

  void _showDatePicker() async {
    final dateNow = DateTime.now();
    _selectedDate = await showDatePicker(
          context: context,
          initialDate: dateNow,
          firstDate: dateNow.copyWith(day: dateNow.day - 30),
          lastDate: dateNow.copyWith(month: dateNow.month + 3),
        ) ??
        _selectedDate;
    setState(() {
      _hasChosenDate = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Add lecture',
                  style: TextStyle(fontSize: 24),
                ),
                TextFormField(
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
                Row(
                  children: [
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
                    const Spacer(),
                    TextButton(
                      onPressed: _showDatePicker,
                      child: Row(
                        children: [
                          Text(
                            _hasChosenDate
                                ? MultipleDateFormat.simpleYearFormatDate(
                                    _selectedDate)
                                : 'Select start date',
                          ),
                          const SizedBox(width: 6),
                          const Icon(Icons.calendar_month),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                const Text(
                  'Have already progressed? Pick up where you left off',
                  style: TextStyle(fontSize: 16),
                ),
                Slider.adaptive(
                  value: _selectedStage.toDouble(),
                  min: 1,
                  divisions: 4,
                  max: 5,
                  label: '$_selectedStage',
                  onChanged: (value) {
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
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                      ),
                      child: const Text('Add'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
