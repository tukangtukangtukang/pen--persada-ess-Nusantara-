// lib/ui/pages/customer_page.dart
import 'package:flutter/material.dart';
import 'package:pen/ui/theme/theme.dart';
import 'package:pen/data/model/Customer.dart';
import 'package:intl/intl.dart';

class CustomerPage extends StatefulWidget {
  const CustomerPage({super.key});

  @override
  State<CustomerPage> createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  List<Customer> customers = List.from(CustomerList.customers);
  String searchQuery = '';

  List<Customer> getFilteredCustomers() {
    if (searchQuery.isEmpty) return customers;
    
    return customers.where((customer) {
      return customer.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          customer.id.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();
  }

  void addCustomer() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CustomerFormPage(
          onSave: (customer) {
            setState(() {
              customers.add(customer);
            });
          },
        ),
      ),
    );
  }

  void editCustomer(Customer customer) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CustomerFormPage(
          customer: customer,
          onSave: (updatedCustomer) {
            setState(() {
              int index = customers.indexWhere((c) => c.id == customer.id);
              if (index != -1) {
                customers[index] = updatedCustomer;
              }
            });
          },
        ),
      ),
    );
  }

  void deleteCustomer(Customer customer) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Pelanggan'),
        content: Text('Apakah Anda yakin ingin menghapus ${customer.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                customers.removeWhere((c) => c.id == customer.id);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${customer.name} berhasil dihapus')),
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
    final filteredCustomers = getFilteredCustomers();
    
    return Scaffold(
      backgroundColor: lightGray,
      appBar: AppBar(
        backgroundColor: white,
        elevation: 1,
        title: Text('Data Pelanggan', style: headingStyle.copyWith(fontSize: 20)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addCustomer,
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
                hintText: 'Cari pelanggan...',
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
                  'Total: ${filteredCustomers.length} Pelanggan',
                  style: subheadingStyle.copyWith(fontSize: 14),
                ),
                Text(
                  'Tampil: ${filteredCustomers.length} dari ${customers.length}',
                  style: subheadingStyle.copyWith(fontSize: 12),
                ),
              ],
            ),
          ),
          
          // Customer List
          Expanded(
            child: filteredCustomers.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.people_outline, size: 64, color: gray.withOpacity(0.5)),
                        const SizedBox(height: 16),
                        Text(
                          'Tidak ada pelanggan ditemukan',
                          style: subheadingStyle.copyWith(fontSize: 14),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredCustomers.length,
                    itemBuilder: (context, index) {
                      final customer = filteredCustomers[index];
                      return _buildCustomerCard(customer);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerCard(Customer customer) {
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
            customer.name[0],
            style: headingStyle.copyWith(fontSize: 18, color: purple),
          ),
        ),
        title: Text(customer.name, style: headingStyle.copyWith(fontSize: 16)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(customer.id, style: subheadingStyle.copyWith(fontSize: 12)),
            const SizedBox(height: 4),
            Text(
              NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0)
                  .format(customer.price),
              style: subheadingStyle.copyWith(fontSize: 13, color: green),
            ),
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
                  () => editCustomer(customer),
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
                  () => deleteCustomer(customer),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Customer Form Page untuk Add/Edit
class CustomerFormPage extends StatefulWidget {
  final Customer? customer;
  final Function(Customer) onSave;

  const CustomerFormPage({
    super.key,
    this.customer,
    required this.onSave,
  });

  @override
  State<CustomerFormPage> createState() => _CustomerFormPageState();
}

class _CustomerFormPageState extends State<CustomerFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController nikController;
  late TextEditingController addressController;
  late TextEditingController googleMapsController;
  late TextEditingController priceController;
  
  bool isEdit = false;
  String customerId = '';

  @override
  void initState() {
    super.initState();
    isEdit = widget.customer != null;
    
    if (isEdit) {
      customerId = widget.customer!.id;
      nameController = TextEditingController(text: widget.customer!.name);
      nikController = TextEditingController(text: widget.customer!.nik);
      addressController = TextEditingController(text: widget.customer!.address);
      googleMapsController = TextEditingController(text: widget.customer!.googleMaps ?? '');
      priceController = TextEditingController(text: widget.customer!.price.toString());
    } else {
      // Generate new customer ID
      DateTime now = DateTime.now();
      int sequence = CustomerList.customers.length + 1;
      customerId = Customer.generateCustomerId(now, sequence);
      
      nameController = TextEditingController();
      nikController = TextEditingController();
      addressController = TextEditingController();
      googleMapsController = TextEditingController();
      priceController = TextEditingController(text: '12500');
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    nikController.dispose();
    addressController.dispose();
    googleMapsController.dispose();
    priceController.dispose();
    super.dispose();
  }

  void saveCustomer() {
    if (_formKey.currentState!.validate()) {
      final customer = Customer(
        id: customerId,
        name: nameController.text.toUpperCase(),
        nik: nikController.text,
        address: addressController.text,
        googleMaps: googleMapsController.text.isEmpty ? null : googleMapsController.text,
        price: double.parse(priceController.text),
      );
      
      widget.onSave(customer);
      Navigator.pop(context);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isEdit ? 'Pelanggan berhasil diupdate' : 'Pelanggan berhasil ditambahkan'),
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
          isEdit ? 'Edit Pelanggan' : 'Tambah Pelanggan',
          style: headingStyle.copyWith(fontSize: 20),
        ),
        actions: [
          IconButton(
            onPressed: saveCustomer,
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
              // Customer ID (Read-only)
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
                    Text('No. Pelanggan', style: subheadingStyle.copyWith(fontSize: 14)),
                    Text(
                      customerId,
                      style: headingStyle.copyWith(fontSize: 16, color: purple),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Form Fields
              Text('Nama Pelanggan *', style: headingStyle.copyWith(fontSize: 14)),
              const SizedBox(height: 8),
              TextFormField(
                controller: nameController,
                textCapitalization: TextCapitalization.characters,
                decoration: InputDecoration(
                  hintText: 'Masukkan nama pelanggan',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama pelanggan harus diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              Text('NIK', style: headingStyle.copyWith(fontSize: 14)),
              const SizedBox(height: 8),
              TextFormField(
                controller: nikController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'XXX-XXX-XXXXXX-XXXXX',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: white,
                ),
              ),
              const SizedBox(height: 16),
              
              Text('Alamat Depot', style: headingStyle.copyWith(fontSize: 14)),
              const SizedBox(height: 8),
              TextFormField(
                controller: addressController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Masukkan alamat depot',
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
                  hintText: 'https://maps.google.com/...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: white,
                  prefixIcon: const Icon(Icons.location_on),
                ),
              ),
              const SizedBox(height: 16),
              
              Text('Harga *', style: headingStyle.copyWith(fontSize: 14)),
              const SizedBox(height: 8),
              TextFormField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: '12500',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: white,
                  prefixText: 'Rp ',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harga harus diisi';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Harga harus berupa angka';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              
              // Save Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: saveCustomer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: purple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    isEdit ? 'Update Pelanggan' : 'Simpan Pelanggan',
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