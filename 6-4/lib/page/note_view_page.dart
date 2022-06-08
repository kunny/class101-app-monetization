import 'package:flutter/material.dart';
import 'package:sticky_notes/data/note.dart';
import 'package:sticky_notes/page/note_edit_page.dart';
import 'package:sticky_notes/providers.dart';

class NoteViewPage extends StatefulWidget {
  static const routeName = '/view';

  final int id;

  NoteViewPage(this.id);

  @override
  State createState() => _NoteViewPageState();
}

class _NoteViewPageState extends State<NoteViewPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Note>(
      future: noteManager().getNote(widget.id),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snap.hasError) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Text('오류가 발생했습니다'),
            ),
          );
        }

        final note = snap.requireData;
        return Scaffold(
          appBar: AppBar(
            title: Text(note.title.isEmpty ? '(제목 없음)' : note.title),
            actions: [
              IconButton(
                icon: Icon(Icons.edit),
                tooltip: '편집',
                onPressed: () {
                  _edit(widget.id);
                },
              ),
              IconButton(
                icon: Icon(Icons.delete),
                tooltip: '삭제',
                onPressed: () {
                  _confirmDelete(widget.id);
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
      },
    );
  }

  void _edit(int id) {
    Navigator.pushNamed(
      context,
      NoteEditPage.routeName,
      arguments: id,
    ).then((value) {
      setState(() {});
    });
  }

  void _confirmDelete(int id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('노트 삭제'),
          content: Text('노트를 삭제할까요?'),
          actions: [
            TextButton(
              child: Text('아니오'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('예'),
              onPressed: () {
                noteManager().deleteNote(id);
                Navigator.popUntil(context, (route) => route.isFirst);
              },
            ),
          ],
        );
      },
    );
  }
}
