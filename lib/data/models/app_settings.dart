import 'package:flutter/material.dart';

class AppSettings {
  const AppSettings({
    this.themeMode = ThemeMode.system,
    this.defaultStylePreset = 'Dark Futuristic',
    this.defaultOutputMode = OutputMode.separate,
  });

  final ThemeMode themeMode;
  final String defaultStylePreset;
  final OutputMode defaultOutputMode;

  AppSettings copyWith({
    ThemeMode? themeMode,
    String? defaultStylePreset,
    OutputMode? defaultOutputMode,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      defaultStylePreset: defaultStylePreset ?? this.defaultStylePreset,
      defaultOutputMode: defaultOutputMode ?? this.defaultOutputMode,
    );
  }
}

enum OutputMode { separate, oneFile }

extension OutputModeX on OutputMode {
  String get label {
    switch (this) {
      case OutputMode.separate:
        return 'Separate HTML/CSS';
      case OutputMode.oneFile:
        return 'One-file HTML';
    }
  }
}

ThemeMode themeModeFromString(String value) {
  return ThemeMode.values.firstWhere(
    (mode) => mode.name == value,
    orElse: () => ThemeMode.system,
  );
}

OutputMode outputModeFromString(String value) {
  return OutputMode.values.firstWhere(
    (mode) => mode.name == value,
    orElse: () => OutputMode.separate,
  );
}
