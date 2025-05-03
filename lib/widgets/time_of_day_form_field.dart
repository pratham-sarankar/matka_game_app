import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class TimePickerFormField extends FormBuilderField<TimeOfDay> {
  final String title;

  TimePickerFormField({
    required this.title,
    required super.name,
    super.key,
    super.initialValue,
    super.onSaved,
    super.validator,
    super.enabled,
    super.onChanged,
    super.valueTransformer,
  }) : super(
          builder: (FormFieldState<TimeOfDay> field) {
            return GestureDetector(
              onTap: enabled
                  ? () async {
                      TimeOfDay? result = await showTimePicker(
                        context: field.context,
                        initialTime: field.value ?? TimeOfDay.now(),
                      );
                      if (result != null) {
                        field.didChange(result);
                      }
                    }
                  : null,
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: title,
                  errorText: field.errorText,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.access_time),
                ),
                child: Text(
                  field.value?.format(field.context) ?? "00:00",
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            );
          },
        );
}
