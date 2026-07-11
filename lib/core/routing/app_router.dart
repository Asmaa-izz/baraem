import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/parent/presentation/item_edit_screen.dart';
import '../../features/parent/presentation/parent_dashboard_screen.dart';
import '../../features/parent/presentation/parent_gate_screen.dart';
import '../../features/parent/presentation/praise_manager_screen.dart';
import '../../features/profiles/presentation/profile_select_screen.dart';
import '../../features/rewards/presentation/reward_screen.dart';
import '../../features/session/presentation/session_screen.dart';

/// App routes. The parent area is guarded by the PIN gate: any `/parent*`
/// location redirects to `/parent-gate` until unlocked this session.
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final loc = state.matchedLocation;
      final guarded = loc.startsWith('/parent') && loc != '/parent-gate';
      if (guarded && !ref.read(parentUnlockedProvider)) {
        return '/parent-gate';
      }
      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (_, _) => const ProfileSelectScreen()),
      GoRoute(path: '/home', builder: (_, _) => const HomeScreen()),
      GoRoute(path: '/session', builder: (_, _) => const SessionScreen()),
      GoRoute(
        path: '/reward',
        builder: (_, state) =>
            RewardScreen(masteredThisSession: (state.extra as int?) ?? 0),
      ),
      GoRoute(path: '/parent-gate', builder: (_, _) => const ParentGateScreen()),
      GoRoute(path: '/parent', builder: (_, _) => const ParentDashboardScreen()),
      GoRoute(
        path: '/parent/praises',
        builder: (_, _) => const PraiseManagerScreen(),
      ),
      GoRoute(
        path: '/parent/item/new',
        builder: (_, _) => const ItemEditScreen(),
      ),
    ],
  );
});
