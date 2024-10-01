import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_todo_app/middlewares/database_writer.dart';
import 'package:redux_todo_app/middlewares/state_transition_logger.dart';
import 'package:redux_todo_app/reducers/todo_reducer.dart';
import 'package:redux_todo_app/store/app_state.dart';

/// {@template app_store_provider}
/// [StoreProvider] for the app.
/// {@endtemplate}
final class AppStoreProvider extends StatelessWidget {
  /// {@macro app_store_provider}
  const AppStoreProvider({
    required this.child,
    super.key,
  });

  /// The child [Widget] for the [StoreProvider].
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: Store<AppState>(
        TypedReducer(todoReducer).call,
        initialState: const AppState(),
        middleware: [
          TypedMiddleware(stateTransitionLogger).call,
          TypedMiddleware(databaseWriter).call,
          TypedMiddleware(stateTransitionLogger).call,
        ],
      ),
      child: child,
    );
  }
}
