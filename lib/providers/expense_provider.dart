import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/expense.dart';

class ExpenseProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Expense> _expenses = [];
  List<Expense> _filteredExpenses = [];

  List<Expense> get expenses => _filteredExpenses; // ✅ Return filtered list

  ExpenseProvider() {
    fetchExpenses();
  }

  void filterExpenses({String? category}) {
    if (category == null || category.isEmpty) {
      _filteredExpenses = List.from(_expenses); // ✅ Reset to all expenses if no filter
    } else {
      _filteredExpenses = _expenses.where((expense) => expense.category == category).toList();
    }
    notifyListeners();
  }

  void sortExpenses({String? criteria}) {
    _filteredExpenses.sort((a, b) { // ✅ Sort the filtered list
      if (criteria == 'Amount') {
        return a.amount.compareTo(b.amount);
      } else if (criteria == 'Date') {
        return a.date.compareTo(b.date);
      }
      return 0;
    });
    notifyListeners();
  }

  void fetchExpenses() {
    _firestore.collection('expenses').snapshots().listen((snapshot) {
      _expenses = snapshot.docs.map((doc) {
        final data = doc.data();
        DateTime parsedDate;

        if (data['date'] is Timestamp) {
          parsedDate = (data['date'] as Timestamp).toDate();
        } else if (data['date'] is String) {
          try {
            parsedDate = DateTime.parse(data['date']);
          } catch (e) {
            parsedDate = DateTime.now();
            debugPrint('Error parsing date for ${doc.id}: $e');
          }
        } else {
          parsedDate = DateTime.now();
        }

        return Expense(
          id: doc.id,
          title: data['title'] ?? '',
          amount: (data['amount'] ?? 0).toDouble(),
          date: parsedDate,
          category: data['category'] ?? '',
          paymentMethod: data['paymentMethod'] ?? '',
        );
      }).toList();

      _filteredExpenses = List.from(_expenses); // ✅ Initialize filtered list

      notifyListeners();
    });
  }

  Future<void> addExpense(Expense expense) async {
    try {
      await _firestore.collection('expenses').add({
        'title': expense.title,
        'amount': expense.amount,
        'date': Timestamp.fromDate(expense.date), // ✅ Ensures date is saved as Timestamp
        'category': expense.category,
        'paymentMethod': expense.paymentMethod,
      });
    } catch (e) {
      debugPrint('Error adding expense: $e');
    }
  }

  Future<void> updateExpense(Expense expense) async {
    try {
      await _firestore.collection('expenses').doc(expense.id).update({
        'title': expense.title,
        'amount': expense.amount,
        'date': Timestamp.fromDate(expense.date), // ✅ Keep date format consistent
        'category': expense.category,
        'paymentMethod': expense.paymentMethod,
      });
    } catch (e) {
      debugPrint('Error updating expense: $e');
    }
  }

  Future<void> deleteExpense(String id) async {
    try {
      await _firestore.collection('expenses').doc(id).delete();
    } catch (e) {
      debugPrint('Error deleting expense: $e');
    }
  }
}
