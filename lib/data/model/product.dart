// lib/data/model/Product.dart
class Product {
  final String id;
  final String name;
  final double price;

  Product({
    required this.id,
    required this.name,
    required this.price,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: json['price'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
    };
  }
}

// Produk default
class ProductList {
  static final List<Product> products = [
    Product(id: 'SERUT', name: 'SERUT', price: 15000),
    Product(id: '10', name: '10', price: 7500),
    Product(id: '20', name: '20', price: 13000),
  ];

  static Product? getProductById(String id) {
    try {
      return products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }
}