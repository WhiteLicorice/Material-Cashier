import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class ResponsiveValues {
  static double buttonWidth(BuildContext context) {
    return ResponsiveValue<double>(
      context,
      defaultValue: 200.0,
      conditionalValues: [
        const Condition.smallerThan(name: TABLET, value: 150.0),
        const Condition.largerThan(name: TABLET, value: 300.0),
      ],
    ).value;
  }

  static TextStyle textStyle(BuildContext context) {
    return ResponsiveValue<TextStyle>(
      context,
      defaultValue: const TextStyle(fontSize: 18),
      conditionalValues: [
        const Condition.smallerThan(
            name: TABLET, value: TextStyle(fontSize: 16)),
        const Condition.largerThan(
            name: TABLET, value: TextStyle(fontSize: 20)),
      ],
    ).value;
  }
}
