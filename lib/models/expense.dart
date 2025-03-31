class Expense {
  String id;
  String title;
  double amount;
  DateTime date;
  String category;
  String paymentMethod;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    required this.paymentMethod,
  });

  // Convert Expense to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
      'category': category,
      'paymentMethod': paymentMethod,
    };
  }

  // Create Expense object from Firestore document
  factory Expense.fromMap(Map<String, dynamic> map, String documentId) {
    return Expense(
      id: documentId,
      title: map['title'],
      amount: map['amount'].toDouble(),
      date: DateTime.parse(map['date']),
      category: map['category'],
      paymentMethod: map['paymentMethod'],
    );
  }
}
