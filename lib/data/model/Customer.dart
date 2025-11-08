// lib/data/model/Customer.dart
class Customer {
  final String id;
  final String name;
  final String nik;
  final String address;
  final String? googleMaps;
  final double price;

  Customer({
    required this.id,
    required this.name,
    required this.nik,
    required this.address,
    this.googleMaps,
    required this.price,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      name: json['name'],
      nik: json['nik'],
      address: json['address'],
      googleMaps: json['googleMaps'],
      price: json['price'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'nik': nik,
      'address': address,
      'googleMaps': googleMaps,
      'price': price,
    };
  }

  // Generate customer ID format: P-YYMM-001
  static String generateCustomerId(DateTime date, int sequence) {
    final yy = date.year.toString().substring(2);
    final mm = date.month.toString().padLeft(2, '0');
    final seq = sequence.toString().padLeft(3, '0');
    return 'P-$yy$mm-$seq';
  }
}

// Default customer list from PDF
class CustomerList {
  static final List<Customer> customers = [
    Customer(id: 'P-2404-001', name: 'CIKARANG', nik: '', address: '', price: 12000),
    Customer(id: 'P-2404-002', name: 'HENDAR', nik: '', address: '', price: 12000),
    Customer(id: 'P-2404-003', name: 'AGUS', nik: '', address: '', price: 12500),
    Customer(id: 'P-2404-004', name: 'AHMAD', nik: '', address: '', price: 12500),
    Customer(id: 'P-2404-005', name: 'AMIN', nik: '', address: '', price: 12500),
    Customer(id: 'P-2404-006', name: 'DELTA', nik: '', address: '', price: 12500),
    Customer(id: 'P-2404-007', name: 'JENGGOT', nik: '', address: '', price: 12500),
    Customer(id: 'P-2404-008', name: 'FAHMI', nik: '', address: '', price: 12500),
    Customer(id: 'P-2404-009', name: 'GLX GARDEN', nik: '', address: '', price: 12500),
    Customer(id: 'P-2404-010', name: 'GLX GEREJA', nik: '', address: '', price: 12500),
    Customer(id: 'P-2404-011', name: 'GOR STADION', nik: '', address: '', price: 12500),
    Customer(id: 'P-2404-012', name: 'JALAN BARU', nik: '', address: '', price: 12500),
    Customer(id: 'P-2407-001', name: 'KARANG KITRI', nik: '', address: '', price: 12500),
    Customer(id: 'P-2407-002', name: 'KEMAKMURAN', nik: '', address: '', price: 12500),
    Customer(id: 'P-2407-003', name: 'NUSA INDAH', nik: '', address: '', price: 12500),
    Customer(id: 'P-2408-001', name: 'MARTA LAKSANA', nik: '', address: '', price: 12500),
    Customer(id: 'P-2408-002', name: 'MITRA TIMUR', nik: '', address: '', price: 12500),
    Customer(id: 'P-2408-003', name: 'MUSTIKA', nik: '', address: '', price: 12500),
    Customer(id: 'P-2409-001', name: 'PENGASINAN', nik: '', address: '', price: 12500),
    Customer(id: 'P-2409-002', name: 'WAHIT', nik: '', address: '', price: 12500),
    Customer(id: 'P-2410-001', name: 'EMENG', nik: '', address: '', price: 13000),
    Customer(id: 'P-2410-002', name: 'JATIMULYA', nik: '', address: '', price: 13000),
    Customer(id: 'P-2410-003', name: 'JEKY', nik: '', address: '', price: 13000),
    Customer(id: 'P-2410-004', name: 'LUXURIUS', nik: '', address: '', price: 13000),
    Customer(id: 'P-2410-005', name: 'MINUMAN', nik: '', address: '', price: 13000),
    Customer(id: 'P-2410-006', name: 'MUTIARA', nik: '', address: '', price: 13000),
    Customer(id: 'P-2410-007', name: 'PERMAI', nik: '', address: '', price: 13000),
    Customer(id: 'P-2410-008', name: 'PONDOK HIJAU', nik: '', address: '', price: 13000),
    Customer(id: 'P-2410-009', name: 'RAWA BAMBU', nik: '', address: '', price: 13000),
    Customer(id: 'P-2411-001', name: 'RETAIL A', nik: '', address: '', price: 15000),
    Customer(id: 'P-2411-002', name: 'RETAIL B', nik: '', address: '', price: 15000),
    Customer(id: 'P-2411-003', name: 'ZAMRUD', nik: '', address: '', price: 12500),
  ];

  static Customer? getCustomerById(String id) {
    try {
      return customers.firstWhere((customer) => customer.id == id);
    } catch (e) {
      return null;
    }
  }

  static Customer? getCustomerByName(String name) {
    try {
      return customers.firstWhere(
        (customer) => customer.name.toLowerCase() == name.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }
}