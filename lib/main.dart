import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni_connect/core/router/app_router.dart';
import 'package:uni_connect/core/theme/app_theme.dart';

void main() {
  runApp(const ProviderScope(child: UniConnectApp()));
}

class UniConnectApp extends ConsumerWidget {
  const UniConnectApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'UniConnect Pro',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: router,
    );
  }
}
