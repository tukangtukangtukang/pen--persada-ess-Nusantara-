// lib/ui/pages/supplier_page.dart
import 'package:flutter/material.dart';
import 'package:pen/ui/theme/theme.dart'; // Asumsi Anda punya file theme ini
import 'package:intl/intl.dart';

// --- Placeholder Model ---
// Sebaiknya pindahkan ke file model Anda (mis: lib/data/model/Supplier.dart)
enum PaymentType { DP, COD, TEMPO }

class Supplier {
  final String id;
  final String name;
  final String address;
  final String? googleMaps;
  final PaymentType paymentType;
  final bool isRutinHarian;
  final bool isRutinMingguan;
  final bool isRutinBulanan;

  Supplier({
    required this.id,
    required this.name,
    required this.address,
    this.googleMaps,
    this.paymentType = PaymentType.COD,
    this.isRutinHarian = false,
    this.isRutinMingguan = false,
    this.isRutinBulanan = false,
  });

  static String generateSupplierId(DateTime now, int sequence) {
    String year = now.year.toString().substring(2);
    String month = now.month.toString().padLeft(2, '0');
    String seq = sequence.toString().padLeft(3, '0');
    return 'SPL-$year$month-$seq';
  }
}

class SupplierList {
  static List<Supplier> suppliers = [
    Supplier(id: 'SPL-2511-001', name: 'P L N', address: 'Jl. Listrik', paymentType: PaymentType.TEMPO, isRutinBulanan: true),
    Supplier(id: 'SPL-2511-002', name: 'PLASTIK', address: 'Jl. Pabrik', paymentType: PaymentType.COD, isRutinMingguan: true),
    Supplier(id: 'SPL-2511-003', name: 'SPBU', address: 'Jl. Bensin', paymentType: PaymentType.DP),
  ];
}
// --- End of Placeholder Model ---


class SupplierPage extends StatefulWidget {
  const SupplierPage({super.key});

  @override
  State<SupplierPage> createState() => _SupplierPageState();
}

class _SupplierPageState extends State<SupplierPage> {
  List<Supplier> suppliers = List.from(SupplierList.suppliers);
  String searchQuery = '';

