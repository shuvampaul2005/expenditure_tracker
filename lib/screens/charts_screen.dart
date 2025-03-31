import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';
import '../models/expense.dart';

class ChartsScreen extends StatelessWidget {
  const ChartsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Expense Charts')),
      body: Consumer<ExpenseProvider>(
        builder: (context, provider, child) {
          if (provider.expenses.isEmpty) {
            return const Center(child: Text('No expenses available.'));
          }
          return Column(
            children: [
              Expanded(child: _buildCategoryPieChart(provider.expenses)),
              Expanded(child: _buildMonthlyBarChart(provider.expenses)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCategoryPieChart(List<Expense> expenses) {
    Map<String, double> categoryTotals = {};
    for (var expense in expenses) {
      categoryTotals[expense.category] = (categoryTotals[expense.category] ?? 0) + expense.amount;
    }

    List<PieChartSectionData> sections = categoryTotals.entries.map((entry) {
      return PieChartSectionData(
        value: entry.value,
        title: entry.key,
        radius: 50,
      );
    }).toList();

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('Expenses by Category', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Expanded(
              child: PieChart(
                PieChartData(
                  sections: sections,
                  centerSpaceRadius: 40,
                  sectionsSpace: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthlyBarChart(List<Expense> expenses) {
    Map<int, double> monthlyTotals = {};
    for (var expense in expenses) {
      int month = expense.date.month;
      monthlyTotals[month] = (monthlyTotals[month] ?? 0) + expense.amount;
    }

    List<BarChartGroupData> bars = monthlyTotals.entries.map((entry) {
      return BarChartGroupData(x: entry.key, barRods: [BarChartRodData(toY: entry.value, color: Colors.blue)]);
    }).toList();

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('Monthly Expenditure', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Expanded(
              child: BarChart(
                BarChartData(
                  barGroups: bars,
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(show: true),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}