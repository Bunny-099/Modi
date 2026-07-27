import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_icons.dart';
import '../../../home/presentation/pages/home_screen.dart';
import '../../../local/presentation/pages/local_screen.dart';

// Yeh provider bottom navigation ka current index manage karega
final bottomNavIndexProvider = StateProvider<int>((ref) => 0);

class MainWrapper extends ConsumerWidget {
  const MainWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Current index watch kar rahe hain
    final currentIndex = ref.watch(bottomNavIndexProvider);

    // Screens jo bottom nav bar mein dikhengi
    final screens = const [
      HomeScreen(),
      LocalScreen(),
    ];

    return Scaffold(
      // IndexedStack ensure karta hai ki tabs switch karne pe screens ka state lose na ho
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: AppColors.surface,
        buttonBackgroundColor: AppColors.primary,
        height: 75,
        index: currentIndex,
        items: const [
          CurvedNavigationBarItem(
            child: Icon(AppIcons.home, color: AppColors.textPrimary),
            label: 'Home',
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.folder_open_rounded, color: AppColors.textPrimary),
            label: 'Local',
          ),
        ],
        onTap: (index) {
          ref.read(bottomNavIndexProvider.notifier).state = index;
        },
      ),
    );
  }
}
