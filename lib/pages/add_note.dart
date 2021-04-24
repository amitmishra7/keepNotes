import 'dart:math';

import 'package:flutter/material.dart';
import 'package:keep_notes/bloc/blocs.dart';
import 'package:keep_notes/databse/notes_dao.dart';
import 'package:keep_notes/model/note.dart';

class AddNote extends StatefulWidget {
  Note note;

  AddNote({this.note});

  @override
  State<StatefulWidget> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  NotesDao notesDao = NotesDao();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    if (widget.note != null) {
      _titleController.text = widget.note.title;
      _descriptionController.text = widget.note.description;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
        leading: InkWell(
            onTap: () {
              if (widget.note != null) {
                int id = widget.note.id;
                notesBloc.updateNote(Note(
                    id: id,
                    title: _titleController.text,
                    description: _descriptionController.text));
              } else {
                if (_titleController.text.isNotEmpty ||
                    _descriptionController.text.isNotEmpty) {
                  int id = Random.secure().nextInt(999);
                  notesBloc.createNote(Note(
                      id: id,
                      title: _titleController.text,
                      description: _descriptionController.text));
                }
              }
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: InkWell(
                onTap: () {
                  if (widget.note != null) {
                    notesBloc.deleteNote(widget.note);
                  }
                  Navigator.pop(context);
                },
                child: Icon(Icons.delete_outline)),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              style: TextStyle(
                fontSize: 25,
              ),
              decoration: InputDecoration(
                hintText: 'Title',
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SingleChildScrollView(
              child: TextField(
                controller: _descriptionController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: 'Note',
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
