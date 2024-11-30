import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class CustomShortcuts {
  static final LogicalKeySet processSaleShortcut = LogicalKeySet(
    LogicalKeyboardKey.control,
    LogicalKeyboardKey.keyS,
  );

  static final LogicalKeySet printReceiptShortcut = LogicalKeySet(
    LogicalKeyboardKey.control,
    LogicalKeyboardKey.keyP,
  );

  // Additional shortcuts can be defined here
}
