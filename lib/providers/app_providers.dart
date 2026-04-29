import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/app_constants.dart';
import '../data/models/app_settings.dart';
import '../data/models/generated_component.dart';
import '../data/services/ai_generation_service.dart';
import '../data/services/export_service.dart';
import '../data/services/local_storage_service.dart';

final aiGenerationServiceProvider = Provider<AiGenerationService>((ref) {
  return AiGenerationService();
});

final localStorageServiceProvider = Provider<LocalStorageService>((ref) {
  return LocalStorageService();
});

final exportServiceProvider = Provider<ExportService>((ref) {
  return ExportService();
});

final currentGeneratedComponentProvider = StateProvider<GeneratedComponent?>((ref) {
  return null;
});

final settingsControllerProvider = StateNotifierProvider<SettingsController, AppSettings>((ref) {
  return SettingsController(ref.read(localStorageServiceProvider));
});

class SettingsController extends StateNotifier<AppSettings> {
  SettingsController(this._storage) : super(const AppSettings());

  final LocalStorageService _storage;
  bool _loaded = false;

  Future<void> load() async {
    if (_loaded) return;
    _loaded = true;
    state = await _storage.loadSettings();
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    state = state.copyWith(themeMode: themeMode);
    await _storage.saveSettings(state);
  }

  Future<void> setDefaultStylePreset(String preset) async {
    state = state.copyWith(defaultStylePreset: preset);
    await _storage.saveSettings(state);
  }

  Future<void> setDefaultOutputMode(OutputMode outputMode) async {
    state = state.copyWith(defaultOutputMode: outputMode);
    await _storage.saveSettings(state);
  }
}

final savedComponentsProvider =
    StateNotifierProvider<SavedComponentsController, AsyncValue<List<GeneratedComponent>>>((ref) {
  return SavedComponentsController(
    storage: ref.read(localStorageServiceProvider),
    ref: ref,
  )..load();
});

class SavedComponentsController extends StateNotifier<AsyncValue<List<GeneratedComponent>>> {
  SavedComponentsController({required LocalStorageService storage, required Ref ref})
      : _storage = storage,
        _ref = ref,
        super(const AsyncValue.loading());

  final LocalStorageService _storage;
  final Ref _ref;

