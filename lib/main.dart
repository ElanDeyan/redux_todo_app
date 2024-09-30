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
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: const TextScaler.linear(1.5),
      ),
      child: MaterialApp(
        title: 'Redux Todo App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff043b3a)),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xff043b3a),
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
          brightness: Brightness.dark,
        ),
        themeMode: ThemeMode.dark,
        home: const AppStoreProvider(
          child: HomePage(),
        ),
      ),
    );
  }
}
