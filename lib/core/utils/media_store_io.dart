import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'ids.dart';

Future<String> newMediaPath(String ext) async {
  final dir = await getApplicationDocumentsDirectory();
  final media = Directory('${dir.path}/media');
  if (!await media.exists()) await media.create(recursive: true);
  return '${media.path}/${newId()}$ext';
}

/// Copies an external (picker) file into the app's media directory and returns
/// the persistent path.
Future<String> persistExternalFile(String src, String ext) async {
  final dest = await newMediaPath(ext);
  await File(src).copy(dest);
  return dest;
}

/// Deletes a persisted media file (best-effort — ignores missing files).
Future<void> deleteMediaFile(String path) async {
  try {
    final file = File(path);
    if (await file.exists()) await file.delete();
  } catch (_) {/* ignore */}
}
