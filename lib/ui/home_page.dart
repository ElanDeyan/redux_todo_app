import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux_todo_app/actions/todo_actions.dart';
import 'package:redux_todo_app/store/app_state.dart';
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
        leading: const Icon(Icons.checklist_outlined),
        title: const Text('Redux to-do app'),
      ),
      body: ColoredBox(
        color: Theme.of(context).colorScheme.inverseSurface,
        child: StoreBuilder<AppState>(
          onInit: (store) => store.dispatch(const FetchAllTodosAction()),
          builder: (context, store) => const TodosListView(),
        ),
      ),
      floatingActionButton: const AddTodoFloatingActionButton(),
    );
  }
}
