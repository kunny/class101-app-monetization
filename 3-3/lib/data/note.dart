class Note {
  static const newNoteId = -1;

  int id;

  String title;

  String body;

  Note(
    this.body, {
    this.id = -1,
    this.title = '',
  });
}
