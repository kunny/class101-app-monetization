import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sticky_notes/data/note.dart';

class NoteManager {
  static const _databaseName = 'notes.db';

  static const _databaseVersion = 1;

  Database _database;

  Future<void> addNote(Note note) async {
    Database db = await _getDatabase();
    await db.insert(Note.tableName, note.toRow());
  }

  Future<void> deleteNote(int id) async {
    Database db = await _getDatabase();
    await db.delete(
      Note.tableName,
      where: '${Note.columnId} = ?',
      whereArgs: [id],
    );
  }

  Future<Note> getNote(int id) async {
    Database db = await _getDatabase();
    List<Map<String, dynamic>> rows = await db.query(
      Note.tableName,
      where: '${Note.columnId} = ?',
      whereArgs: [id],
    );
    return Note.fromRow(rows.single);
  }

  Future<List<Note>> listNotes() async {
    Database db = await _getDatabase();
    List<Map<String, dynamic>> rows = await db.query(Note.tableName);
    return rows.map((row) => Note.fromRow(row)).toList();
  }

  Future<void> updateNote(
    int id,
    String body, {
    String title,
    Color color,
  }) async {
    Database db = await _getDatabase();
    await db.update(
      Note.tableName,
      Note(
        body,
        title: title,
        color: color,
      ).toRow(),
      where: '${Note.columnId} = ?',
      whereArgs: [id],
    );
  }

  Future<Database> _getDatabase() async {
    if (_database == null) {
      _database = await _init();
    }
    return _database;
  }

  Future<Database> _init() async {
    String dbPath = join(await getDatabasesPath(), _databaseName);
    return openDatabase(
      dbPath,
      version: _databaseVersion,
      onCreate: (db, version) async {
        String sql = '''
      CREATE TABLE ${Note.tableName} (
        ${Note.columnId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${Note.columnTitle} TEXT,
        ${Note.columnBody} TEXT NOT NULL,
        ${Note.columnColor} INTEGER NOT NULL
      )
    ''';
        return db.execute(sql);
      },
    );
  }
}
