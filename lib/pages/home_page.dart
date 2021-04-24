import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:keep_notes/bloc/blocs.dart';
import 'package:keep_notes/databse/notes_dao.dart';
import 'package:keep_notes/model/note.dart';
import 'package:keep_notes/pages/add_note.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  NotesDao notesDao = NotesDao();
  GlobalKey _sgwKey = GlobalKey();

  /// true list false grid
  bool isList = true;

  @override
  void initState() {
    notesBloc.readAllNotes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: InkWell(
                onTap: () {
                  setState(() {
                    isList = !isList;
                  });
                },
                child: isList ? Icon(Icons.menu) : Icon(Icons.grid_view)),
          ),
        ],
        title: Text('Notes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            StreamBuilder(
              stream: notesBloc.notesStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Expanded(
                    child: isList
                        ? ListView.separated(
                            separatorBuilder: (context, index) {
                              return SizedBox(
                                height: 8,
                              );
                            },
                            shrinkWrap: true,
                            itemCount: snapshot.data != null
                                ? snapshot.data.length
                                : 0,
                            itemBuilder: (BuildContext context, int index) {
                              return buildListItem(snapshot.data[index]);
                            },
                          )
                        : StaggeredGridView.count(
                            key: _sgwKey,
                            crossAxisSpacing: 6,
                            mainAxisSpacing: 6,
                            crossAxisCount:
                                _colForStaggeredView(context, snapshot.data),
                            children:
                                List.generate(snapshot.data.length, (index) {
                              return _tileGenerator(snapshot.data[index]);
                            }),
                            staggeredTiles: _tilesForView(snapshot.data),
                          ),
                  );
                } else {
                  return Expanded(
                      child: Center(
                    child: Text('No Data'),
                  ));
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: goToNotes,
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget buildListItem(Note note) {
    return InkWell(
      onTap: () {
        goToNotes(note: note);
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 1),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                note.title,
                maxLines: 10,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Visibility(
                visible: note.description.isNotEmpty,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: new Text(
                    note.description,
                    maxLines: 10,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _colForStaggeredView(BuildContext context, List<Note> notes) {
    return MediaQuery.of(context).size.width > 600 ? 3 : 2;
  }

  List<StaggeredTile> _tilesForView(List<Note> notes) {
    return List.generate(notes.length, (index) {
      return StaggeredTile.fit(1);
    });
  }

  Widget _tileGenerator(Note note) {
    return GestureDetector(
      child: buildListItem(note),
    );
  }

  void goToNotes({Note note}) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddNote(note: note),
        ));
  }
}
