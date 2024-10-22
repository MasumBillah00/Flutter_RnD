import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app_model/todo_model/model/note_model.dart';
import '../../../../bloc/todo_bloc/note/note_bloc.dart';
import '../../../../bloc/todo_bloc/note/note_event.dart';
import '../../../../bloc/todo_bloc/note/note_state.dart';




class NoteListPage extends StatelessWidget {
  const NoteListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9,),
      child: Scaffold(
        appBar: AppBar(title: const Text('Notes')),
        body: BlocBuilder<NoteBloc, NoteState>(
          builder: (context, state) {
            if (state is NotesLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is NotesLoaded) {
              return ListView.builder(
                itemCount: state.notes.length,
                itemBuilder: (context, index) {
                  final note = state.notes[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    elevation: 4.0,
                    color: Colors.grey.withOpacity(.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),

                    child: ListTile(
                      title: Text(note.title),
                      subtitle: Text(note.content),
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => NoteDetailPage(note: note),
                      )),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          context.read<NoteBloc>().add(DeleteNote(note.id!));
                        },
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(child: Text('Failed to load notes'));
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.amber, // Set the background color
          foregroundColor: Colors.black, // Set the icon color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0), // Rounded rectangle shape
          ),
          child: const Icon(Icons.add),
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const NoteDetailPage(),
          )),
        ),
      ),
    );
  }
}

class NoteDetailPage extends StatefulWidget {
  final Note? note;

  const NoteDetailPage({super.key, this.note});

  @override
  _NoteDetailPageState createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'New Note' : 'Edit Note'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              if (_titleController.text.isNotEmpty &&
                  _contentController.text.isNotEmpty) {
                final newNote = Note(
                  id: widget.note?.id,
                  title: _titleController.text,
                  content: _contentController.text,
                );
                if (widget.note == null) {
                  context.read<NoteBloc>().add(AddNote(newNote));
                } else {
                  context.read<NoteBloc>().add(UpdateNote(newNote));
                }
                Navigator.of(context).pop();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Title and content cannot be empty!'),
                ));
              }
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: _contentController,
                decoration: const InputDecoration(
                  labelText: 'Content',
                  border: OutlineInputBorder(),
                ),
                maxLines: null,
                expands: true,
                keyboardType: TextInputType.multiline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}