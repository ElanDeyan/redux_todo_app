import 'dart:developer';

import 'package:redux/redux.dart';
import 'package:redux_todo_app/actions/actions.dart';
import 'package:redux_todo_app/store/store.dart';

/// Logger function to logs the previous [AppStore] state,
/// the fired [TodoActions], and the resulted [AppStore] state.
void stateTransitionLogger(
  AppStore store,
  TodoActions action,
  NextDispatcher nextDispatcher,
) {
  log('Previous state: $store');
  log('Fired action: $action', name: 'StateTransitionLogger');
  nextDispatcher(action);
  log('Actual state: $store');
}
