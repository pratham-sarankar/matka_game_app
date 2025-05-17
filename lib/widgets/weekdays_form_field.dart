import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class WeekdaysFormField extends FormBuilderField<String> {
  WeekdaysFormField({
    required super.name,
    super.key,
    super.initialValue,
    super.onSaved,
    super.validator,
    super.enabled,
    super.onChanged,
    super.valueTransformer,
  }) : super(
          builder: (FormFieldState<String> field) {
            return InputDecorator(
              decoration: InputDecoration(
                labelText: "Open Days",
                errorText: field.errorText,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: const Icon(Icons.calendar_today),
              ),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (var i = 0; i < 7; i++)
                    ChoiceChip(
                      label: Text(
                        [
                          "Mon",
                          "Tue",
                          "Wed",
                          "Thu",
                          "Fri",
                          "Sat",
                          "Sun",
                        ][i],
                      ),
                      selected: field.value?[i] == "1",
                      onSelected: enabled
                          ? (selected) {
                              final newValue =
                                  field.value?.split("") ?? List.filled(7, "0");
                              newValue[i] = selected ? "1" : "0";
                              field.didChange(newValue.join());
                            }
                          : null,
                    ),
                ],
              ),
            );
          },
        );
}
