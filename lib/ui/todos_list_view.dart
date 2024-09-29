import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_todo_app/app_state.dart';
import 'package:redux_todo_app/helper/extensions/iterable_extension.dart';
import 'package:redux_todo_app/models/models.dart';
import 'package:redux_todo_app/ui/todo_tile/todo_tile.dart';

/// Filters for [TodosListView].
enum TodoFilters {
  /// Shows all [Todo]s
  all,

  /// Show [Todo]s only when [Todo.isCompleted] is `true`.
  completed,

  /// Show [Todo]s only when [Todo.isCompleted] is `false`.
  pending;

  /// Helper getter to display the name of the filter in UI.
  String get uiName => switch (this) {
        TodoFilters.all => 'All',
        TodoFilters.completed => 'Completed',
        TodoFilters.pending => 'Pending'
      };
}

/// {@template todos_list_view}
/// Speficically, a [SliverList] with [TodoFilters] that displays
/// [TodoTile]s accordingly.
/// {@endtemplate}
class TodosListView extends StatefulWidget {
  /// {@macro todos_list_view}
  const TodosListView({
    super.key,
  });

  @override
  State<TodosListView> createState() => _TodosListViewState();
}

class _TodosListViewState extends State<TodosListView> {
  late TodoFilters _filter;

  @override
  void initState() {
    super.initState();
    _filter = TodoFilters.all;
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        const SliverToBoxAdapter(
          child: _TodoListViewHeader(),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(
            height: 10,
          ),
        ),
        SliverToBoxAdapter(
          child: Wrap(
            alignment: WrapAlignment.spaceAround,
            runSpacing: 5,
            children: [
              for (final filter in TodoFilters.values)
                ChoiceChip(
                  label: Text(filter.uiName),
                  selected: _filter == filter,
                  onSelected: (newValue) {
                    if (newValue && filter != _filter) {
                      setState(() {
                        _filter = filter;
                      });
                    }
                  },
                ),
            ],
          ),
        ),
        StoreConnector<AppState, List<Todo>>(
          converter: _filterTodos,
          builder: (context, todos) => SliverList.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.all(8),
              child: TodoTile(todo: todos[index]),
            ),
          ),
        ),
      ],
    );
  }

  List<Todo> _filterTodos(Store<AppState> store) {
    final todos = [...store.state.todos];
    return switch (_filter) {
      TodoFilters.all => [
          ...todos.where((todo) => todo.isNotCompleted).toSortedList(
                (a, b) => a.createdAt.compareTo(b.createdAt) * -1,
              ),
          ...todos.where((todo) => todo.isCompleted).toSortedList(
                (a, b) => a.createdAt.compareTo(b.createdAt) * -1,
              ),
        ],
      TodoFilters.completed => todos.where((todo) => todo.isCompleted).toList()
        ..sort(
          (a, b) => a.createdAt.compareTo(b.createdAt) * -1,
        ),
      TodoFilters.pending => todos.where((todo) => todo.isNotCompleted).toList()
        ..sort(
          (a, b) => a.createdAt.compareTo(b.createdAt) * -1,
        ),
    };
  }
}

class _TodoListViewHeader extends StatelessWidget {
  const _TodoListViewHeader() : super(key: const Key('todo_list_view_header'));

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'What to do now?',
        style: Theme.of(context).textTheme.labelLarge,
      ),
    );
  }
}
