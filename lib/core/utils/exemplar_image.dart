import 'package:flutter/widgets.dart';

import '../../data/models/domain.dart';
import 'platform_image_stub.dart'
    if (dart.library.io) 'platform_image_io.dart';

/// Resolves the image for an exemplar, or null to fall back to an emoji tile.
/// System content uses bundled assets; user content uses on-disk files (native
/// only — returns null on web, where the emoji fallback shows instead).
ImageProvider? exemplarImage(Exemplar exemplar) {
  if (!exemplar.hasImage || exemplar.imagePath.isEmpty) return null;
  final path = exemplar.imagePath;
  if (path.startsWith('assets/')) return AssetImage(path);
  return makeFileImage(path);
}
