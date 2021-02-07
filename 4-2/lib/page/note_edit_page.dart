import 'package:flutter/material.dart';

class NoteEditPage extends StatefulWidget {
  @override
  State createState() => _NoteEditPageState();
}

class _NoteEditPageState extends State<NoteEditPage> {
  String title;

  String body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('노트 편집'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: '제목 입력',
              ),
              maxLines: 1,
              style: TextStyle(fontSize: 20.0),
              onChanged: (text) {
                title = text;
              },
            ),
            SizedBox(height: 8.0),
            TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '노트 입력',
              ),
              maxLines: null,
              keyboardType: TextInputType.multiline,
              onChanged: (text) {
                body = text;
              },
            ),
          ],
        ),
      ),
    );
  }
}
