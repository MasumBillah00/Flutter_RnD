import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../database/todo_database/note_database.dart';
import 'note_event.dart';
import 'note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final DatabaseProvider dbProvider;

  NoteBloc(this.dbProvider) : super(NotesLoading()) {
    on<LoadNotes>((event, emit) async {
      try {
        final notes = await dbProvider.getNotes();
        emit(NotesLoaded(notes));
      } catch (_) {
        emit(NotesError());
      }
    });

    on<AddNote>((event, emit) async {
      try {
        await dbProvider.insert(event.note);
        final notes = await dbProvider.getNotes();
        emit(NotesLoaded(notes));
      } catch (_) {
        emit(NotesError());
      }
    });

    on<UpdateNote>((event, emit) async {
      try {
        await dbProvider.update(event.note);
        final notes = await dbProvider.getNotes();
        emit(NotesLoaded(notes));
      } catch (_) {
        emit(NotesError());
      }
    });

    on<DeleteNote>((event, emit) async {
      try {
        await dbProvider.delete(event.id);
        final notes = await dbProvider.getNotes();
        emit(NotesLoaded(notes));
      } catch (_) {
        emit(NotesError());
      }
    });
  }
}