import 'package:baraem/app/providers.dart';
import 'package:baraem/data/db/app_database.dart';
import 'package:baraem/data/models/domain.dart';
import 'package:baraem/main.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'app boots to the profile-select screen',
    (tester) async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(() async => db.close());

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appDatabaseProvider.overrideWithValue(db),
            appBootstrapProvider.overrideWith((ref) async {}),
            // Avoid a live Drift stream under the test harness (fake clock +
            // teardown lifecycle); the render path is what we're checking.
            profilesProvider
                .overrideWith((ref) => Stream.value(const <ChildProfile>[])),
          ],
          child: const BaraemApp(),
        ),
      );
      await tester.pump(); // resolve bootstrap → router
      await tester.pump(); // resolve profiles stream → data state

      // Booted through ProviderScope → MaterialApp.router → go_router →
      // ProfileSelectScreen: localized title + the "add child" affordance.
      expect(find.text('براعم'), findsWidgets);
      expect(find.byIcon(Icons.add_rounded), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
    timeout: const Timeout(Duration(seconds: 40)),
  );
}
