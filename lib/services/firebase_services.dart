import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addExpense(Map<String, dynamic> expenseData) async {
    await _firestore.collection('expenses').add(expenseData);
  }

  Stream<QuerySnapshot> getExpenses() {
    return _firestore.collection('expenses').snapshots();
  }
}
