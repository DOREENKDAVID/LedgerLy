import 'package:flutter/material.dart';
import 'package:ledgerly_v3/core/services/api_service.dart';
import 'package:intl/intl.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  String? selectedCategory;
  DateTime selectedDate = DateTime.now();

  final List<String> categories = [
    'Transport',
    'Electricity',
    'Stock Purchase',
    'Data',
    'Rent',
    'Packaging',
    'Miscellaneous',
  ];

  bool _isLoading = false;

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _saveExpense() {
    if (selectedCategory == null || _amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select category and enter amount")),
      );
      return;
    }

    _submitExpense();
  }

  Future<void> _submitExpense() async {
    setState(() => _isLoading = true);

    try {
      final response = await ApiService.post(
        '/v2/expenses', // replace with your backend route
        body: {
          'category': selectedCategory,
          'amount': double.parse(_amountController.text),
          'note': _noteController.text,
          'date': selectedDate.toIso8601String(),
        },
        auth: true,
      );

      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Expense saved successfully"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context); // Navigate back after successful save
      // OR navigate to another screen if needed:
      // Navigator.pushNamed(context, '/expenses_list');
    } catch (e) {
      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('EEE, MMM d').format(selectedDate);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Record Expense'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Category Section
                    const Text(
                      "What was this expense for?",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: categories.map((category) {
                        final isSelected = selectedCategory == category;

                        return ChoiceChip(
                          label: Text(category),
                          selected: isSelected,
                          onSelected: (_) {
                            setState(() {
                              selectedCategory = category;
                            });
                          },
                          selectedColor: Colors.teal.shade100,
                          backgroundColor: Colors.grey.shade200,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 30),

                    /// Amount Section
                    const Text(
                      "How much did you spend?",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        prefixText: "₦ ",
                        hintText: "0",
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// Date Section
                    const Text(
                      "When did this happen?",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: _pickDate,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(formattedDate),
                            const Icon(Icons.calendar_today_outlined),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// Note Section
                    const Text(
                      "Add a note (optional)",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _noteController,
                      maxLength: 120,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: "e.g., Prepaid electricity token",
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        counterText: "${_noteController.text.length}/120",
                      ),
                      onChanged: (_) {
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ),
            ),

            /// Save Button
            Container(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveExpense,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Save Expense",
                          style: TextStyle(fontSize: 16),
                        ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}