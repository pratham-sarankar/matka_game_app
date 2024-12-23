import 'package:flutter/material.dart';

class TimePickerFormField extends FormField<TimeOfDay> {
  final String title;

  TimePickerFormField({
    required this.title,
    super.key,
    super.initialValue,
    super.onSaved,
    super.validator,
  }) : super(
          builder: (FormFieldState<TimeOfDay> state) {
            return GestureDetector(
              onTap: () async {
                TimeOfDay? result = await showTimePicker(
                  context: state.context,
                  initialTime: state.value ?? TimeOfDay.now(),
                );
                if (result != null) {
                  state.didChange(result);
                }
              },
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: title,
                  errorText: state.errorText,
                ),
                child: Text(state.value?.format(state.context) ?? "00:00",
                    style: const TextStyle(fontSize: 16)),
              ),
            );
          },
        );
}
