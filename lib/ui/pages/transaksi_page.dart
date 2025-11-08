// lib/ui/pages/transaksi_page.dart
import 'package:flutter/material.dart';
import 'package:pen/ui/theme/theme.dart'; // Asumsi Anda punya file theme ini
import 'package:intl/intl.dart';

// --- Placeholder Model ---
// Sebaiknya pindahkan ke file model Anda (mis: lib/data/model/Transaction.dart)
class Transaksi {
  final String id;
  final DateTime tanggal;
  final String namaBarang;
  final String supplier;
  final double jumlah;
  final double harga;
  final double ppn;
  
  Transaksi({
    required this.id,
    required this.tanggal,
    required this.namaBarang,
    required this.supplier,
    required this.jumlah,
    required this.harga,
    this.ppn = 0.0,
  });

  double get total => jumlah * harga;
  double get grandTotal => total + (total * ppn / 100);

  static String generateTransaksiId(DateTime now, int sequence) {
    String year = now.year.toString().substring(2);
    String month = now.month.toString().padLeft(2, '0');
    String day = now.day.toString().padLeft(2, '0');
    String seq = sequence.toString().padLeft(3, '0');
    return 'TR-$year$month$day-$seq';
  }
}

class TransaksiList {
  static List<Transaksi> transactions = [
    Transaksi(id: 'TR-251108-001', tanggal: DateTime.now(), namaBarang: 'BIJI PLASTIK', supplier: 'PLASTIK', jumlah: 100, harga: 15000, ppn: 11),
    Transaksi(id: 'TR-251108-002', tanggal: DateTime.now(), namaBarang: 'SOLAR', supplier: 'SPBU', jumlah: 50, harga: 12000),
  ];
}
// --- End of Placeholder Model ---

class TransaksiPage extends StatefulWidget {
  const TransaksiPage({super.key});

  @override
  State<TransaksiPage> createState() => _TransaksiPageState();
}

class _TransaksiPageState extends State<TransaksiPage> {
  List<Transaksi> transactions = List.from(TransaksiList.transactions);
  String searchQuery = '';

  List<Transaksi> getFilteredTransactions() {
    if (searchQuery.isEmpty) return transactions;
    
    return transactions.where((trx) {
      return trx.namaBarang.toLowerCase().contains(searchQuery.toLowerCase()) ||
          trx.supplier.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();
  }

  void addTransaksi() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TransaksiFormPage(
          onSave: (trx) {
            setState(() {
              transactions.add(trx);
            });
          },
        ),
      ),
    );
  }

  void editTransaksi(Transaksi trx) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TransaksiFormPage(
          transaksi: trx,
          onSave: (updatedTrx) {
            setState(() {
              int index = transactions.indexWhere((t) => t.id == trx.id);
              if (index != -1) {
                transactions[index] = updatedTrx;
              }
            });
          },
        ),
      ),
    );
  }

  void deleteTransaksi(Transaksi trx) {
     showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Transaksi'),
        content: Text('Apakah Anda yakin ingin menghapus ${trx.namaBarang}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                transactions.removeWhere((t) => t.id == trx.id);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Transaksi ${trx.namaBarang} berhasil dihapus')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredTransactions = getFilteredTransactions();
    final formatCurrency = NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      backgroundColor: lightGray,
      appBar: AppBar(
        backgroundColor: white,
        elevation: 1,
        title: Text('Data Transaksi', style: headingStyle.copyWith(fontSize: 20)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addTransaksi,
        backgroundColor: purple,
        child: const Icon(Icons.add, color: white),
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            color: white,
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Cari nama barang atau supplier...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: gray.withOpacity(0.3)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: gray.withOpacity(0.3)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: purple),
                ),
                filled: true,
                fillColor: lightGray,
              ),
            ),
          ),
          
          // Summary
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: white,
            margin: const EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total: ${filteredTransactions.length} Transaksi',
                  style: subheadingStyle.copyWith(fontSize: 14),
                ),
              ],
            ),
          ),
          
          // Transaction List
          Expanded(
            child: filteredTransactions.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.receipt_long_outlined, size: 64, color: gray.withOpacity(0.5)),
                        const SizedBox(height: 16),
                        Text(
                          'Tidak ada transaksi ditemukan',
                          style: subheadingStyle.copyWith(fontSize: 14),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredTransactions.length,
                    itemBuilder: (context, index) {
                      final trx = filteredTransactions[index];
                      return _buildTransaksiCard(trx, formatCurrency);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransaksiCard(Transaksi trx, NumberFormat formatCurrency) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: purple.withOpacity(0.1),
          child: const Icon(Icons.receipt, color: purple),
        ),
        title: Text(trx.namaBarang, style: headingStyle.copyWith(fontSize: 16)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('Supplier: ${trx.supplier}', style: subheadingStyle.copyWith(fontSize: 12)),
            const SizedBox(height: 4),
            Text(DateFormat('dd MMM yyyy').format(trx.tanggal), style: subheadingStyle.copyWith(fontSize: 12)),
             const SizedBox(height: 4),
            Text(
              '${trx.jumlah} x ${formatCurrency.format(trx.harga)}',
              style: subheadingStyle.copyWith(fontSize: 13),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
             Text(
              formatCurrency.format(trx.grandTotal), 
              style: headingStyle.copyWith(fontSize: 14, color: green)
            ),
            if (trx.ppn > 0)
              Text(
                '(termasuk PPN ${trx.ppn}%)', 
                style: subheadingStyle.copyWith(fontSize: 10, color: gray)
              ),
            // We use a SizedBox to align with PopupMenuButton's tap target
            const SizedBox(height: 24) 
          ],
        ),
        onTap: () => editTransaksi(trx),
      ),
    );
  }
}


