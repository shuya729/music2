import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../main_pages/common.dart';
import 'login_page.dart';
import '../../providers/providers.dart';

class AuthenticationWrapper extends ConsumerWidget {
  const AuthenticationWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(authProvider).when(
          data: (user) {
            if (user != null) {
              // 認証済みの場合はホーム画面に遷移
              return const Common();
            } else {
              // 認証されていない場合はログイン/サインアップ画面に遷移
              return const LoginPage();
            }
          },
          error: (error, stackTrace) => const Scaffold(
            body: Center(
              child: Text('エラーが発生しました'),
            ),
          ),
          loading: () => const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
  }
}
