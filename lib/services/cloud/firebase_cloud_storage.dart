import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:menotees/services/cloud/cloud_note.dart';
import 'package:menotees/services/cloud/cloud_storage_contants.dart';
import 'package:menotees/services/cloud/cloud_storage_exceptions.dart';
import 'package:menotees/services/crud/notes_service.dart';

class FirebaseCloudStorage {
  final notes = FirebaseFirestore.instance.collection('notes');

  Stream<Iterable<CloudNote>> allNotes({required String ownerUserId}) {
    final allNotes = notes
        .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
        .snapshots()
        .map((event) => event.docs.map((doc) => CloudNote.fromSnapshot(doc)));
    return allNotes;
  }

  // Future<Iterable<CloudNote>> getNotes({
  //   required String ownerUserId,
  // }) async {
  //   try {
  //     return await notes
  //         .where(
  //           ownerUserIdFieldName,
  //           isEqualTo: ownerUserId,
  //         )
  //         .get()
  //         .then(
  //           (value) => value.docs.map(
  //             (doc) => CloudNote.fromSnapshot(doc),
  //           ),
  //         );
  //   } catch (e) {
  //     throw CouldNotGetAllNotesException();
  //   }
  // }

  Future<CloudNote> createNewNote({required String ownerUserId}) async {
    final document = await notes.add({
      ownerUserIdFieldName: ownerUserId,
      textFieldName: '',
    });
    final fetchedNote = await document.get();
    return CloudNote(
      ownerUserId: ownerUserId,
      documentId: fetchedNote.id,
      text: '',
    );
  }

  Future<void> updateNote({
    required String documentId,
    required String text,
  }) async {
    try {
      await notes.doc(documentId).update({textFieldName: text});
    } catch (e) {
      throw CouldNotUpdateNoteException();
    }
  }

  Future<void> deleteNote({
    required String documentId,
  }) async {
    try {
      await notes.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteNoteException();
    }
  }

  // singleton
  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;
}
