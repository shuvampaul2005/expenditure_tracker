import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';
import '../providers/theme_provider.dart';
import '../models/expense.dart';
import 'charts_screen.dart';
import 'pdf_exporter.dart';
import 'package:flutter/rendering.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final List<String> _categories = ['All', 'Food', 'Transport', 'Shopping', 'Bills', 'Entertainment', 'Health', 'Fuel', 'Other'];
  late AnimationController _animationController;
  String? _selectedCategory = 'All';
  String? _selectedSort;
  final GlobalKey _chartKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    Provider.of<ExpenseProvider>(context, listen: false).fetchExpenses();
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    Provider.of<ExpenseProvider>(context, listen: false).filterExpenses(category: _selectedCategory);
  }

  void _applySorting() {
    Provider.of<ExpenseProvider>(context, listen: false).sortExpenses(criteria: _selectedSort);
  }

  double _calculateTotalExpenditure(List<Expense> expenses) {
    return expenses.fold(0, (sum, expense) => sum + expense.amount);
  }

  void _exportPDF() {
    final provider = Provider.of<ExpenseProvider>(context, listen: false);
    PdfExporter.generateAndExportPDF(provider.expenses, _chartKey);
  }

  void _showExpenseDetails(BuildContext context, Expense expense) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(expense.title, style: const TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Amount: \$${expense.amount.toStringAsFixed(2)}'),
              Text('Category: ${expense.category}'),
              Text('Payment Method: ${expense.paymentMethod}'),
              Text('Date: ${expense.date.toLocal()}'),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
            TextButton(
              onPressed: () {
                Provider.of<ExpenseProvider>(context, listen: false).deleteExpense(expense.id);
                Navigator.pop(context);
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
            ElevatedButton(
              onPressed: () => _editExpense(context, expense),
              child: const Text('Edit'),
            ),
          ],
        );
      },
    );
  }
  void _editExpense(BuildContext context, Expense expense) {
    TextEditingController titleController = TextEditingController(text: expense.title);
    TextEditingController amountController = TextEditingController(text: expense.amount.toString());
    String selectedCategory = expense.category;
    TextEditingController paymentMethodController = TextEditingController(text: expense.paymentMethod);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Edit Expense', style: TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Title')),
                TextField(controller: amountController, decoration: const InputDecoration(labelText: 'Amount'), keyboardType: TextInputType.number),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: _categories.map((category) {
                    return DropdownMenuItem(value: category, child: Text(category));
                  }).toList(),
                  onChanged: (value) => setState(() => selectedCategory = value!),
                ),
                TextField(controller: paymentMethodController, decoration: const InputDecoration(labelText: 'Payment Method')),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                Provider.of<ExpenseProvider>(context, listen: false).updateExpense(
                  Expense(
                    id: expense.id,
                    title: titleController.text,
                    amount: double.parse(amountController.text),
                    date: expense.date,
                    category: selectedCategory,
                    paymentMethod: paymentMethodController.text,
                  ),
                );
                Navigator.pop(context);
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }
  void _addExpense(BuildContext context) {
    TextEditingController titleController = TextEditingController();
    TextEditingController amountController = TextEditingController();
    String selectedCategory = _categories.first;
    TextEditingController paymentMethodController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Add Expense', style: TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Title')),
                TextField(controller: amountController, decoration: const InputDecoration(labelText: 'Amount'), keyboardType: TextInputType.number),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: _categories.map((category) {
                    return DropdownMenuItem(value: category, child: Text(category));
                  }).toList(),
                  onChanged: (value) => setState(() => selectedCategory = value!),
                ),
                TextField(controller: paymentMethodController, decoration: const InputDecoration(labelText: 'Payment Method')),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                Provider.of<ExpenseProvider>(context, listen: false).addExpense(
                  Expense(
                    id: '',
                    title: titleController.text,
                    amount: double.parse(amountController.text),
                    date: DateTime.now(),
                    category: selectedCategory,
                    paymentMethod: paymentMethodController.text,
                  ),
                );
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget Tracker', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart, size: 28),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ChartsScreen()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: _exportPDF,
          ),
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
              themeProvider.toggleTheme();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton<String>(
                  hint: const Text('Filter by Category'),
                  value: _selectedCategory,
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                    _applyFilters();
                  },
                  items: _categories.map((category) {
                    return DropdownMenuItem(value: category, child: Text(category));
                  }).toList(),
                ),
                DropdownButton<String>(
                  hint: const Text('Sort by'),
                  value: _selectedSort,
                  onChanged: (value) {
                    setState(() {
                      _selectedSort = value;
                    });
                    _applySorting();
                  },
                  items: ['Amount', 'Date'].map((sortOption) {
                    return DropdownMenuItem(value: sortOption, child: Text(sortOption));
                  }).toList(),
                ),
              ],
            ),
          ),
          Consumer<ExpenseProvider>(
            builder: (context, provider, child) {
              final totalExpenditure = _calculateTotalExpenditure(provider.expenses);
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Total Expenditure: \$${totalExpenditure.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                ),
              );
            },
          ),
          Expanded(
            child: RepaintBoundary(
              key: _chartKey,
              child: Consumer<ExpenseProvider>(
                builder: (context, provider, child) {
                  return ListView.builder(
                    padding: const EdgeInsets.only(top: 10),
                    itemCount: provider.expenses.length,
                    itemBuilder: (context, index) {
                      final expense = provider.expenses[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          title: Text(expense.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                          trailing: Text('\$${expense.amount.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                          onTap: () => _showExpenseDetails(context, expense),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
