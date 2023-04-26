import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/sound.dart';
import '../../providers/audio_system_providers.dart';
import '../playing_pages/nowplaying_bar.dart';
import '../../providers/navigation_provider.dart';
import '../../providers/providers.dart';
import '../playing_pages/nowplaying_page.dart';

class Common extends ConsumerStatefulWidget {
  const Common({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CommonState();
}

class _CommonState extends ConsumerState<Common> {
  @override
  Widget build(BuildContext context) {
    final currentPage = ref.watch(navigationProvider);
    final currentPageNotifier = ref.watch(navigationProvider.notifier);
    final List<BottomNavigationBarItem> bottomNavigationBarItems = [
      const BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'ホーム',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.library_music),
        label: 'ライブラリ',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.account_circle),
        label: 'アカウント',
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: currentPage,
            ),
            if (ref.watch(currentSoundProvider) != Sound.emputy)
              GestureDetector(
                onTap: () {
                  ref.read(isExpandedProvider.notifier).state = true;
                  showModalBottomSheet(
                    backgroundColor: Colors.white.withOpacity(1),
                    context: context,
                    isScrollControlled: true,
                    builder: (BuildContext context) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.9,
                        child: const NowPlayingPage(),
                      );
                    },
                  ).whenComplete(() {
                    ref.read(isExpandedProvider.notifier).state = false;
                  });
                },
                child: const NowPlayingBar(),
              ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: bottomNavigationBarItems,
        onTap: (int index) {
          currentPageNotifier.select(index);
        },
        currentIndex: currentPageNotifier.selectedIndex,
      ),
    );
  }
}
