import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class FilePickerFormField extends FormField<File> {
  final Function(File?) onChanged;

  FilePickerFormField({
    super.key,
    super.initialValue,
    super.validator,
    super.onSaved,
    required this.onChanged,
  }) : super(
          builder: (FormFieldState<File> field) {
            return InputDecorator(
              decoration: InputDecoration(
                labelText: "Select File",
                prefixIcon: const Icon(Icons.attach_file),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    field.didChange(null);
                    onChanged(null);
                  },
                ),
                errorText: field.errorText,
              ),
              child: ElevatedButton(
                onPressed: () async {
                  XFile? file = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  if (file != null) {
                    field.didChange(File(file.path));
                    onChanged(File(file.path));
                  }
                },
                child: Text(
                  field.value == null
                      ? "Choose File"
                      : basename(field.value!.path),
                ),
              ),
            );
          },
        );
}
