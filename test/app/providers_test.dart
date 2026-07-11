import 'package:baraem/app/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Regression: selecting a profile then navigating away (no active listener
  // during the route transition) must NOT reset the selection to null. Before
  // making these providers keepAlive, the target screen saw null and bounced
  // back to the profile-select screen ("tapping a child does nothing").

  test('CurrentProfileId survives a no-listener gap', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    container.read(currentProfileIdProvider.notifier).select('child-1');
    // Simulate the transition: yield the event loop with nothing listening.
    await Future<void>.delayed(const Duration(milliseconds: 20));

    expect(container.read(currentProfileIdProvider), 'child-1');
  });

  test('SelectedCategory survives a no-listener gap', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    container.read(selectedCategoryProvider.notifier).select('household');
    await Future<void>.delayed(const Duration(milliseconds: 20));

    expect(container.read(selectedCategoryProvider), 'household');
  });

  test('ParentUnlocked survives a no-listener gap', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    container.read(parentUnlockedProvider.notifier).unlock();
    await Future<void>.delayed(const Duration(milliseconds: 20));

    expect(container.read(parentUnlockedProvider), isTrue);
  });
}
