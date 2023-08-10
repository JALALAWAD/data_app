import 'package:flutter/material.dart';
import 'package:qatar_data_app/database/controller/note_db_controller.dart';
import 'package:qatar_data_app/models/note.dart';
import 'package:qatar_data_app/models/process_respnse.dart';

class NoteProvider extends ChangeNotifier {
  List<Note> notes = <Note>[];

  NoteDbController _dbController = NoteDbController();

  Future<ProcessResponse> create({required Note note}) async {
    int newRowId = await _dbController.create(note);
    if (newRowId != 0) {
      note.id = newRowId;
      notes.add(note);
      notifyListeners();
    }
    return ProcessResponse(
      message: newRowId != 0 ? 'Created Successfully ' : 'Create Failed',
      success: newRowId != 0,
    );
  }

  void read() async {
    notes = await _dbController.read();
    notifyListeners();
  }

  Future<ProcessResponse> update({required Note updatedNote}) async {
    bool updated = await _dbController.update(updatedNote);
    if (updated) {
      int index = notes.indexWhere((element) => element.id == updatedNote.id);
      if (index != -1) {
        notes[index] = updatedNote;
        notifyListeners();
      }
    }
    return ProcessResponse(
        message: updated ? 'Updated Successfully ' : 'Updated Failed!',
        success: updated);
  }

  Future<ProcessResponse> delete({required int index}) async {
    bool deleted = await _dbController.delete(notes[index].id);
    if (deleted) {
      notes.removeAt(index);
      notifyListeners();
    }
    return ProcessResponse(
        message: deleted ? 'Deleted Successfully ' : 'Deleted Failed!',
        success: deleted);
  }
}
