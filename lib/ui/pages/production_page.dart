// lib/ui/pages/production_page.dart
import 'package:flutter/material.dart';
import 'package:pen/ui/theme/theme.dart';
import 'package:intl/intl.dart';

class ProductionPage extends StatefulWidget {
  const ProductionPage({super.key});

  @override
  State<ProductionPage> createState() => _ProductionPageState();
}

class _ProductionPageState extends State<ProductionPage> {
  int selectedShift = 1;
  DateTime selectedDate = DateTime.now();
  
  // Controllers untuk input
  Map<String, Map<String, TextEditingController>> controllers = {
    'SERUT': {
      'jumlah': TextEditingController(),
      'plastik': TextEditingController(),
      'rusak': TextEditingController(),
    },
    '10': {
      'jumlah': TextEditingController(),
      'plastik': TextEditingController(),
      'rusak': TextEditingController(),
    },
    '20': {
      'jumlah': TextEditingController(),
      'plastik': TextEditingController(),
      'rusak': TextEditingController(),
    },
  };

  @override
  void dispose() {
    controllers.forEach((product, fields) {
      fields.forEach((field, controller) {
        controller.dispose();
      });
    });
    super.dispose();
  }

  int getTotalJumlah() {
    int total = 0;
    controllers.forEach((product, fields) {
      total += int.tryParse(fields['jumlah']!.text) ?? 0;
    });
    return total;
  }

  void saveProduction() {
    // Implementasi save production
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data produksi berhasil disimpan')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGray,
      appBar: AppBar(
        backgroundColor: white,
        elevation: 1,
        title: Text('Produksi', style: headingStyle.copyWith(fontSize: 20)),
        actions: [
          IconButton(
            onPressed: saveProduction,
            icon: const Icon(Icons.save, color: Colors.blue),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Selector
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat('dd MMMM yyyy').format(selectedDate),
                    style: headingStyle.copyWith(fontSize: 16),
                  ),
                  IconButton(
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2024),
                        lastDate: DateTime(2026),
                      );
                      if (date != null) {
                        setState(() {
                          selectedDate = date;
                        });
                      }
                    },
                    icon: const Icon(Icons.calendar_today, color: purple),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Shift Selector
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Pilih Shift', style: headingStyle.copyWith(fontSize: 16)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildShiftButton(1, '00:00 - 08:00'),
                      const SizedBox(width: 8),
                      _buildShiftButton(2, '08:00 - 16:00'),
                      const SizedBox(width: 8),
                      _buildShiftButton(3, '16:00 - 00:00'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Production Input Table
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Input Produksi Shift $selectedShift',
                    style: headingStyle.copyWith(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  
                  // Header Table
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text('Produk', style: subheadingStyle.copyWith(fontSize: 14)),
                      ),
                      Expanded(
                        child: Text('Jumlah', style: subheadingStyle.copyWith(fontSize: 14)),
                      ),
                      Expanded(
                        child: Text('Plastik', style: subheadingStyle.copyWith(fontSize: 14)),
                      ),
                      Expanded(
                        child: Text('Rusak', style: subheadingStyle.copyWith(fontSize: 14)),
                      ),
                    ],
                  ),
                  const Divider(height: 24),

                  // SERUT Row
                  _buildProductRow('SERUT'),
                  const SizedBox(height: 12),

                  // 10 Row
                  _buildProductRow('10'),
                  const SizedBox(height: 12),

                  // 20 Row
                  _buildProductRow('20'),
                  const Divider(height: 24),

                  // Total
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text('TOTAL', style: headingStyle.copyWith(fontSize: 14)),
                      ),
                      Expanded(
                        child: Text(
                          getTotalJumlah().toString(),
                          style: headingStyle.copyWith(fontSize: 14, color: purple),
                        ),
                      ),
                      const Expanded(child: SizedBox()),
                      const Expanded(child: SizedBox()),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Summary Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: purple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: purple),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Stock Awal', style: subheadingStyle.copyWith(fontSize: 14)),
                      Text('0', style: headingStyle.copyWith(fontSize: 14)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Produksi', style: subheadingStyle.copyWith(fontSize: 14)),
                      Text(
                        getTotalJumlah().toString(),
                        style: headingStyle.copyWith(fontSize: 14, color: green),
                      ),
                    ],
                  ),
                  const Divider(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total Stock', style: headingStyle.copyWith(fontSize: 16)),
                      Text(
                        getTotalJumlah().toString(),
                        style: headingStyle.copyWith(fontSize: 16, color: purple),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShiftButton(int shift, String time) {
    final isSelected = selectedShift == shift;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            selectedShift = shift;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? purple : lightGray,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? purple : gray.withOpacity(0.3),
            ),
          ),
          child: Column(
            children: [
              Text(
                'Shift $shift',
                style: TextStyle(
                  color: isSelected ? white : black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                time,
                style: TextStyle(
                  color: isSelected ? white : gray,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductRow(String product) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(product, style: subheadingStyle.copyWith(fontSize: 14)),
        ),
        Expanded(
          child: _buildInputField(controllers[product]!['jumlah']!),
        ),
        Expanded(
          child: _buildInputField(controllers[product]!['plastik']!),
        ),
        Expanded(
          child: _buildInputField(controllers[product]!['rusak']!),
        ),
      ],
    );
  }

  Widget _buildInputField(TextEditingController controller) {
    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: gray.withOpacity(0.3)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: gray.withOpacity(0.3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: purple),
          ),
        ),
        onChanged: (value) {
          setState(() {});
        },
      ),
    );
  }
}