import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux_todo_app/actions/actions.dart';
import 'package:redux_todo_app/app_state.dart';
import 'package:redux_todo_app/models/models.dart';

/// {@template home_page}
/// The main page of the application
/// {@endtemplate}
final class HomePage extends StatelessWidget {
  /// {@macro home_page}
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    const sample = Todo(title: 'A', description: 'Description');

    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.science_outlined),
        title: const Text('Redux todo app'),
      ),
      body: ListView(
        children: [
          const Text('Here are your tasks:'),
          StoreConnector<AppState, List<Todo>>(
            converter: (store) => store.state.todos,
            builder: (context, value) => Text(value.toString()),
          ),
          StoreConnector<AppState, VoidCallback>(
            converter: (store) => () => store
                .dispatch(ToggleTaskCompletion(todo: store.state.todos.last)),
            builder: (context, callback) => ElevatedButton(
              onPressed: callback,
              child: const Text('Toggle last task completion'),
            ),
          ),
          StoreConnector<AppState, VoidCallback>(
            converter: (store) =>
                () => store.dispatch(RemoveTask(todo: store.state.todos.last)),
            builder: (context, callback) => ElevatedButton(
              onPressed: callback,
              child: const Text('Remove last'),
            ),
          ),
        ],
      ),
      floatingActionButton: StoreBuilder<AppState>(
        builder: (context, store) => FloatingActionButton.extended(
          onPressed: () => store.dispatch(const AddTask(todo: sample)),
          label: const Text('Add task'),
          icon: const Icon(Icons.add_outlined),
        ),
      ),
    );
  }
}
