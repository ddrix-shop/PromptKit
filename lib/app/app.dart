import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/app_providers.dart';
import 'router.dart';
import 'theme.dart';

class CraftUiApp extends ConsumerStatefulWidget {
  const CraftUiApp({super.key});

  @override
  ConsumerState<CraftUiApp> createState() => _CraftUiAppState();
}

class _CraftUiAppState extends ConsumerState<CraftUiApp> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(settingsControllerProvider.notifier).load());
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsControllerProvider);

    return MaterialApp.router(
      title: 'CraftUI Mobile',
      debugShowCheckedModeBanner: false,
      themeMode: settings.themeMode,
      theme: CraftUiTheme.light,
      darkTheme: CraftUiTheme.dark,
      routerConfig: AppRouter.router,
    );
  }
}
