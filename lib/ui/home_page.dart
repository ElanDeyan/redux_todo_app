import 'package:flutter/material.dart';
import 'package:redux_todo_app/ui/add_todo_floating_action_button.dart';
import 'package:redux_todo_app/ui/todos_list_view.dart';

/// {@template home_page}
/// The main page of the application
/// {@endtemplate}
final class HomePage extends StatelessWidget {
  /// {@macro home_page}
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.science_outlined),
        title: const Text('Redux todo app'),
      ),
      body: ColoredBox(
        color: Theme.of(context).colorScheme.inverseSurface,
        child: const TodosListView(),
      ),
      floatingActionButton: const AddTodoFloatingActionButton(),
    );
  }
}
