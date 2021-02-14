import 'package:flutter/material.dart';
import 'package:sticky_notes/data/note.dart';
import 'package:sticky_notes/page/note_edit_page.dart';
import 'package:sticky_notes/page/note_page_args.dart';
import 'package:sticky_notes/page/note_view_page.dart';
import 'package:sticky_notes/providers.dart';

class NoteListPage extends StatefulWidget {
  static const routeName = '/';

  @override
  State createState() => _NoteListPageState();
}

class _NoteListPageState extends State<NoteListPage> {
  @override
  Widget build(BuildContext context) {
    adHelper().loadBanner().then((loaded) {
      if (loaded) {
        adHelper().showBanner().then((refresh) {
          if (refresh) {
            setState(() {});
          }
        });
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Sticky Notes'),
      ),
      body: FutureBuilder<List<Note>>(
        future: noteManager().listNotes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasData) {
            List<Note> notes = snapshot.data;

            return GridView.builder(
              padding: adHelper().getContentPadding(context),
              itemCount: notes.length,
              itemBuilder: (context, index) {
                return _buildCard(notes[index]);
              },
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1,
              ),
            );
          }

          return Center(
            child: Text('오류가 발생했습니다.'),
          );
        },
      ),
      floatingActionButton: Padding(
        padding: adHelper().getFabPadding(context),
        child: FloatingActionButton(
          child: Icon(Icons.add),
          tooltip: '새 노트',
          onPressed: () {
            Navigator.pushNamed(context, NoteEditPage.routeName).then((value) {
              setState(() {});
            });
          },
        ),
      ),
    );
  }


  @override
  void dispose() {
    adHelper().dispose();
    super.dispose();
  }

  Widget _buildCard(Note note) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          NoteViewPage.routeName,
          arguments: NotePageArgs(note),
        ).then((value) {
          setState(() {});
        });
      },
      child: Card(
        color: note.color,
        child: Padding(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                note.title.isEmpty ? '(제목 없음)' : note.title,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              Expanded(
                child: Text(
                  note.body,
                  overflow: TextOverflow.fade,
                ),
              ),
            ],
          ),
          padding: EdgeInsets.all(12.0),
        ),
      ),
    );
  }
}
