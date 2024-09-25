import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_todo_app/actions/actions.dart';
import 'package:redux_todo_app/app_state.dart';
import 'package:redux_todo_app/middlewares/middlewares.dart';
import 'package:redux_todo_app/reducers/reducers.dart';

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
          TypedMiddleware<AppState, TodoActions>(stateTransitionLogger).call,
        ],
      ),
      child: child,
    );
  }
}
