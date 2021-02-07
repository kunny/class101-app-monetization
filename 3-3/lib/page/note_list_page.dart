import 'package:flutter/material.dart';
class Foo extends StatefulWidget {


  @override
  State createState() {

  }
}

class NoteListPage extends StatefulWidget {

  @override
  State createState() => _NoteListPageState();
}

class _NoteListPageState extends State<NoteListPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sticky Notes'),
      ),
    );
  }
}