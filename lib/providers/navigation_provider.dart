import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../pages/option_pages/edit_sound_page.dart';
import '../pages/main_pages/home_page.dart';
import '../pages/main_pages/library_page.dart';
import '../pages/main_pages/my_account_page.dart';
import '../pages/option_pages/newpost_page.dart';
import '../pages/option_pages/selected_user_page.dart';

final navigationProvider =
    StateNotifierProvider.autoDispose<NavigationNotifier, Widget>((ref) {
  return NavigationNotifier();
});

class NavigationNotifier extends StateNotifier<Widget> {
  NavigationNotifier() : super(const HomePage());

  late int selectedIndex = 0;
  final List<Widget> pages = [
    const HomePage(),
    const LibraryPage(),
    const MyAccountPage(),
    const NewPostPage(),
    const EditSoundPage(),
    const SelectedUserPage(),
  ];

  void select(int selectIndex) {
    if (selectIndex == 0 || selectIndex == 1 || selectIndex == 2) {
      selectedIndex = selectIndex;
    }
    state = pages[selectIndex];
  }
}
