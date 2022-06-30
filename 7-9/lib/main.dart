import 'package:flutter/material.dart';
import 'package:sticky_notes/page/note_edit_page.dart';
import 'package:sticky_notes/page/note_list_page.dart';
import 'package:sticky_notes/page/note_view_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Sticky Notes',
        theme: ThemeData(
          primarySwatch: Colors.teal,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: NoteListPage.routeName,
        routes: {
          NoteListPage.routeName: (context) => NoteListPage(),
          NoteEditPage.routeName: (context) {
            final args = ModalRoute.of(context)!.settings.arguments;
            final id = args != null ? args as int : null;
            return NoteEditPage(id);
          },
          NoteViewPage.routeName: (context) {
            final id = ModalRoute.of(context)!.settings.arguments as int;
            return NoteViewPage(id);
          },
        });
  }
}
