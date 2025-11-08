// lib/data/model/Setoran.dart
class Setoran {
  final String id;
  final String customerId;
  final String customerName;
  final DateTime date;
  final int week; // W-1 sampai W-10
  final int kantong;
  final double rupiah;
  final double harga;

  Setoran({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.date,
    required this.week,
    required this.kantong,
    required this.rupiah,
    required this.harga,
  });

  factory Setoran.fromJson(Map<String, dynamic> json) {
    return Setoran(
      id: json['id'],
      customerId: json['customerId'],
      customerName: json['customerName'],
      date: DateTime.parse(json['date']),
      week: json['week'],
      kantong: json['kantong'],
      rupiah: json['rupiah'].toDouble(),
      harga: json['harga'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerId': customerId,
      'customerName': customerName,
      'date': date.toIso8601String(),
      'week': week,
      'kantong': kantong,
      'rupiah': rupiah,
      'harga': harga,
    };
  }

  // Generate setoran ID
  static String generateSetoranId() {
    return 'SET-${DateTime.now().millisecondsSinceEpoch}';
  }
}

// Week period helper
class WeekPeriod {
  static List<Map<String, dynamic>> getWeekPeriods(int month, int year) {
    List<Map<String, dynamic>> weeks = [];
    
    // Contoh untuk bulan Agustus 2025 seperti di PDF
    // W-1: 8/1, W-2: 8/4, W-3: 8/8, W-4: 8/11, W-5: 8/15, 
    // W-6: 8/19, W-7: 8/22, W-8: 8/25, W-9: 8/29, W-10: 9/1
    
    DateTime startDate = DateTime(year, month, 1);
    
    for (int i = 1; i <= 10; i++) {
      int dayOffset = (i - 1) * 3 + 1; // Setiap 3-4 hari
      DateTime weekDate = startDate.add(Duration(days: dayOffset));
      
      weeks.add({
        'week': i,
        'date': weekDate,
        'label': 'W-$i',
      });
    }
    
    return weeks;
  }

  static String getWeekLabel(int week) {
    return 'W-$week';
  }

  static int getCurrentWeek() {
    // Hitung minggu berdasarkan tanggal saat ini
    int dayOfMonth = DateTime.now().day;
    return ((dayOfMonth - 1) ~/ 3) + 1;
  }
}