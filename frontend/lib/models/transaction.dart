class Transaction {
  final String id;
  final String userId;
  final String type;
  final double amount;
  final String category;
  final DateTime date;
  final String? note;

  Transaction({
    required this.id,
    required this.userId,
    required this.type,
    required this.amount,
    required this.category,
    required this.date,
    this.note,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['_id'],
      userId: json['userId'],
      type: json['type'],
      amount: (json['amount'] as num).toDouble(),
      category: json['category'],
      date: DateTime.parse(json['date']),
      note: json['note'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'amount': amount,
      'category': category,
      'date': date.toIso8601String(),
      'note': note,
    };
  }
}
