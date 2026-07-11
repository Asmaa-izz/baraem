import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/providers.dart';
import 'core/l10n/app_localizations.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/context_ext.dart';

void main() {
  // Render runtime widget errors as a calm, selectable box (so the text can be
  // copied/shared) instead of the raw red overlay.
  ErrorWidget.builder = (details) => _ErrorBox(message: details.exceptionAsString());
  runApp(const ProviderScope(child: BaraemApp()));
}

class BaraemApp extends ConsumerWidget {
  const BaraemApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boot = ref.watch(appBootstrapProvider);
    final themeMode = ref.watch(appThemeModeProvider).value ?? ThemeMode.system;
    final light = buildBaraemTheme(Brightness.light);
    final dark = buildBaraemTheme(Brightness.dark);

    Widget wrap(Widget home) => MaterialApp(
          title: 'براعم',
          debugShowCheckedModeBanner: false,
          theme: light,
          darkTheme: dark,
          themeMode: themeMode,
          locale: const Locale('ar'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: home,
        );

    return boot.when(
      loading: () => wrap(const _Splash()),
      error: (e, _) => wrap(_BootError(error: e)),
      data: (_) {
        final router = ref.watch(routerProvider);
        return MaterialApp.router(
          title: 'براعم',
          debugShowCheckedModeBanner: false,
          routerConfig: router,
          theme: light,
          darkTheme: dark,
          themeMode: themeMode,
          locale: const Locale('ar'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
        );
      },
    );
  }
}

class _Splash extends StatelessWidget {
  const _Splash();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.ground,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🌱', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 12),
            Text('براعم', style: context.texts.displaySmall),
            const SizedBox(height: 24),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

class _BootError extends StatelessWidget {
  const _BootError({required this.error});
  final Object error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.ground,
      body: SafeArea(child: _ErrorBox(message: '$error')),
    );
  }
}

/// A calm, scrollable, SELECTABLE error panel. Long-press/drag to select the
/// text and copy it (or screenshot it) to share.
class _ErrorBox extends StatelessWidget {
  const _ErrorBox({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Material(
        color: const Color(0xFFF5EDE2),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('🌱  حصل خطأ',
                  style: TextStyle(
                      fontFamily: 'Baloo Bhaijaan 2',
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF3B352E))),
              const SizedBox(height: 8),
              const Text('انسخ النص التالي وأرسله:',
                  style: TextStyle(color: Color(0xFF8A8175))),
              const SizedBox(height: 12),
              Expanded(
                child: SingleChildScrollView(
                  child: SelectableText(
                    message,
                    textDirection: TextDirection.ltr,
                    style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 13,
                        color: Color(0xFF3B352E)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
