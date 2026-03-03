class User {
  final String id;
  final String email;
  final double monthlyBudget;
  final Map<String, double> categoryBudgets;

  User({
    required this.id,
    required this.email,
    required this.monthlyBudget,
    required this.categoryBudgets,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      email: json['email'],
      monthlyBudget: (json['monthlyBudget'] as num).toDouble(),
      categoryBudgets: Map<String, double>.from(
        (json['categoryBudgets'] as Map).map(
          (key, value) => MapEntry(key, (value as num).toDouble()),
        ),
      ),
    );
  }
}
