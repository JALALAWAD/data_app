import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:qatar_data_app/bloc/bloc/note_bloc.dart';
import 'package:qatar_data_app/bloc/events/crud_event.dart';
import 'package:qatar_data_app/bloc/states/crud_state.dart';
import 'package:qatar_data_app/get/note_getx_controller.dart';
import 'package:qatar_data_app/models/process_respnse.dart';
import 'package:qatar_data_app/preferences/shared_pref_controller.dart';
import 'package:qatar_data_app/provider/note_provider.dart';
import 'package:qatar_data_app/screens/app/note_screen.dart';
import 'package:qatar_data_app/utlis/helpers.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with Helpers {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<NoteBloc>(context).add(ReadEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
        actions: [
          IconButton(
            onPressed: () async {
              await _logout(context);
            },
            icon: Icon(Icons.logout),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NoteScreen(),
                ),
              );
            },
            icon: const Icon(Icons.note_add),
          ),
        ],
      ),

      body: BlocListener<NoteBloc, CrudState>(
        listenWhen: (previous, current) =>
            current is ProcessState &&
            current.processType == ProcessType.delete,
        listener: (context, state) {
          state as ProcessState;
          showSnackBar(context, message: state.message, error: !state.success);
        },
        child: BlocBuilder<NoteBloc, CrudState>(
          buildWhen: (previous, current) =>
              current is LoadingState || current is ReadState,
          builder: (context, state) {
            if (state is LoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ReadState && state.data.isNotEmpty) {
              return ListView.builder(
                  itemCount: state.data.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NoteScreen(
                              note: state.data[index],
                            ),
                          ),
                        );
                      },
                      leading: Icon(Icons.note),
                      title: Text(state.data[index].title),
                      subtitle: Text(state.data[index].info),
                      trailing: IconButton(
                        onPressed: () => deleteNote(context, index: index),
                        icon: Icon(Icons.delete),
                      ),
                    );
                  });
            } else {
              return Center(
                child: Text(
                  'NO DATA',
                  style: GoogleFonts.nunito(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 22,
                  ),
                ),
              );
            }
          },
        ),
      ),
      // body: GetX<NoteGetxController>(
      //   // init: NoteGetxController(),
      //   // global: true,
      //   builder: (NoteGetxController contriller) {
      //     if (contriller.loading.value) {
      //       return const Center(child: CircularProgressIndicator());
      //     } else if (contriller.notes.isNotEmpty) {
      //       return ListView.builder(
      //           itemCount: contriller.notes.length,
      //           itemBuilder: (context, index) {
      //             return ListTile(
      //               onTap: () {
      //                 Navigator.push(
      //                   context,
      //                   MaterialPageRoute(
      //                     builder: (context) => NoteScreen(
      //                       note: contriller.notes[index],
      //                     ),
      //                   ),
      //                 );
      //               },
      //               leading: Icon(Icons.note),
      //               title: Text(contriller.notes[index].title),
      //               subtitle: Text(contriller.notes[index].info),
      //               trailing: IconButton(
      //                 onPressed: () async =>
      //                     await deleteNote(context, index: index),
      //                 icon: Icon(Icons.delete),
      //               ),
      //             );
      //           });
      //     } else {
      //       return Center(
      //         child: Text(
      //           'NO DATA',
      //           style: GoogleFonts.nunito(
      //             fontWeight: FontWeight.bold,
      //             color: Colors.black,
      //             fontSize: 22,
      //           ),
      //         ),
      //       );
      //     }
      //   },
    );
  }

  Future<void> _logout(BuildContext context) async {
    await SharedPrefController().logout();
    Navigator.pushNamedAndRemoveUntil(
        context, '/login_screen', (route) => false);
  }

  void deleteNote(BuildContext context, {required int index}) {
    BlocProvider.of<NoteBloc>(context).add(DeleteEvent(index));
  }

//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key}) : super(key: key);
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> with Helpers {
//   // NoteGetxController noteGetxController =
//   //     Get.put<NoteGetxController>(NoteGetxController());
//
//   @override
//   void initState() {
//     super.initState();
//     // Provider.of<NoteProvider>(context, listen: false).read();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Home Screen'),
//         actions: [
//           IconButton(
//             onPressed: () async {
//               await _logout();
//             },
//             icon: Icon(Icons.logout),
//           ),
//           IconButton(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => const NoteScreen(),
//                 ),
//               );
//             },
//             icon: const Icon(Icons.note_add),
//           ),
//         ],
//       ),
//       body: GetBuilder<NoteGetxController>(
//         init: NoteGetxController(),
//         global: true,
//         builder: (NoteGetxController contriller) {
//           if (contriller.notes.isNotEmpty) {
//             return ListView.builder(
//                 itemCount: contriller.notes.length,
//                 itemBuilder: (context, index) {
//                   return ListTile(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => NoteScreen(
//                             note: contriller.notes[index],
//                           ),
//                         ),
//                       );
//                     },
//                     leading: Icon(Icons.note),
//                     title: Text(contriller.notes[index].title),
//                     subtitle: Text(contriller.notes[index].info),
//                     trailing: IconButton(
//                       onPressed:
//                           () {}, // async => await deleteNote(index: index),
//                       icon: Icon(Icons.delete),
//                     ),
//                   );
//                 });
//           } else {
//             return Center(
//               child: Text(
//                 'NO DATA',
//                 style: GoogleFonts.nunito(
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black,
//                   fontSize: 22,
//                 ),
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }
//
//   Future<void> _logout() async {
//     await SharedPrefController().logout();
//     Navigator.pushNamedAndRemoveUntil(
//         context, '/login_screen', (route) => false);
//   }
//
//   Future<void> deleteNote({required int index}) async {
//     // ProcessResponse processResponse =
//     //     await Provider.of<NoteProvider>(context, listen: false)
//     //         .delete(index: index);
//
//     // NoteGetxController noteGetxController = Get.find<NoteGetxController>();
//
//     ProcessResponse processResponse =
//         await NoteGetxController.to.delete(index: index);
//
//     showSnackBar(context,
//         message: processResponse.message, error: !processResponse.success);
//   }
// }
}
