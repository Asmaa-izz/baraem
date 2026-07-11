// Persists user media (images/audio) to the app's file system on native
// platforms; unavailable on web (see the PRD note on browser file storage).
export 'media_store_stub.dart' if (dart.library.io) 'media_store_io.dart';
