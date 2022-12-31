import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:menotees/services/cloud/cloud_storage_contants.dart';

class CloudNote {
  final String ownerUserId;
  final String documentId;
  final String text;

  CloudNote({
    required this.ownerUserId,
    required this.documentId,
    required this.text,
  });

  CloudNote.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        ownerUserId = snapshot.data()[ownerUserIdFieldName],
        text = snapshot.data()[textFieldName] as String;
}
