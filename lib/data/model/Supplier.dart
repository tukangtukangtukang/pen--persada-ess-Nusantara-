// lib/data/model/Supplier.dart
class Supplier {
  final String id;
  final String name;
  final String address;
  final String? googleMaps;
  final PaymentType paymentType;
  final PaymentPeriod paymentPeriod;
  final List<SupplierProduct> products;

  Supplier({
    required this.id,
    required this.name,
    required this.address,
    this.googleMaps,
    required this.paymentType,
    required this.paymentPeriod,
    this.products = const [],
  });

  factory Supplier.fromJson(Map<String, dynamic> json) {
    return Supplier(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      googleMaps: json['googleMaps'],
      paymentType: PaymentType.values.firstWhere(
        (e) => e.toString() == 'PaymentType.${json['paymentType']}',
      ),
      paymentPeriod: PaymentPeriod.values.firstWhere(
        (e) => e.toString() == 'PaymentPeriod.${json['paymentPeriod']}',
      ),
      products: (json['products'] as List?)
              ?.map((p) => SupplierProduct.fromJson(p))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'googleMaps': googleMaps,
      'paymentType': paymentType.toString().split('.').last,
      'paymentPeriod': paymentPeriod.toString().split('.').last,
      'products': products.map((p) => p.toJson()).toList(),
    };
  }

  // Generate supplier ID format: SPL-YYMM-001
  static String generateSupplierId(DateTime date, int sequence) {
    final yy = date.year.toString().substring(2);
    final mm = date.month.toString().padLeft(2, '0');
    final seq = sequence.toString().padLeft(3, '0');
    return 'SPL-$yy$mm-$seq';
  }
}

enum PaymentType {
  dp,    // DP (Down Payment)
  cod,   // COD (Cash on Delivery)
  tempo, // Tempo
}

enum PaymentPeriod {
  harian,    // Harian
  mingguan,  // Mingguan
  bulanan,   // Bulanan
}

class SupplierProduct {
  final String name;
  final String merk;
  final String type;
  final String satuan;
  final double price;

  SupplierProduct({
    required this.name,
    required this.merk,
    required this.type,
    required this.satuan,
    required this.price,
  });

  factory SupplierProduct.fromJson(Map<String, dynamic> json) {
    return SupplierProduct(
      name: json['name'],
      merk: json['merk'],
      type: json['type'],
      satuan: json['satuan'],
      price: json['price'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'merk': merk,
      'type': type,
      'satuan': satuan,
      'price': price,
    };
  }
}

// Helper functions
extension PaymentTypeExtension on PaymentType {
  String get label {
    switch (this) {
      case PaymentType.dp:
        return 'DP';
      case PaymentType.cod:
        return 'COD';
      case PaymentType.tempo:
        return 'TEMPO';
    }
  }
}

extension PaymentPeriodExtension on PaymentPeriod {
  String get label {
    switch (this) {
      case PaymentPeriod.harian:
        return 'Harian';
      case PaymentPeriod.mingguan:
        return 'Mingguan';
      case PaymentPeriod.bulanan:
        return 'Bulanan';
    }
  }
}