// Transaksi Form Page untuk Add/Edit
class TransaksiFormPage extends StatefulWidget {
  final Transaksi? transaksi;
  final Function(Transaksi) onSave;

  const TransaksiFormPage({
    super.key,
    this.transaksi,
    required this.onSave,
  });

  @override
  State<TransaksiFormPage> createState() => _TransaksiFormPageState();
}

class _TransaksiFormPageState extends State<TransaksiFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController namaBarangController;
  late TextEditingController supplierController;
  late TextEditingController jumlahController;
  late TextEditingController hargaController;
  late TextEditingController ppnController;

  // Untuk dropdown
  List<String> bankList = ["BCA", "BNI", "BRI", "Mandiri", "Niaga", "OCBC", "Permata", "UOB"];
  List<String> satuanList = ["Kantong", "Pcs", "Set", "Kg", "Pail", "M", "Rol", "Dll"];
  
  String? selectedBankPengirim = "BCA";
  String? selectedBankPenerima = "BCA";
  String? selectedSatuan = "Kg";

  bool isEdit = false;
  String transaksiId = '';
  DateTime tanggal = DateTime.now();

  @override
  void initState() {
    super.initState();
    isEdit = widget.transaksi != null;
    
    if (isEdit) {
      transaksiId = widget.transaksi!.id;
      tanggal = widget.transaksi!.tanggal;
      namaBarangController = TextEditingController(text: widget.transaksi!.namaBarang);
      supplierController = TextEditingController(text: widget.transaksi!.supplier);
      jumlahController = TextEditingController(text: widget.transaksi!.jumlah.toString());
      hargaController = TextEditingController(text: widget.transaksi!.harga.toString());
      ppnController = TextEditingController(text: widget.transaksi!.ppn.toString());
    } else {
      int sequence = TransaksiList.transactions.length + 1;
      transaksiId = Transaksi.generateTransaksiId(tanggal, sequence);
      
      namaBarangController = TextEditingController();
      supplierController = TextEditingController();
      jumlahController = TextEditingController();
      hargaController = TextEditingController();
      ppnController = TextEditingController(text: '11.0'); // Default PPN 11%
    }
  }

  @override
  void dispose() {
    namaBarangController.dispose();
    supplierController.dispose();
    jumlahController.dispose();
    hargaController.dispose();
    ppnController.dispose();
    super.dispose();
  }

  void saveTransaksi() {
    if (_formKey.currentState!.validate()) {
      final trx = Transaksi(
        id: transaksiId,
        tanggal: tanggal,
        namaBarang: namaBarangController.text.toUpperCase(),
        supplier: supplierController.text.toUpperCase(), // Seharusnya ini dropdown dari data supplier
        jumlah: double.tryParse(jumlahController.text) ?? 0,
        harga: double.tryParse(hargaController.text) ?? 0,
        ppn: double.tryParse(ppnController.text) ?? 0,
      );
      
      widget.onSave(trx);
      Navigator.pop(context);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isEdit ? 'Transaksi berhasil diupdate' : 'Transaksi berhasil ditambahkan'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGray,
      appBar: AppBar(
        backgroundColor: white,
        elevation: 1,
        title: Text(
          isEdit ? 'Edit Transaksi' : 'Tambah Transaksi',
          style: headingStyle.copyWith(fontSize: 20),
        ),
        actions: [
          IconButton(
            onPressed: saveTransaksi,
            icon: const Icon(Icons.check, color: green),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Transaksi ID & Tanggal
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
                        Text('No. Transaksi', style: subheadingStyle.copyWith(fontSize: 14)),
                        Text(
                          transaksiId,
                          style: headingStyle.copyWith(fontSize: 16, color: purple),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                     Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Tanggal', style: subheadingStyle.copyWith(fontSize: 14)),
                        Text(
                          DateFormat('dd MMMM yyyy').format(tanggal),
                          style: headingStyle.copyWith(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Form Fields
              _buildTextFormField(namaBarangController, 'Nama Barang *', 'Masukkan nama barang', isRequired: true),
              _buildTextFormField(supplierController, 'Supplier *', 'Masukkan nama supplier', isRequired: true), // Idealnya Dropdown

              // Bank
              _buildDropdown('Bank Pengirim', bankList, selectedBankPengirim, (val) {
                setState(() => selectedBankPengirim = val);
              }),
              _buildDropdown('Bank Penerima', bankList, selectedBankPenerima, (val) {
                setState(() => selectedBankPenerima = val);
              }),
              
              Row(
                children: [
                  Expanded(
                    child: _buildTextFormField(jumlahController, 'Jumlah *', '0', isRequired: true, isNumber: true),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDropdown('Satuan', satuanList, selectedSatuan, (val) {
                      setState(() => selectedSatuan = val);
                    }),
                  ),
                ],
              ),
              
              _buildTextFormField(hargaController, 'Harga *', '0', isRequired: true, isNumber: true, prefix: 'Rp '),
              _buildTextFormField(ppnController, 'PPN (%)', '0', isNumber: true, suffix: '%'),
              
              const SizedBox(height: 32),
              
              // Save Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: saveTransaksi,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: purple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    isEdit ? 'Update Transaksi' : 'Simpan Transaksi',
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

  Widget _buildTextFormField(TextEditingController controller, String label, String hint, {bool isRequired = false, bool isNumber = false, String? prefix, String? suffix}) {
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
            textCapitalization: isNumber ? TextCapitalization.none : TextCapitalization.characters,
            decoration: InputDecoration(
              hintText: hint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: white,
              prefixText: prefix,
              suffixText: suffix,
            ),
            validator: (value) {
              if (isRequired && (value == null || value.isEmpty)) {
                return '$label harus diisi';
              }
              if (isNumber && double.tryParse(value!) == null) {
                return '$label harus berupa angka';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

    Widget _buildDropdown(String label, List<String> items, String? selectedValue, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: headingStyle.copyWith(fontSize: 14)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: selectedValue,
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: onChanged,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: white,
            ),
          ),
        ],
      ),
    );
  }
}