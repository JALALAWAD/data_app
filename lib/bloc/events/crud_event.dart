import 'package:qatar_data_app/models/note.dart';

abstract class CrudEvent {}

class CreateEvent extends CrudEvent {
  Note note;

  CreateEvent(this.note);
}

class DeleteEvent extends CrudEvent {
  final int index;

  DeleteEvent(this.index);
}

class ReadEvent extends CrudEvent {}

class ShowEvent extends CrudEvent {
  final int id;
  ShowEvent(this.id);
}

class UpdateEvent extends CrudEvent {
  final Note note;

  UpdateEvent(this.note);
}
