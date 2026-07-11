import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

/// Opens the local database. `drift_flutter` handles both platforms:
/// - native: a file under the app support dir (via path_provider);
/// - web: OPFS-backed sqlite via `sqlite3.wasm` + `drift_worker.js` in `web/`.
QueryExecutor openConnection() {
  return driftDatabase(
    name: 'baraem',
    web: DriftWebOptions(
      sqlite3Wasm: Uri.parse('sqlite3.wasm'),
      driftWorker: Uri.parse('drift_worker.js'),
    ),
  );
}
