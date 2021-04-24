import 'package:keep_notes/model/note.dart';
import 'package:sembast/sembast.dart';
import 'app_database.dart';

class NotesDao {
  static const String NOTE_STORE_NAME = 'Notes';
  final _notesStore = intMapStoreFactory.store(NOTE_STORE_NAME);
  Future<Database> get _db async => await AppDatabase.instance.database;

  Future createNote(Note note) async {
    await _notesStore.add(await _db, note.toMap());
  }

  Future<List<Note>> readAllNotes() async {
    final finder = Finder(sortOrders: [
      SortOrder('id'),
    ]);

    final recordSnapshots = await _notesStore.find(
      await _db,
      finder: finder,
    );
    return recordSnapshots.map((snapshot) {
      final note = Note.fromMap(snapshot.value);
      note.id = snapshot.key;
      return note;
    }).toList();
  }

  Future update(Note note) async {
    final finder = Finder(filter: Filter.byKey(note.id));
    await _notesStore.update(
      await _db,
      note.toMap(),
      finder: finder,
    );
  }

  Future delete(Note note) async {
    final finder = Finder(filter: Filter.byKey(note.id));
    await _notesStore.delete(
      await _db,
      finder: finder,
    );
  }

}