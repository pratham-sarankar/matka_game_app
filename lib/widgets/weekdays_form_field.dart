import 'package:flutter/material.dart';

class WeekdaysFormField extends FormField<String> {
  WeekdaysFormField({
    super.key,
    super.onSaved,
    super.validator,
    super.initialValue,
  }) : super(
          builder: (FormFieldState<String> state) {
            return InputDecorator(
              decoration: InputDecoration(
                labelText: "Open Days",
                errorText: state.errorText,
              ),
              child: Wrap(
                children: [
                  for (var i = 0; i < 7; i++)
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: ChoiceChip(
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
                        selected: state.value?[i] == "1",
                        onSelected: (selected) {
                          final newValue = state.value?.split("") ?? List.filled(7, "0");
                          newValue[i] = selected ? "1" : "0";
                          state.didChange(newValue.join());
                        },
                      ),
                    ),
                ],
              ),
            );
          },
        );
}
