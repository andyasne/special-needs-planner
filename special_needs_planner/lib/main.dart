import 'package:flutter/material.dart';
import 'package:special_needs_planner/app.dart';
import 'package:special_needs_planner/data/app_repository.dart';
import 'package:special_needs_planner/data/app_state_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final repository = await AppRepository.initialize();
  final store = AppStateStore(repository: repository);
  await store.load();
  runApp(App(store: store));
}
