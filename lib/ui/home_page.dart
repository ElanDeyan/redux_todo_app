import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux_todo_app/app_state.dart';
import 'package:redux_todo_app/models/models.dart';
import 'package:redux_todo_app/ui/add_todo_floating_action_button.dart';
import 'package:redux_todo_app/ui/todo_tile/todo_tile.dart';

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
      body: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Center(
              child: Text(
                'What to do now?',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 10,
            ),
          ),
          StoreConnector<AppState, List<Todo>>(
            converter: (store) => store.state.todos,
            builder: (context, todos) => SliverList.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(8),
                child: TodoTile(todo: todos[index]),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: const AddTodoFloatingActionButton(),
    );
  }
}
