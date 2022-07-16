import 'package:sticky_notes/ad_helper.dart';
import 'package:sticky_notes/data/note_manager.dart';

AdHelper? _adHelper;

NoteManager? _noteManager;

AdHelper adHelper() {
  if (_adHelper == null) {
    _adHelper = AdHelper();
  }
  return _adHelper!;
}

NoteManager noteManager() {
  if (_noteManager == null) {
    _noteManager = NoteManager();
  }
  return _noteManager!;
}
