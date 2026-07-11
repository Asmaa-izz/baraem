/// Web fallback — no writable file system for user media.
Future<String> newMediaPath(String ext) async =>
    throw UnsupportedError('media storage is unavailable on web');

Future<String> persistExternalFile(String src, String ext) async => src;

Future<void> deleteMediaFile(String path) async {}
