import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux_todo_app/store/store.dart';

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
      store: store,
      child: child,
    );
  }
}
