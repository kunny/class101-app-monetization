import 'package:sticky_notes/data/note_manager.dart';

NoteManager _noteManager;

NoteManager noteManager() {
  if (_noteManager == null) {
    _noteManager = new NoteManager();
  }
  return _noteManager;
}
