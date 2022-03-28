import 'package:flutter/material.dart';

class InputComp {
  static InputDecoration myDecoration(String label, String hint) =>
      InputDecoration(
        border: OutlineInputBorder(),
        labelText: label,
        hintText: hint,
      );
}
