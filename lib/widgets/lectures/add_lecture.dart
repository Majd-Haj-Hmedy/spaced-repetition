import 'package:flutter/material.dart';

class AddLecture extends StatefulWidget {
  final String folderName;
  final void Function(
    String name,
    int difficulty,
    String folder,
  ) addLectureHandler;

  const AddLecture({required this.folderName, required this.addLectureHandler, super.key});

  @override
  State<AddLecture> createState() => _AddLectureState();
}

class _AddLectureState extends State<AddLecture> {
  final _formKey = GlobalKey<FormState>();
  var _enteredName = '';
  var _selectedDifficulty = 0;
  var _selectedStage = 1;

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      widget.addLectureHandler(_enteredName, _selectedDifficulty, widget.folderName);
    }
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
              crossAxisAlignment: CrossAxisAlignment.start,
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
                            ),
                          ),
                        ),
                        DropdownMenuItem(
                          value: 1,
                          child: Text(
                            'Medium',
                            style: TextStyle(
                              color: Color.fromARGB(255, 255, 175, 33),
                            ),
                          ),
                        ),
                        DropdownMenuItem(
                          value: 2,
                          child: Text(
                            'Hard',
                            style: TextStyle(
                              color: Color.fromARGB(255, 221, 81, 71),
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
                    // FIXME Add the start date picker functionality
                    const TextButton(
                      onPressed: null,
                      child: Row(
                        children: [
                          Text('Select start date'),
                          SizedBox(width: 6),
                          Icon(Icons.calendar_month),
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
                // FIXME Add the slider functionality
                Slider.adaptive(
                  value: 1,
                  min: 1,
                  divisions: 2,
                  max: 4,
                  label: '$_selectedStage',
                  onChanged: null,
                  // onChanged: (value) => _selectedStage = value.toInt(),
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
