import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_todo_app/app_state.dart';
import 'package:redux_todo_app/db/app_database.dart';
import 'package:redux_todo_app/helper/extensions/todo_model.dart';
import 'package:redux_todo_app/middlewares/middlewares.dart';
import 'package:redux_todo_app/models/todo.dart';
import 'package:redux_todo_app/reducers/reducers.dart';
import 'package:redux_todo_app/service_locator.dart';

/// {@template app_store_provider}
/// [StoreProvider] for the app.
/// {@endtemplate}
final class AppStoreProvider extends StatefulWidget {
  /// {@macro app_store_provider}
  const AppStoreProvider({
    required this.child,
    super.key,
  });

  /// The child [Widget] for the [StoreProvider].
  final Widget child;

  @override
  State<AppStoreProvider> createState() => _AppStoreProviderState();
}

class _AppStoreProviderState extends State<AppStoreProvider> {
  late final Future<List<Todo>> _initialItems;
  @override
  void initState() {
    super.initState();
    _initialItems = serviceLocator<AppDatabase>()
        .all
        .then((rows) => rows.map(TodoModel.fromTodoTable).toList());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Todo>>(
      future: _initialItems,
      builder: (context, snapshot) {
        final connectionState = snapshot.connectionState;
        final hasError = snapshot.hasError;
        final hasData = snapshot.hasData;

        final data = snapshot.data;
        return switch ((connectionState, hasError, hasData)) {
          (ConnectionState.active || ConnectionState.done, _, true)
              when data != null =>
            StoreProvider(
              store: Store<AppState>(
                TypedReducer(todoReducer).call,
                initialState: AppState(todos: data),
                middleware: [
                  TypedMiddleware(databaseWriter).call,
                  TypedMiddleware(stateTransitionLogger).call,
                ],
              ),
              child: widget.child,
            ),
          _ => const Scaffold(body: Center(child: CircularProgressIndicator())),
        };
      },
    );
  }
}
