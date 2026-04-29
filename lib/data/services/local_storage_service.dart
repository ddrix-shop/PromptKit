import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_settings.dart';
import '../models/generated_component.dart';

class LocalStorageService {
  LocalStorageService({SharedPreferencesAsync? preferences})
      : _preferences = preferences ?? SharedPreferencesAsync();

  static const _savedComponentsKey = 'craftui.saved_components';
  static const _hasSeenOnboardingKey = 'craftui.has_seen_onboarding';
  static const _themeModeKey = 'craftui.theme_mode';
  static const _defaultPresetKey = 'craftui.default_preset';
  static const _defaultOutputModeKey = 'craftui.default_output_mode';

  final SharedPreferencesAsync _preferences;

  Future<bool> hasSeenOnboarding() async {
    return await _preferences.getBool(_hasSeenOnboardingKey) ?? false;
  }

  Future<void> setHasSeenOnboarding(bool value) {
    return _preferences.setBool(_hasSeenOnboardingKey, value);
  }

  Future<AppSettings> loadSettings() async {
    final themeMode = await _preferences.getString(_themeModeKey);
    final defaultPreset = await _preferences.getString(_defaultPresetKey);
    final defaultOutputMode = await _preferences.getString(_defaultOutputModeKey);

    return AppSettings(
      themeMode: themeMode == null ? ThemeMode.system : themeModeFromString(themeMode),
      defaultStylePreset: defaultPreset ?? 'Dark Futuristic',
      defaultOutputMode: defaultOutputMode == null
          ? OutputMode.separate
          : outputModeFromString(defaultOutputMode),
    );
  }

  Future<void> saveSettings(AppSettings settings) async {
    await _preferences.setString(_themeModeKey, settings.themeMode.name);
    await _preferences.setString(_defaultPresetKey, settings.defaultStylePreset);
    await _preferences.setString(_defaultOutputModeKey, settings.defaultOutputMode.name);
  }

  Future<List<GeneratedComponent>> getSavedComponents() async {
    final raw = await _preferences.getString(_savedComponentsKey);
    if (raw == null || raw.isEmpty) {
      return <GeneratedComponent>[];
    }

    final decoded = jsonDecode(raw) as List<dynamic>;
    final components = decoded
        .whereType<Map<String, dynamic>>()
        .map(GeneratedComponent.fromJson)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return components;
  }

  Future<void> saveComponent(GeneratedComponent component) async {
    final saved = await getSavedComponents();
    final updated = component.copyWith(isSaved: true);
    final existingIndex = saved.indexWhere((item) => item.id == component.id);

    if (existingIndex >= 0) {
      saved[existingIndex] = updated;
    } else {
      saved.insert(0, updated);
    }

    await _persistComponents(saved);
  }

  Future<void> deleteComponent(String id) async {
    final saved = await getSavedComponents();
    saved.removeWhere((component) => component.id == id);
    await _persistComponents(saved);
  }

  Future<void> clearSavedComponents() async {
    await _preferences.remove(_savedComponentsKey);
  }

  Future<void> _persistComponents(List<GeneratedComponent> components) async {
    final encoded = jsonEncode(components.map((item) => item.toJson()).toList());
    await _preferences.setString(_savedComponentsKey, encoded);
  }
}
