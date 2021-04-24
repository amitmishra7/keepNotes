import 'dart:async';
import 'package:keep_notes/databse/notes_dao.dart';
import 'package:keep_notes/model/note.dart';

class NotesBloc {
  NotesDao notesDao = NotesDao();

  StreamController notesStreamController =
      StreamController<List<Note>>.broadcast();

  StreamSink<List<Note>> get notesSink => notesStreamController.sink;

  Stream<List<Note>> get notesStream => notesStreamController.stream;

  readAllNotes() async {
    List<Note> notes = await notesDao.readAllNotes();
    notesSink.add(notes);

  }

  createNote(Note note) async {
    await notesDao.createNote(note);
    readAllNotes();
  }

  updateNote(Note note) async{
    await notesDao.update(note);
    readAllNotes();
  }

  deleteNote(Note note) async {
    await notesDao.delete(note);
    readAllNotes();
  }

  dispose() {
    notesStreamController.close();
  }
}
