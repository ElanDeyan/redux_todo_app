import 'dart:developer';

import 'package:redux/redux.dart';
import 'package:redux_todo_app/actions/actions.dart';
import 'package:redux_todo_app/store/app_state.dart';

/// Logger function to logs the previous [AppState] state,
/// the fired [TodoActions], and the resulted [AppState] state.
Future<void> stateTransitionLogger(
  Store<AppState> store,
  TodoActions action,
  NextDispatcher nextDispatcher,
) async {
  log('Previous state: ${store.state}');
  log('Fired action: $action', name: 'StateTransitionLogger');
  await nextDispatcher(action);
  log('Actual state: ${store.state}');
}
