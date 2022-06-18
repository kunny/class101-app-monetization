import 'package:flutter/material.dart';

class Note {
  static const colorDefault = Colors.white;

  static const colorRed = Color(0xFFFFCDD2);

  static const colorOrange = Color(0xFFFFE0B2);

  static const colorYellow = Color(0xFFFFF9C4);

  static const colorLime = Color(0xFFF0F4C3);

  static const colorBlue = Color(0xFFBBDEFB);

  static const tableName = 'notes';

  static const columnId = 'id';

  static const columnTitle = 'title';

  static const columnBody = 'body';

  static const columnColor = 'color';

  final int? id;

  final String title;

  final String body;

  final Color color;

  Note(
      this.body, {
        this.id,
        this.title = '',
        this.color = colorDefault,
      });

  Note.fromRow(Map<String, dynamic> row)
      : this(
    row[columnBody],
    id: row[columnId],
    title: row[columnTitle],
    color: Color(row[columnColor]),
  );

  Map<String, dynamic> toRow() {
    return {
      columnTitle: this.title,
      columnBody: this.body,
      columnColor: this.color.value,
    };
  }
}
