import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreDB {
  final CollectionReference trainingSessionCollection =
      Firestore.instance.collection('journal');
}
