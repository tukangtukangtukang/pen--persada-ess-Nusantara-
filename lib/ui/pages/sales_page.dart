// lib/ui/pages/sales_page.dart
import 'package:flutter/material.dart';
import 'package:pen/ui/theme/theme.dart';
import 'package:pen/data/model/Customer.dart';
import 'package:pen/data/model/Product.dart';
import 'package:intl/intl.dart';

class SalesPage extends StatefulWidget {
  const SalesPage({super.key});

  @override
  State<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  DateTime selectedDate = DateTime.now();
  Customer? selectedCustomer;
  String notaNumber = '';
  
  Map<String, TextEditingController> quantityControllers = {
    'SERUT': TextEditingController(),
    '10': TextEditingController(),
    '20': TextEditingController(),
  };

  Map<String, double> productPrices = {
    'SERUT': 15000,
    '10': 7500,
    '20': 13000,
  };

  @override
  void initState() {
    super.initState();
    generateNotaNumber();
  }

  @override
  void dispose() {
    quantityControllers.forEach((key, controller) {
      controller.dispose();
    });
    super.dispose();
  }

  void generateNotaNumber() {
    final yy = selectedDate.year.toString().substring(2);
    final mm = selectedDate.month.toString().padLeft(2, '0');
    final dd = selectedDate.day.toString().padLeft(2, '0');
    notaNumber = '$yy$mm$dd-0001'; // Sequence should be from database
  }

  double getProductTotal(String product) {
    int qty = int.tryParse(quantityControllers[product]!.text) ?? 0;
    double price = productPrices[product] ?? 0;
    return qty * price;
  }

  double getGrandTotal() {
    double total = 0;
    quantityControllers.forEach((product, controller) {
      total += getProductTotal(product);
    });
    return total;
  }

  void saveSales() {
    if (selectedCustomer == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih pelanggan terlebih dahulu')),
      );
      return;
    }

    bool hasItems = false;
    quantityControllers.forEach((product, controller) {
      if ((int.tryParse(controller.text) ?? 0) > 0) {
        hasItems = true;
      }
    });

    if (!hasItems) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan minimal 1 produk')),
      );
      return;
    }

    // Save to database
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Penjualan berhasil disimpan\nTotal: ${NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0).format(getGrandTotal())}'),
      ),
    );

    // Reset form
    setState(() {
      selectedCustomer = null;
      quantityControllers.forEach((key, controller) {
        controller.clear();
      });
      generateNotaNumber();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGray,
      appBar: AppBar(
        backgroundColor: white,
        elevation: 1,
        title: Text('Penjualan', style: headingStyle.copyWith(fontSize: 20)),
        actions: [
          IconButton(
            onPressed: saveSales,
            icon: const Icon(Icons.save, color: Colors.blue),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Tanggal', style: subheadingStyle.copyWith(fontSize: 12)),
                          const SizedBox(height: 4),
                          Text(
                            DateFormat('dd/MM/yyyy').format(selectedDate),
                            style: headingStyle.copyWith(fontSize: 14),
                          ),
                        ],
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
                              generateNotaNumber();
                            });
                          }
                        },
                        icon: const Icon(Icons.calendar_today, color: purple, size: 20),
                      ),
                    ],
                  ),
                  const Divider(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('No. Nota', style: subheadingStyle.copyWith(fontSize: 12)),
                      Text(
                        notaNumber,
                        style: headingStyle.copyWith(fontSize: 14, color: purple),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Customer Selector
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Pelanggan', style: headingStyle.copyWith(fontSize: 16)),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: () async {
                      final customer = await showModalBottomSheet<Customer>(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) => _buildCustomerPicker(),
                      );
                      if (customer != null) {
                        setState(() {
                          selectedCustomer = customer;
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: gray.withOpacity(0.3)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            selectedCustomer?.name ?? 'Pilih Pelanggan',
                            style: selectedCustomer != null
                                ? headingStyle.copyWith(fontSize: 14)
                                : subheadingStyle.copyWith(fontSize: 14),
                          ),
                          const Icon(Icons.arrow_drop_down, color: gray),
                        ],
                      ),
                    ),
                  ),
                  if (selectedCustomer != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      'ID: ${selectedCustomer!.id}',
                      style: subheadingStyle.copyWith(fontSize: 12),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Products Input
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Produk', style: headingStyle.copyWith(fontSize: 16)),
                  const SizedBox(height: 16),
                  
                  // Table Header
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text('Nama', style: subheadingStyle.copyWith(fontSize: 13)),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text('Kantong', style: subheadingStyle.copyWith(fontSize: 13)),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text('Harga', style: subheadingStyle.copyWith(fontSize: 13)),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text('Jumlah', style: subheadingStyle.copyWith(fontSize: 13), textAlign: TextAlign.right),
                      ),
                    ],
                  ),
                  const Divider(height: 20),

                  _buildProductRow('SERUT'),
                  const SizedBox(height: 12),
                  _buildProductRow('10'),
                  const SizedBox(height: 12),
                  _buildProductRow('20'),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Total Summary
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: purple,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'TOTAL',
                    style: headingStyle.copyWith(fontSize: 18, color: white),
                  ),
                  Text(
                    NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0)
                        .format(getGrandTotal()),
                    style: headingStyle.copyWith(fontSize: 18, color: white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Save Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: saveSales,
                style: ElevatedButton.styleFrom(
                  backgroundColor: green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Simpan Penjualan',
                  style: headingStyle.copyWith(fontSize: 16, color: white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductRow(String product) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(product, style: subheadingStyle.copyWith(fontSize: 13)),
        ),
        Expanded(
          flex: 2,
          child: Container(
            height: 40,
            margin: const EdgeInsets.only(right: 8),
            child: TextField(
              controller: quantityControllers[product],
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13),
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
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0)
                .format(productPrices[product]),
            style: subheadingStyle.copyWith(fontSize: 12),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0)
                .format(getProductTotal(product)),
            style: headingStyle.copyWith(fontSize: 13, color: purple),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Widget _buildCustomerPicker() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Pilih Pelanggan', style: headingStyle.copyWith(fontSize: 18)),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: CustomerList.customers.length,
              itemBuilder: (context, index) {
                final customer = CustomerList.customers[index];
                return ListTile(
                  title: Text(customer.name, style: headingStyle.copyWith(fontSize: 14)),
                  subtitle: Text(customer.id, style: subheadingStyle.copyWith(fontSize: 12)),
                  trailing: Text(
                    NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0)
                        .format(customer.price),
                    style: subheadingStyle.copyWith(fontSize: 12, color: purple),
                  ),
                  onTap: () {
                    Navigator.pop(context, customer);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}