import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:record/record.dart';

import '../../../app/providers.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/baraem_tokens.dart';
import '../../../core/theme/context_ext.dart';
import '../../../core/utils/media_store.dart';
import '../../../core/utils/platform_image_stub.dart'
    if (dart.library.io) '../../../core/utils/platform_image_io.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../data/models/domain.dart';

/// S8 — add a parent-authored item (image + optional recorded audio + label +
/// category). Native only for media; on web a note explains the limitation.
class ItemEditScreen extends ConsumerStatefulWidget {
  const ItemEditScreen({super.key});

  @override
  ConsumerState<ItemEditScreen> createState() => _ItemEditScreenState();
}

class _ItemEditScreenState extends ConsumerState<ItemEditScreen> {
  final _label = TextEditingController();
  final _recorder = AudioRecorder();
  String? _categoryId;
  String? _imagePath;
  String? _audioPath;
  bool _recording = false;
  bool _saving = false;

  @override
  void dispose() {
    _label.dispose();
    _recorder.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: source, maxWidth: 1024);
    if (file == null) return;
    final path = await persistExternalFile(file.path, '.jpg');
    setState(() => _imagePath = path);
  }

  Future<void> _toggleRecording() async {
    if (_recording) {
      final path = await _recorder.stop();
      setState(() {
        _recording = false;
        _audioPath = path;
      });
    } else {
      if (!await _recorder.hasPermission()) return;
      final path = await newMediaPath('.m4a');
      await _recorder.start(const RecordConfig(), path: path);
      setState(() => _recording = true);
    }
  }

  bool get _canSave =>
      !_saving &&
      _label.text.trim().isNotEmpty &&
      _categoryId != null &&
      _imagePath != null;

  Future<void> _save() async {
    setState(() => _saving = true);
    final content = ref.read(contentRepositoryProvider);
    final item = await content.createUserItem(
      categoryId: _categoryId!,
      label: _label.text.trim(),
    );
    await content.createUserExemplar(
      itemId: item.id,
      imagePath: _imagePath!,
      audioPath: _audioPath,
    );
    if (mounted) context.go('/parent');
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.ground,
      appBar: AppBar(
        backgroundColor: colors.ground,
        title: Text(l.addItem, style: context.texts.titleLarge),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => context.go('/parent'),
        ),
      ),
      body: FutureBuilder<List<Category>>(
        future: ref.read(contentRepositoryProvider).getCategories(),
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final categories = snap.data!;
          _categoryId ??= categories.isEmpty ? null : categories.first.id;

          return ListView(
            padding: const EdgeInsets.all(BaraemSpace.lg),
            children: [
              if (kIsWeb)
                AppCard(
                  borderColor: colors.retry,
                  child: Text(
                    'رفع صورة/صوت متاح على تطبيق الموبايل حالياً.',
                    style: context.texts.bodyMedium,
                  ),
                ),
              const SizedBox(height: BaraemSpace.md),
              _imagePreview(),
              const SizedBox(height: BaraemSpace.md),
              if (!kIsWeb)
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        label: l.pickImage,
                        variant: AppButtonVariant.secondary,
                        leadingIcon: Icons.photo_library_outlined,
                        onPressed: () => _pickImage(ImageSource.gallery),
                      ),
                    ),
                    const SizedBox(width: BaraemSpace.sm),
                    Expanded(
                      child: AppButton(
                        label: l.takePhoto,
                        variant: AppButtonVariant.secondary,
                        leadingIcon: Icons.photo_camera_outlined,
                        onPressed: () => _pickImage(ImageSource.camera),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: BaraemSpace.lg),
              TextField(
                controller: _label,
                decoration: InputDecoration(labelText: l.itemLabel),
                style: context.texts.bodyLarge,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: BaraemSpace.md),
              DropdownButtonFormField<String>(
                initialValue: _categoryId,
                decoration: InputDecoration(labelText: l.itemCategory),
                items: [
                  for (final c in categories)
                    DropdownMenuItem(value: c.id, child: Text(c.name)),
                ],
                onChanged: (v) => setState(() => _categoryId = v),
              ),
              const SizedBox(height: BaraemSpace.md),
              if (!kIsWeb)
                AppButton(
                  label: _recording ? l.stopRecording : l.recordAudio,
                  variant: AppButtonVariant.secondary,
                  leadingIcon: _recording ? Icons.stop : Icons.mic_none_outlined,
                  onPressed: _toggleRecording,
                ),
              if (_audioPath != null)
                Padding(
                  padding: const EdgeInsets.only(top: BaraemSpace.sm),
                  child: Text('🎧 ${l.playAudio}',
                      style: context.texts.bodyMedium),
                ),
              const SizedBox(height: BaraemSpace.xl),
              AppButton.primary(
                label: l.save,
                onPressed: _canSave ? _save : null,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _imagePreview() {
    final path = _imagePath;
    final provider = path == null ? null : makeFileImage(path);
    return Center(
      child: Container(
        width: 160,
        height: 160,
        decoration: BoxDecoration(
          color: context.colors.card,
          borderRadius: BorderRadius.circular(BaraemRadii.lg),
          border: Border.all(color: context.colors.lineStrong),
          image: provider == null
              ? null
              : DecorationImage(image: provider, fit: BoxFit.cover),
        ),
        child: provider != null
            ? null
            : Icon(Icons.image_outlined,
                size: 48, color: context.colors.ink2),
      ),
    );
  }
}