  Future<void> load() async {
    state = const AsyncValue.loading();
    try {
      final components = await _storage.getSavedComponents();
      state = AsyncValue.data(components);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<GeneratedComponent> save(GeneratedComponent component) async {
    final saved = component.copyWith(isSaved: true);
    await _storage.saveComponent(saved);
    _ref.read(currentGeneratedComponentProvider.notifier).state = saved;
    await load();
    return saved;
  }

  Future<void> delete(String id) async {
    await _storage.deleteComponent(id);
    final current = _ref.read(currentGeneratedComponentProvider);
    if (current?.id == id) {
      _ref.read(currentGeneratedComponentProvider.notifier).state = current?.copyWith(isSaved: false);
    }
    await load();
  }
}

final generatorControllerProvider = StateNotifierProvider<GeneratorController, GeneratorState>((ref) {
  final settings = ref.watch(settingsControllerProvider);
  return GeneratorController(
    ref: ref,
    aiService: ref.read(aiGenerationServiceProvider),
    initialStylePreset: settings.defaultStylePreset,
    initialOneFileHtml: settings.defaultOutputMode == OutputMode.oneFile,
  );
});

class GeneratorState {
  const GeneratorState({
    this.prompt = '',
    this.componentType = 'Hero Section',
    this.stylePreset = 'Dark Futuristic',
    this.includeResponsive = true,
    this.includeAnimations = true,
    this.useCssVariables = true,
    this.oneFileHtml = false,
    this.isGenerating = false,
    this.loadingStep = 0,
    this.generatedComponent,
    this.errorMessage,
  });

  final String prompt;
  final String componentType;
  final String stylePreset;
  final bool includeResponsive;
  final bool includeAnimations;
  final bool useCssVariables;
  final bool oneFileHtml;
  final bool isGenerating;
  final int loadingStep;
  final GeneratedComponent? generatedComponent;
  final String? errorMessage;

  GeneratorState copyWith({
    String? prompt,
    String? componentType,
    String? stylePreset,
    bool? includeResponsive,
    bool? includeAnimations,
    bool? useCssVariables,
    bool? oneFileHtml,
    bool? isGenerating,
    int? loadingStep,
    GeneratedComponent? generatedComponent,
    String? errorMessage,
    bool clearError = false,
    bool clearGeneratedComponent = false,
  }) {
    return GeneratorState(
      prompt: prompt ?? this.prompt,
      componentType: componentType ?? this.componentType,
      stylePreset: stylePreset ?? this.stylePreset,
      includeResponsive: includeResponsive ?? this.includeResponsive,
      includeAnimations: includeAnimations ?? this.includeAnimations,
      useCssVariables: useCssVariables ?? this.useCssVariables,
      oneFileHtml: oneFileHtml ?? this.oneFileHtml,
      isGenerating: isGenerating ?? this.isGenerating,
      loadingStep: loadingStep ?? this.loadingStep,
      generatedComponent:
          clearGeneratedComponent ? null : generatedComponent ?? this.generatedComponent,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

class GeneratorController extends StateNotifier<GeneratorState> {
  GeneratorController({
    required Ref ref,
    required AiGenerationService aiService,
    required String initialStylePreset,
    required bool initialOneFileHtml,
  })  : _ref = ref,
        _aiService = aiService,
        super(
          GeneratorState(
            stylePreset: initialStylePreset,
            oneFileHtml: initialOneFileHtml,
          ),
        );

  final Ref _ref;
  final AiGenerationService _aiService;

  void setPrompt(String value) {
    state = state.copyWith(prompt: value, clearError: true);
  }

  void setComponentType(String value) {
    state = state.copyWith(componentType: value, clearError: true);
  }

  void setStylePreset(String value) {
    state = state.copyWith(stylePreset: value, clearError: true);
  }

  void setIncludeResponsive(bool value) {
    state = state.copyWith(includeResponsive: value, clearError: true);
  }

  void setIncludeAnimations(bool value) {
    state = state.copyWith(includeAnimations: value, clearError: true);
  }

  void setUseCssVariables(bool value) {
    state = state.copyWith(useCssVariables: value, clearError: true);
  }

  void setOneFileHtml(bool value) {
    state = state.copyWith(oneFileHtml: value, clearError: true);
  }

  Future<GeneratedComponent?> generate() async {
    final trimmedPrompt = state.prompt.trim();
    if (trimmedPrompt.isEmpty) {
      state = state.copyWith(errorMessage: 'Describe the component you want to generate.');
      return null;
    }

    state = state.copyWith(
      isGenerating: true,
      loadingStep: 0,
      clearGeneratedComponent: true,
      clearError: true,
    );

    try {
      for (var step = 0; step < AppConstants.loadingSteps.length; step++) {
        state = state.copyWith(loadingStep: step);
        await Future<void>.delayed(const Duration(milliseconds: 560));
      }

      final component = await _aiService.generateComponent(
        prompt: trimmedPrompt,
        componentType: state.componentType,
        stylePreset: state.stylePreset,
        includeResponsive: state.includeResponsive,
        includeAnimations: state.includeAnimations,
        useCssVariables: state.useCssVariables,
        oneFileHtml: state.oneFileHtml,
      );

      _ref.read(currentGeneratedComponentProvider.notifier).state = component;
      state = state.copyWith(
        isGenerating: false,
        generatedComponent: component,
        loadingStep: AppConstants.loadingSteps.length - 1,
      );
      return component;
    } catch (error) {
      state = state.copyWith(
        isGenerating: false,
        errorMessage: 'Generation failed. Please try again.',
      );
      return null;
    }
  }
}
