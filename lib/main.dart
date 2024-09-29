import 'package:flutter/material.dart';
import 'package:redux_todo_app/db/app_database.dart';
import 'package:redux_todo_app/providers/app_store_provider.dart';
import 'package:redux_todo_app/repository/todos_repository.dart';
import 'package:redux_todo_app/service_locator.dart';
import 'package:redux_todo_app/ui/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  serviceLocator.registerLazySingleton<TodosRepository>(
    AppDatabase.new,
  );

  runApp(const ReduxTodoApp());
}

/// {@template redux_todo_app}
/// Entry point for the application
/// {@endtemplate}
final class ReduxTodoApp extends StatelessWidget {
  /// {@macro redux_todo_app}
  const ReduxTodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Redux Todo App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AppStoreProvider(
        child: HomePage(),
      ),
    );
  }
}
