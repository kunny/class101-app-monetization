import 'package:flutter/material.dart';
import 'package:sticky_notes/data/note.dart';
import 'package:sticky_notes/page/note_page_args.dart';
import 'package:sticky_notes/providers.dart';

class NoteEditPage extends StatefulWidget {
  static const routeName = '/edit';

  @override
  State createState() => _NoteEditPageState();
}

class _NoteEditPageState extends State<NoteEditPage> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController titleController = new TextEditingController();

  TextEditingController bodyController = new TextEditingController();

  Color color;

  bool isEdited = false;

  @override
  Widget build(BuildContext context) {
    NotePageArgs args = ModalRoute.of(context).settings.arguments;
    if (args != null && !isEdited) {
      Note  note = args.note;
      titleController.text = note.title;
      bodyController.text = note.body;
      color = note.color;
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('노트 편집'),
        actions: [
          IconButton(
            icon: Icon(Icons.color_lens),
            tooltip: '배경색 선택',
            onPressed: _displayColorSelectionDialog,
          ),
          IconButton(
            icon: Icon(Icons.save),
            tooltip: '저장',
            onPressed: _saveNote,
          ),
        ],
      ),
      body: SizedBox.expand(
        child: Container(
          color: color,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '제목 입력',
                  ),
                  maxLines: 1,
                  style: TextStyle(fontSize: 20.0),
                  onChanged: (text) {
                    isEdited = true;
                  },
                ),
                SizedBox(height: 8.0),
                TextField(
                  controller: bodyController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '노트 입력',
                  ),
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  onChanged: (text) {
                    isEdited = true;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _displayColorSelectionDialog() {
    FocusManager.instance.primaryFocus.unfocus();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('배경색 선택'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('없음'),
                onTap: () => _applyColor(Note.colorDefault),
              ),
              ListTile(
                leading: CircleAvatar(backgroundColor: Note.colorRed),
                title: Text('빨간색'),
                onTap: () => _applyColor(Note.colorRed),
              ),
              ListTile(
                leading: CircleAvatar(backgroundColor: Note.colorOrange),
                title: Text('오렌지색'),
                onTap: () => _applyColor(Note.colorOrange),
              ),
              ListTile(
                leading: CircleAvatar(backgroundColor: Note.colorYellow),
                title: Text('노란색'),
                onTap: () => _applyColor(Note.colorYellow),
              ),
              ListTile(
                leading: CircleAvatar(backgroundColor: Note.colorLime),
                title: Text('연두색'),
                onTap: () => _applyColor(Note.colorLime),
              ),
              ListTile(
                leading: CircleAvatar(backgroundColor: Note.colorBlue),
                title: Text('파란색'),
                onTap: () => _applyColor(Note.colorBlue),
              ),
            ],
          ),
        );
      },
    );
  }

  void _applyColor(Color newColor) {
    setState(() {
      Navigator.pop(context);
      color = newColor;
      isEdited = true;
    });
  }

  void _saveNote() {
    String title = titleController.text;
    String body = bodyController.text;

    if (body != null && body.isNotEmpty) {
      NotePageArgs args = ModalRoute.of(context).settings.arguments;
      if (args != null) {
        noteManager().updateNote(
          args.index,
          body,
          title: title,
          color: color,
        );
      } else {
        noteManager().addNote(Note(
          body,
          title: title,
          color: color,
        ));
      }

      Navigator.pop(context);
    } else {
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('노트를 입력하세요.'),
        behavior: SnackBarBehavior.floating,
      ));
    }
  }
}
