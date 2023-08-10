import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:qatar_data_app/bloc/bloc/note_bloc.dart';
import 'package:qatar_data_app/bloc/events/crud_event.dart';
import 'package:qatar_data_app/bloc/states/crud_state.dart';
import 'package:qatar_data_app/get/note_getx_controller.dart';
import 'package:qatar_data_app/models/note.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qatar_data_app/models/process_respnse.dart';
import 'package:qatar_data_app/preferences/shared_pref_controller.dart';
import 'package:qatar_data_app/provider/note_provider.dart';
import 'package:qatar_data_app/utlis/helpers.dart';
import 'package:qatar_data_app/widgets/app_text_field.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({Key? key, this.note}) : super(key: key);

  final Note? note;

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> with Helpers {
  late TextEditingController _titleTextController;
  late TextEditingController _infoTextController;

  @override
  void initState() {
    super.initState();
    _titleTextController = TextEditingController(text: widget.note?.title);
    _infoTextController = TextEditingController(text: widget.note?.info);
  }

  @override
  void dispose() {
    _titleTextController.dispose();
    _infoTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            title,
            style: GoogleFonts.nunito(),
          ),
        ),
        body: BlocListener<NoteBloc, CrudState>(
          listenWhen: (previous, current) =>
              current is ProcessState &&
              (current.processType == ProcessType.create ||
                  current.processType == ProcessType.update),
          listener: (context, state) {
            state as ProcessState;
            showSnackBar(context,
                message: state.message, error: !state.success);
            if (state.success) {
              isNewNote ? clear() : Navigator.pop(context);
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.nunito(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  AppLocalizations.of(context)!.note_hint,
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                    color: Colors.black45,
                  ),
                ),
                SizedBox(height: 20),
                AppTextField(
                  textController: _titleTextController,
                  hint: AppLocalizations.of(context)!.title,
                  prefixIcon: Icons.title,
                ),
                SizedBox(height: 10),
                AppTextField(
                  textController: _infoTextController,
                  hint: AppLocalizations.of(context)!.info,
                  prefixIcon: Icons.info,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _performSave(),
                  child: Text(AppLocalizations.of(context)!.save),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  String get title {
    return isNewNote
        ? AppLocalizations.of(context)!.new_note
        : AppLocalizations.of(context)!.update_note;
  }

  bool get isNewNote => widget.note == null;

  void _performSave() {
    if (_checkData()) {
      _save();
    }
  }

  bool _checkData() {
    if (_titleTextController.text.isNotEmpty &&
        _infoTextController.text.isNotEmpty) {
      return true;
    }
    showSnackBar(context, message: 'Enter required data !', error: true);
    return false;
  }

  void _save() {
    isNewNote
        ? BlocProvider.of<NoteBloc>(context).add(CreateEvent(note))
        : BlocProvider.of<NoteBloc>(context).add(UpdateEvent(note));
  }

  Note get note {
    Note note = isNewNote ? Note() : widget.note!;
    note.title = _titleTextController.text;
    note.info = _infoTextController.text;
    note.userId = SharedPrefController().getValueFor(key: PrefKeys.id.name)!;
    return note;
  }

  void clear() {
    _titleTextController.clear();
    _infoTextController.clear();
  }
}
