import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/baraem_tokens.dart';
import '../../../core/theme/context_ext.dart';
import '../../../core/widgets/app_button.dart';
import '../../../data/models/enums.dart';

const _avatars = ['🐣', '🦊', '🐨', '🐧', '🦁', '🐬', '🌸', '⭐'];

/// Opens the "new child" bottom sheet. Used from S1 and the parent dashboard.
Future<void> showCreateProfileSheet(BuildContext context, WidgetRef ref) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: context.colors.ground,
    showDragHandle: true,
    builder: (_) => const _CreateProfileForm(),
  );
}

class _CreateProfileForm extends ConsumerStatefulWidget {
  const _CreateProfileForm();

  @override
  ConsumerState<_CreateProfileForm> createState() => _CreateProfileFormState();
}

class _CreateProfileFormState extends ConsumerState<_CreateProfileForm> {
  final _name = TextEditingController();
  String _avatar = _avatars.first;
  ProfileMode _mode = ProfileMode.normal;
  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_name.text.trim().isEmpty) return;
    setState(() => _saving = true);
    final profile = await ref.read(profileRepositoryProvider).createProfile(
          name: _name.text.trim(),
          avatar: _avatar,
          mode: _mode,
        );
    ref.read(currentProfileIdProvider.notifier).select(profile.id);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final colors = context.colors;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        BaraemSpace.lg,
        BaraemSpace.sm,
        BaraemSpace.lg,
        BaraemSpace.lg + bottomInset,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l.newProfile, style: context.texts.titleLarge),
          const SizedBox(height: BaraemSpace.lg),
          TextField(
            controller: _name,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(labelText: l.childName),
            style: context.texts.bodyLarge,
          ),
          const SizedBox(height: BaraemSpace.lg),
          Text(l.chooseAvatar, style: context.texts.bodyMedium),
          const SizedBox(height: BaraemSpace.sm),
          Wrap(
            spacing: BaraemSpace.sm,
            runSpacing: BaraemSpace.sm,
            children: [
              for (final a in _avatars)
                GestureDetector(
                  onTap: () => setState(() => _avatar = a),
                  child: Container(
                    width: 56,
                    height: 56,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: colors.card,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: a == _avatar ? colors.sage : colors.line,
                        width: a == _avatar ? 3 : 1,
                      ),
                    ),
                    child: Text(a, style: const TextStyle(fontSize: 28)),
                  ),
                ),
            ],
          ),
          const SizedBox(height: BaraemSpace.lg),
          Text(l.settingsMode, style: context.texts.bodyMedium),
          const SizedBox(height: BaraemSpace.sm),
          SegmentedButton<ProfileMode>(
            segments: [
              ButtonSegment(value: ProfileMode.normal, label: Text(l.modeNormal)),
              ButtonSegment(value: ProfileMode.support, label: Text(l.modeSupport)),
            ],
            selected: {_mode},
            onSelectionChanged: (s) => setState(() => _mode = s.first),
          ),
          const SizedBox(height: BaraemSpace.xl),
          AppButton.primary(
            label: l.save,
            onPressed: _saving ? null : _save,
          ),
        ],
      ),
    );
  }
}
