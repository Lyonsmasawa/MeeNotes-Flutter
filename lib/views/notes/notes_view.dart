import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menotees/constants/routes.dart';
import 'package:menotees/enums/menu_action.dart';
import 'dart:developer' as devtools show log;

import 'package:menotees/services/auth/auth_service.dart';
import 'package:menotees/services/auth/bloc/auth_bloc.dart';
import 'package:menotees/services/auth/bloc/auth_event.dart';
import 'package:menotees/services/cloud/cloud_note.dart';
import 'package:menotees/services/cloud/firebase_cloud_storage.dart';
import 'package:menotees/services/crud/notes_service.dart';
import 'package:menotees/utilities/dialogs/logout_dialog.dart';
import 'package:menotees/views/notes/notes_list_view.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

// class _NotesViewState extends State<NotesView> {
//   late final NotesService _notesService;
//   String get userEmail => AuthService.firebase().currentUser!.email;

//   @override
//   void initState() {
//     _notesService = NotesService();
//     super.initState();
//   }

//   // @override
//   // void dispose() {
//   //   _notesService.close();
//   //   super.dispose();
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Me Notes"),
//         actions: [
//           IconButton(
//             onPressed: () {
//               Navigator.of(context).pushNamed(createOrUpdateRoute);
//             },
//             icon: const Icon(Icons.add),
//           ),
//           PopupMenuButton(
//             onSelected: (value) async {
//               switch (value) {
//                 case MenuAction.logout:
//                   final shouldLogOut = await showLogOutDialog(context);
//                   devtools.log(shouldLogOut.toString());
//                   if (shouldLogOut) {
//                     await AuthService.firebase().logOut();
//                     Navigator.of(context)
//                         .pushNamedAndRemoveUntil('/login/', (_) => false);
//                   }
//                   break;
//               }
//             },
//             itemBuilder: (context) {
//               return const [
//                 PopupMenuItem<MenuAction>(
//                   value: MenuAction.logout,
//                   child: Text("Log out"),
//                 )
//               ];
//             },
//           )
//         ],
//       ),
//       body: FutureBuilder(
//         future: _notesService.getOrCreateUser(email: userEmail),
//         builder: (context, snapshot) {
//           switch (snapshot.connectionState) {
//             case ConnectionState.done:
//               return StreamBuilder(
//                 stream: _notesService.allNotes,
//                 builder: (context, snapshot) {
//                   switch (snapshot.connectionState) {
//                     case ConnectionState.waiting:
//                     case ConnectionState.active:
//                       if (snapshot.hasData) {
//                         final allNotes = snapshot.data as List<DatabaseNote>;
//                         return NotesListView(
//                           notes: allNotes,
//                           onDeleteNote: (note) async {
//                             await _notesService.deleteNote(id: note.id);
//                           },
//                           onTap: (note) {
//                             Navigator.of(context).pushNamed(
//                               createOrUpdateRoute,
//                               arguments: note,
//                             );
//                           },
//                         );
//                       } else {
//                         return CircularProgressIndicator();
//                       }
//                     default:
//                       return const CircularProgressIndicator();
//                   }
//                 },
//               );
//             default:
//               return const CircularProgressIndicator();
//           }
//         },
//       ),
//     );
//   }
// }

class _NotesViewState extends State<NotesView> {
  late final FirebaseCloudStorage _notesService;
  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    super.initState();
  }

  // @override
  // void dispose() {
  //   _notesService.close();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Me Notes"),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(createOrUpdateRoute);
              },
              icon: const Icon(Icons.add),
            ),
            PopupMenuButton(
              onSelected: (value) async {
                switch (value) {
                  case MenuAction.logout:
                    final shouldLogOut = await showLogOutDialog(context);
                    if (shouldLogOut) {
                      context.read<AuthBloc>().add(
                            const AuthEventLogOut(),
                          );
                    }
                    break;
                }
              },
              itemBuilder: (context) {
                return const [
                  PopupMenuItem<MenuAction>(
                    value: MenuAction.logout,
                    child: Text("Log out"),
                  )
                ];
              },
            )
          ],
        ),
        body: StreamBuilder(
          stream: _notesService.allNotes(ownerUserId: userId),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.active:
                if (snapshot.hasData) {
                  final allNotes = snapshot.data as Iterable<CloudNote>;
                  return NotesListView(
                    notes: allNotes,
                    onDeleteNote: (note) async {
                      await _notesService.deleteNote(
                          documentId: note.documentId);
                    },
                    onTap: (note) {
                      Navigator.of(context).pushNamed(
                        createOrUpdateRoute,
                        arguments: note,
                      );
                    },
                  );
                } else {
                  return CircularProgressIndicator();
                }
              default:
                return const CircularProgressIndicator();
            }
          },
        ));
  }
}
