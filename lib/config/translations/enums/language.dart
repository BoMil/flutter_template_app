import 'package:flutter/material.dart';

enum Language {
  english(Locale('en')),
  spanisn(Locale('es'));

  const Language(this.value);
  final Locale value;
}
