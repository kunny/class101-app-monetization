import 'package:flutter/material.dart';
import 'package:sticky_notes/data/note.dart';
import 'package:sticky_notes/page/note_edit_page.dart';
import 'package:sticky_notes/page/note_page_args.dart';
import 'package:sticky_notes/providers.dart';

class NoteViewPage extends StatefulWidget {
  static const routeName = '/view';

  @override
  State createState() => _NoteViewPageState();
}

class _NoteViewPageState extends State<NoteViewPage> {
  @override
  Widget build(BuildContext context) {
    NotePageArgs args = ModalRoute.of(context).settings.arguments;
    Note note = args.note;

    return Scaffold(
      appBar: AppBar(
        title: Text(note.title.isEmpty ? '(제목 없음)' : note.title),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            tooltip: '편집',
            onPressed: () {
              _edit(args);
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            tooltip: '삭제',
            onPressed: () {
              _confirmDelete(args);
            },
          ),
        ],
      ),
      body: SizedBox.expand(
        child: Container(
          color: note.color,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
            child: Text(note.body),
          ),
        ),
      ),
    );
  }

  void _edit(NotePageArgs args) {
    Navigator.pushNamed(
      context,
      NoteEditPage.routeName,
      arguments: args,
    );
  }

  void _confirmDelete(NotePageArgs args) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('노트 삭제'),
          content: Text('노트를 삭제할까요?'),
          actions: [
            FlatButton(
              child: Text('아니오'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text('예'),
              onPressed: () {
                noteManager().deleteNote(args.index);
                Navigator.popUntil(context, (route) => route.isFirst);
              },
            ),
          ],
        );
      },
    );
  }
}
