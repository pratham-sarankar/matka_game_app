import 'package:flutter/material.dart';

extension WidgetList on List<Widget> {
  List<Widget> withPadding(EdgeInsets insets) {
    return map((e) => Padding(
          padding: insets,
          child: e,
        )).toList();
  }
}