  List<Supplier> getFilteredSuppliers() {
    if (searchQuery.isEmpty) return suppliers;
    
    return suppliers.where((supplier) {
      return supplier.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          supplier.id.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();
  }

  void addSupplier() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SupplierFormPage(
          onSave: (supplier) {
            setState(() {
              suppliers.add(supplier);
            });
          },
        ),
      ),
    );
  }

  void editSupplier(Supplier supplier) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SupplierFormPage(
          supplier: supplier,
          onSave: (updatedSupplier) {
            setState(() {
              int index = suppliers.indexWhere((c) => c.id == supplier.id);
              if (index != -1) {
                suppliers[index] = updatedSupplier;
              }
            });
          },
        ),
      ),
    );
  }

  void deleteSupplier(Supplier supplier) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Supplier'),
        content: Text('Apakah Anda yakin ingin menghapus ${supplier.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                suppliers.removeWhere((c) => c.id == supplier.id);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${supplier.name} berhasil dihapus')),
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
    final filteredSuppliers = getFilteredSuppliers();
    
    return Scaffold(
      backgroundColor: lightGray,
      appBar: AppBar(
        backgroundColor: white,
        elevation: 1,
        title: Text('Data Supplier', style: headingStyle.copyWith(fontSize: 20)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addSupplier,
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
                hintText: 'Cari supplier...',
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
                  'Total: ${filteredSuppliers.length} Supplier',
                  style: subheadingStyle.copyWith(fontSize: 14),
                ),
                Text(
                  'Tampil: ${filteredSuppliers.length} dari ${suppliers.length}',
                  style: subheadingStyle.copyWith(fontSize: 12),
                ),
              ],
            ),
          ),
          
          // Supplier List
          Expanded(
            child: filteredSuppliers.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inventory_2_outlined, size: 64, color: gray.withOpacity(0.5)),
                        const SizedBox(height: 16),
                        Text(
                          'Tidak ada supplier ditemukan',
                          style: subheadingStyle.copyWith(fontSize: 14),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredSuppliers.length,
                    itemBuilder: (context, index) {
                      final supplier = filteredSuppliers[index];
                      return _buildSupplierCard(supplier);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupplierCard(Supplier supplier) {
    String paymentInfo = supplier.paymentType.name;
    if (supplier.isRutinHarian) paymentInfo += ' (Harian)';
    if (supplier.isRutinMingguan) paymentInfo += ' (Mingguan)';
    if (supplier.isRutinBulanan) paymentInfo += ' (Bulanan)';

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
          child: Text(
            supplier.name[0],
            style: headingStyle.copyWith(fontSize: 18, color: purple),
          ),
        ),
        title: Text(supplier.name, style: headingStyle.copyWith(fontSize: 16)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(supplier.id, style: subheadingStyle.copyWith(fontSize: 12)),
            const SizedBox(height: 4),
            Text(supplier.address, style: subheadingStyle.copyWith(fontSize: 13)),
            const SizedBox(height: 4),
            Text(paymentInfo, style: subheadingStyle.copyWith(fontSize: 13, color: green)),
          ],
        ),
        trailing: PopupMenuButton(
          icon: const Icon(Icons.more_vert),
          itemBuilder: (context) => [
            PopupMenuItem(
              child: Row(
                children: const [
                  Icon(Icons.edit, size: 20, color: amber),
                  SizedBox(width: 8),
                  Text('Edit'),
                ],
              ),
              onTap: () {
                Future.delayed(
                  Duration.zero,
                  () => editSupplier(supplier),
                );
              },
            ),
            PopupMenuItem(
              child: Row(
                children: const [
                  Icon(Icons.delete, size: 20, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Hapus'),
                ],
              ),
              onTap: () {
                Future.delayed(
                  Duration.zero,
                  () => deleteSupplier(supplier),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Supplier Form Page untuk Add/Edit
class SupplierFormPage extends StatefulWidget {
  final Supplier? supplier;
  final Function(Supplier) onSave;

  const SupplierFormPage({
    super.key,
    this.supplier,
    required this.onSave,
  });

  @override
  State<SupplierFormPage> createState() => _SupplierFormPageState();
}

class _SupplierFormPageState extends State<SupplierFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController addressController;
  late TextEditingController googleMapsController;
  
  PaymentType _paymentType = PaymentType.COD;
  bool _isRutinHarian = false;
  bool _isRutinMingguan = false;
  bool _isRutinBulanan = false;

  bool isEdit = false;
  String supplierId = '';

  @override
  void initState() {
    super.initState();
    isEdit = widget.supplier != null;
    
    if (isEdit) {
      supplierId = widget.supplier!.id;
      nameController = TextEditingController(text: widget.supplier!.name);
      addressController = TextEditingController(text: widget.supplier!.address);
      googleMapsController = TextEditingController(text: widget.supplier!.googleMaps ?? '');
      _paymentType = widget.supplier!.paymentType;
      _isRutinHarian = widget.supplier!.isRutinHarian;
      _isRutinMingguan = widget.supplier!.isRutinMingguan;
      _isRutinBulanan = widget.supplier!.isRutinBulanan;
    } else {
      DateTime now = DateTime.now();
      int sequence = SupplierList.suppliers.length + 1;
      supplierId = Supplier.generateSupplierId(now, sequence);
      
      nameController = TextEditingController();
      addressController = TextEditingController();
      googleMapsController = TextEditingController();
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    googleMapsController.dispose();
    super.dispose();
  }

  void saveSupplier() {
    if (_formKey.currentState!.validate()) {
      final supplier = Supplier(
        id: supplierId,
        name: nameController.text.toUpperCase(),
        address: addressController.text,
        googleMaps: googleMapsController.text.isEmpty ? null : googleMapsController.text,
        paymentType: _paymentType,
        isRutinHarian: _isRutinHarian,
        isRutinMingguan: _isRutinMingguan,
        isRutinBulanan: _isRutinBulanan,
      );
      
      widget.onSave(supplier);
      Navigator.pop(context);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isEdit ? 'Supplier berhasil diupdate' : 'Supplier berhasil ditambahkan'),
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
          isEdit ? 'Edit Supplier' : 'Tambah Supplier',
          style: headingStyle.copyWith(fontSize: 20),
        ),
        actions: [
          IconButton(
            onPressed: saveSupplier,
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
              // Supplier ID
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: purple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: purple),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('No. Supplier', style: subheadingStyle.copyWith(fontSize: 14)),
                    Text(
                      supplierId,
                      style: headingStyle.copyWith(fontSize: 16, color: purple),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Form Fields
              Text('Nama Supplier *', style: headingStyle.copyWith(fontSize: 14)),
              const SizedBox(height: 8),
              TextFormField(
                controller: nameController,
                textCapitalization: TextCapitalization.characters,
                decoration: InputDecoration(
                  hintText: 'Masukkan nama supplier',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama supplier harus diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              Text('Alamat Supplier', style: headingStyle.copyWith(fontSize: 14)),
              const SizedBox(height: 8),
              TextFormField(
                controller: addressController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Masukkan alamat supplier',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: white,
                ),
              ),
              const SizedBox(height: 16),
              
              Text('Google Maps Link', style: headingStyle.copyWith(fontSize: 14)),
              const SizedBox(height: 8),
              TextFormField(
                controller: googleMapsController,
                decoration: InputDecoration(
                  hintText: 'http://maps.google.com/...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: white,
                  prefixIcon: const Icon(Icons.location_on),
                ),
              ),
              const SizedBox(height: 16),
              
              // Pembayaran
              Text('Pembayaran', style: headingStyle.copyWith(fontSize: 14)),
              Column(
                children: PaymentType.values.map((type) {
                  return RadioListTile<PaymentType>(
                    title: Text(type.name),
                    value: type,
                    groupValue: _paymentType,
                    onChanged: (PaymentType? value) {
                      setState(() {
                        _paymentType = value!;
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              
              // Pembayaran Rutin
              Text('Pembayaran Rutin', style: headingStyle.copyWith(fontSize: 14)),
              CheckboxListTile(
                title: const Text('Harian'),
                value: _isRutinHarian,
                onChanged: (bool? value) {
                  setState(() {
                    _isRutinHarian = value!;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text('Mingguan'),
                value: _isRutinMingguan,
                onChanged: (bool? value) {
                  setState(() {
                    _isRutinMingguan = value!;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text('Bulanan'),
                value: _isRutinBulanan,
                onChanged: (bool? value) {
                  setState(() {
                    _isRutinBulanan = value!;
                  });
                },
              ),
              const SizedBox(height: 32),
              
              // Save Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: saveSupplier,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: purple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    isEdit ? 'Update Supplier' : 'Simpan Supplier',
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
}