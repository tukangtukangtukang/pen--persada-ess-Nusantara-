// lib/ui/pages/setoran_page.dart
import 'package:flutter/material.dart';
import 'package:pen/ui/theme/theme.dart'; // Asumsi Anda punya file theme ini
import 'package:intl/intl.dart';

class SetoranPage extends StatefulWidget {
  const SetoranPage({super.key});

  @override
  State<SetoranPage> createState() => _SetoranPageState();
}

class _SetoranPageState extends State<SetoranPage> {
  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController agenController = TextEditingController();
  final TextEditingController hargaController = TextEditingController();
  final TextEditingController noPelangganController = TextEditingController();
  final TextEditingController namaPelangganController = TextEditingController();
  final TextEditingController kantongSerutController = TextEditingController();
  final TextEditingController kantong10Controller = TextEditingController();
  final TextEditingController kantong20Controller = TextEditingController();
  
  double totalSetoran = 0;
  int totalKantong = 0;

  @override
  void initState() {
    super.initState();
    // Listener untuk kalkulasi otomatis
    hargaController.addListener(calculateTotal);
    kantongSerutController.addListener(calculateTotal);
    kantong10Controller.addListener(calculateTotal);
    kantong20Controller.addListener(calculateTotal);
  }

  @override
  void dispose() {
    agenController.dispose();
    hargaController.dispose();
    noPelangganController.dispose();
    namaPelangganController.dispose();
    kantongSerutController.dispose();
    kantong10Controller.dispose();
    kantong20Controller.dispose();
    super.dispose();
  }

  void calculateTotal() {
    double harga = double.tryParse(hargaController.text) ?? 0;
    int serut = int.tryParse(kantongSerutController.text) ?? 0;
    int k10 = int.tryParse(kantong10Controller.text) ?? 0;
    int k20 = int.tryParse(kantong20Controller.text) ?? 0;
    
    setState(() {
      totalKantong = serut + k10 + k20;
      // Berdasarkan CSV, "Rupiah" = KTG x Harga
      totalSetoran = (totalKantong * harga);
    });
  }

  void simpanSetoran() {
    if (_formKey.currentState!.validate()) {
      // Logika untuk menyimpan data setoran
      // ...
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Setoran berhasil disimpan')),
      );
      
      // Reset form
      _formKey.currentState!.reset();
      agenController.clear();
      hargaController.clear();
      noPelangganController.clear();
      namaPelangganController.clear();
      kantongSerutController.clear();
      kantong10Controller.clear();
      kantong20Controller.clear();
      setState(() {
        totalSetoran = 0;
        totalKantong = 0;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      backgroundColor: lightGray,
      appBar: AppBar(
        backgroundColor: white,
        elevation: 1,
        title: Text('Input Setoran', style: headingStyle.copyWith(fontSize: 20)),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Info Total
              Container(
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: purple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: purple),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total Setoran', style: subheadingStyle.copyWith(fontSize: 14)),
                    Text(
                      formatCurrency.format(totalSetoran),
                      style: headingStyle.copyWith(fontSize: 32, color: purple),
                    ),
                    const SizedBox(height: 8),
                    Text('Total Kantong: $totalKantong Ktg', style: subheadingStyle.copyWith(fontSize: 14)),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Form Fields
              _buildTextFormField(agenController, 'Agen', 'Masukkan nama agen'),
              _buildTextFormField(hargaController, 'Harga *', '0', isRequired: true, isNumber: true, prefix: 'Rp '),
              _buildTextFormField(noPelangganController, 'No. Pelanggan', 'P-YYMM-XXX'),
              _buildTextFormField(namaPelangganController, 'Nama Pelanggan', 'Masukkan nama pelanggan'),

              const SizedBox(height: 16),
              Text('Jumlah Kantong', style: headingStyle.copyWith(fontSize: 14)),
              const SizedBox(height: 8),

              Row(
                children: [
                  Expanded(
                    child: _buildTextFormField(kantongSerutController, 'Serut', '0', isNumber: true),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextFormField(kantong10Controller, '10', '0', isNumber: true),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextFormField(kantong20Controller, '20', '0', isNumber: true),
                  ),
                ],
              ),
              
              const SizedBox(height: 32),
              
              // Save Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: simpanSetoran,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Simpan Setoran',
                    style: headingStyle.copyWith(fontSize: 16, color: white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField(TextEditingController controller, String label, String hint, {bool isRequired = false, bool isNumber = false, String? prefix}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: headingStyle.copyWith(fontSize: 14)),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            keyboardType: isNumber ? TextInputType.number : TextInputType.text,
            decoration: InputDecoration(
              hintText: hint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: white,
              prefixText: prefix,
            ),
            validator: (value) {
              if (isRequired && (value == null || value.isEmpty)) {
                return '$label harus diisi';
              }
              if (isNumber && value != null && value.isNotEmpty && double.tryParse(value) == null) {
                return '$label harus berupa angka';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}