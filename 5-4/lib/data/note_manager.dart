import 'package:flutter/material.dart';
import 'package:sticky_notes/data/note.dart';

class NoteManager {

  List<Note> _notes = [];

  void addNote(Note note) {
    _notes.add(note);
  }

  void deleteNote(int index) {
    _notes.removeAt(index);
  }

  Note getNote(int index) {
    return _notes[index];
  }

  List<Note> listNotes() {
    return _notes;
  }

  void updateNote(int index, String body, {String title, Color color}) {
    _notes[index].body = body;
    if (title != null) {
      _notes[index].title = title;
    }
    if (color != null) {
      _notes[index].color = color;
    }
  }
}
