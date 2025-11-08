// lib/data/model/Transaction.dart
class Transaction {
  final String id;
  final DateTime date;
  final String bankPengirim;
  final String bankPenerima;
  final String kodeTransaksi;
  final String namaBarang;
  final String merk;
  final String typeUkuran;
  final int jumlah;
  final String satuan;
  final double harga;
  final double total;
  final double ppn;
  final double grandTotal;
  final String supplier;

  Transaction({
    required this.id,
    required this.date,
    required this.bankPengirim,
    required this.bankPenerima,
    required this.kodeTransaksi,
    required this.namaBarang,
    required this.merk,
    required this.typeUkuran,
    required this.jumlah,
    required this.satuan,
    required this.harga,
    required this.total,
    required this.ppn,
    required this.grandTotal,
    required this.supplier,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      date: DateTime.parse(json['date']),
      bankPengirim: json['bankPengirim'],
      bankPenerima: json['bankPenerima'],
      kodeTransaksi: json['kodeTransaksi'],
      namaBarang: json['namaBarang'],
      merk: json['merk'],
      typeUkuran: json['typeUkuran'],
      jumlah: json['jumlah'],
      satuan: json['satuan'],
      harga: json['harga'].toDouble(),
      total: json['total'].toDouble(),
      ppn: json['ppn'].toDouble(),
      grandTotal: json['grandTotal'].toDouble(),
      supplier: json['supplier'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'bankPengirim': bankPengirim,
      'bankPenerima': bankPenerima,
      'kodeTransaksi': kodeTransaksi,
      'namaBarang': namaBarang,
      'merk': merk,
      'typeUkuran': typeUkuran,
      'jumlah': jumlah,
      'satuan': satuan,
      'harga': harga,
      'total': total,
      'ppn': ppn,
      'grandTotal': grandTotal,
      'supplier': supplier,
    };
  }

  static String generateTransactionId() {
    return 'TRX-${DateTime.now().millisecondsSinceEpoch}';
  }
}

// Bank list
class BankList {
  static const List<String> banks = [
    'BCA',
    'BNI',
    'BRI',
    'MANDIRI',
    'NIAGA',
    'OCBC',
    'PERMATA',
    'UOB',
  ];
}

// Satuan list
class SatuanList {
  static const List<String> satuans = [
    'kantong',
    'pcs',
    'pc',
    'set',
    'kg',
    'pail',
    'm',
    'rol',
    'liter',
    'unit',
  ];
}

// Kode Transaksi helper
class KodeTransaksiHelper {
  static Map<String, String> getKodeList() {
    return {
      '5-00000': 'PENJUALAN',
      '6-60000': 'SEWA MESIN',
      '6-60001': 'SEWA GEDUNG',
      '6-60002': 'LISTRIK',
      '6-60003': 'INVENTARIS KANTOR',
      '6-600040': 'PLASTIK',
      '6-600041': 'PLASTIK 10',
      '6-600042': 'PLASTIK 20',
      '6-600050': 'BBM MOBIL',
      '6-600051': 'BBM MOBIL 1',
      '6-600052': 'BBM MOBIL 2',
      '6-600055': 'BBM MOTOR',
      '6-600056': 'BBM MOTOR 1',
      '6-600057': 'BBM MOTOR 2',
      '6-600060': 'MAINTENANCE MOBIL',
      '6-600070': 'MAINTENANCE MOTOR',
      '6-600080': 'MAINTENANCE MESIN',
      '6-600090': 'MAINTENANCE GEDUNG',
      '6-601000': 'KARYAWAN OPERATOR',
      '6-601100': 'KARYAWAN SOPIR',
      '6-601200': 'KARYAWAN KENEK',
      '6-601201': 'KOMUNIKASI',
      '6-601210': 'ATK',
      '6-601230': 'CONSUMABLE KANTOR',
      '6-601300': 'IURAN BULANAN',
      '6-601400': 'IURAN TAHUNAN',
      '6-601500': 'BIAYA LAIN LAIN',
      '7-700000': 'BANK',
    };
  }

  static List<String> getKodeOptions() {
    return getKodeList().keys.toList();
  }

  static String getKodeDescription(String kode) {
    return getKodeList()[kode] ?? '';
  }
}