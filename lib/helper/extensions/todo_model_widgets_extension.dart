import 'package:flutter/material.dart';
import 'package:redux_todo_app/models/models.dart';

/// Extension to render [Widget]s from the [Todo] model.
extension TodoModelWidgetsExtension on Todo {
  List<String> get _propsNames =>
      ['Id', 'Title', 'Description', 'Is completed?', 'Created at'];

  /// Getter to render a [DataTable] for this [Todo] data.
  DataTable get asDataTable {
    return DataTable(
      columns: [
        for (final prop in _propsNames) DataColumn(label: Text(prop)),
      ],
      rows: [
        DataRow(
          cells: [for (final prop in props) DataCell(Text(prop.toString()))],
        ),
      ],
    );
  }
}
