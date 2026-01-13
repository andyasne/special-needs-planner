import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:special_needs_planner/data/app_state_store.dart';
import 'package:special_needs_planner/ui/app_shell.dart';
import 'package:special_needs_planner/ui/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key, required this.store});

  final AppStateStore store;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: store,
      child: Consumer<AppStateStore>(
        builder: (context, state, _) {
          return MaterialApp(
            title: 'Special Needs Planner',
            theme: AppTheme.build(),
            darkTheme: AppTheme.buildDark(),
            themeMode: state.themeMode,
            home: const AppShell(),
          );
        },
      ),
    );
  }
}
