import 'package:qatar_data_app/models/note.dart';

abstract class CrudState {}

enum ProcessType { create, update, delete }

class LoadingState extends CrudState {}

class ProcessState extends CrudState {
  final String message;
  final bool success;
  final ProcessType processType;

  ProcessState(this.processType, this.message, this.success);
}

class ReadState extends CrudState {
  final List<Note> data;
  ReadState(this.data);
}
