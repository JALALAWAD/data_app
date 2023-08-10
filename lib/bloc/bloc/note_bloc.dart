import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qatar_data_app/bloc/events/crud_event.dart';
import 'package:qatar_data_app/bloc/states/crud_state.dart';
import 'package:qatar_data_app/database/controller/note_db_controller.dart';
import 'package:qatar_data_app/models/note.dart';

class NoteBloc extends Bloc<CrudEvent, CrudState> {
  NoteBloc(super.initialState) {
    on<CreateEvent>(onCreateEvent);
    on<ReadEvent>(onReadEvent);
    on<UpdateEvent>(onUpdateEvent);
    on<DeleteEvent>(onDeleteEvent);
  }

  List<Note> _data = <Note>[];

  final NoteDbController _notedbController = NoteDbController();

  void onCreateEvent(CreateEvent event, Emitter<CrudState> emitter) async {
    int newRowId = await _notedbController.create(event.note);
    if (newRowId != 0) {
      event.note.id = newRowId;
      _data.add(event.note);
      emitter(ReadState(_data));
    }
    emitter(ProcessState(
        ProcessType.create,
        newRowId != 0 ? 'Created successfully' : 'Create failed!',
        newRowId != 0));
  }

  void onReadEvent(ReadEvent event, Emitter<CrudState> emitter) async {
    emitter(LoadingState());
    _data = await _notedbController.read();
    emitter(ReadState(_data));
  }

  void onUpdateEvent(UpdateEvent event, Emitter<CrudState> emitter) async {
    bool updated = await _notedbController.update(event.note);
    if (updated) {
      int index = _data.indexWhere((element) => element.id == event.note.id);
      if (index != -1) {
        _data[index] = event.note;
        emitter(ReadState(_data));
      }
    }
    emitter(ProcessState(ProcessType.update,
        updated ? 'Updated successfully' : 'update failed ', updated));
  }

  void onDeleteEvent(DeleteEvent event, Emitter<CrudState> emitter) async {
    bool deleted = await _notedbController.delete(_data[event.index].id);
    if (deleted) {
      _data.removeAt(event.index);
      emitter(ReadState(_data));
    }
    emitter(ProcessState(ProcessType.delete,
        deleted ? 'Deleted successfully' : 'Delete failed!', deleted));
  }
}
