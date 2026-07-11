import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/baraem_tokens.dart';
import '../../../core/theme/context_ext.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/pin_pad.dart';

/// S6 — PIN gate. First run creates a PIN (entered twice); afterwards it
/// verifies. Errors are calm honey hints, never red.
class ParentGateScreen extends ConsumerStatefulWidget {
  const ParentGateScreen({super.key});

  @override
  ConsumerState<ParentGateScreen> createState() => _ParentGateScreenState();
}

enum _Stage { loading, create1, create2, enter }

class _ParentGateScreenState extends ConsumerState<ParentGateScreen> {
  static const _len = 4;
  _Stage _stage = _Stage.loading;
  String _entry = '';
  String _firstPin = '';
  String? _hint;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final hasPin = await ref.read(settingsRepositoryProvider).hasPin();
    setState(() => _stage = hasPin ? _Stage.enter : _Stage.create1);
  }

  void _onDigit(int d) {
    if (_entry.length >= _len) return;
    setState(() {
      _entry += '$d';
      _hint = null;
    });
    if (_entry.length == _len) _complete();
  }

  void _onDelete() {
    if (_entry.isEmpty) return;
    setState(() => _entry = _entry.substring(0, _entry.length - 1));
  }

  Future<void> _complete() async {
    final l = AppLocalizations.of(context);
    final settings = ref.read(settingsRepositoryProvider);

    switch (_stage) {
      case _Stage.create1:
        setState(() {
          _firstPin = _entry;
          _entry = '';
          _stage = _Stage.create2;
        });
      case _Stage.create2:
        if (_entry == _firstPin) {
          await settings.setPin(_entry);
          _unlock();
        } else {
          setState(() {
            _entry = '';
            _firstPin = '';
            _stage = _Stage.create1;
            _hint = l.pinMismatch;
          });
        }
      case _Stage.enter:
        if (await settings.verifyPin(_entry)) {
          _unlock();
        } else {
          setState(() {
            _entry = '';
            _hint = l.pinWrong;
          });
        }
      case _Stage.loading:
        break;
    }
  }

  void _unlock() {
    ref.read(parentUnlockedProvider.notifier).unlock();
    if (mounted) context.go('/parent');
  }

  String _title(AppLocalizations l) => switch (_stage) {
        _Stage.create1 => l.createPin,
        _Stage.create2 => l.confirmPin,
        _ => l.enterPin,
      };

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final colors = context.colors;

    return AppScaffold(
      child: Column(
        children: [
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: IconButton(
              onPressed: () => context.go('/'),
              icon: const Icon(Icons.arrow_forward_rounded),
              tooltip: l.back,
            ),
          ),
          const Spacer(),
          if (_stage == _Stage.loading)
            const CircularProgressIndicator()
          else
            AppCard(
              padding: const EdgeInsets.all(BaraemSpace.xl),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.lock_outline_rounded, size: 40, color: colors.ink2),
                  const SizedBox(height: BaraemSpace.md),
                  Text(_title(l), style: context.texts.titleLarge),
                  const SizedBox(height: BaraemSpace.lg),
                  PinDots(length: _len, filled: _entry.length),
                  SizedBox(
                    height: 28,
                    child: Center(
                      child: _hint == null
                          ? null
                          : Text(_hint!,
                              style: TextStyle(
                                  fontFamily: 'Tajawal',
                                  color: colors.retry,
                                  fontWeight: FontWeight.w700)),
                    ),
                  ),
                  const SizedBox(height: BaraemSpace.sm),
                  PinPad(onDigit: _onDigit, onDelete: _onDelete),
                ],
              ),
            ),
          const Spacer(),
        ],
      ),
    );
  }
}
