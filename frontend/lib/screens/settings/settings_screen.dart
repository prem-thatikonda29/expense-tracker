import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../services/user_service.dart';
import '../auth/login_screen.dart';

class SettingsScreen extends StatefulWidget {
  static const routeName = '/settings';

  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Color Constants
  static const Color primaryBlue = Color(0xFF137FEC);
  static const Color backgroundLight = Color(0xFFF6F7F8);
  static const Color surfaceWhite = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textLight = Color(0xFF94A3B8);
  static const Color borderColor = Color(0xFFE2E8F0);
  static const Color dangerColor = Color(0xFFEF4444);

  final _monthlyBudgetController = TextEditingController();
  final Map<String, TextEditingController> _categoryControllers = {};
  final List<String> _categories = [];

  final AuthService _authService = AuthService();
  final UserService _userService = UserService();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  @override
  void dispose() {
    _monthlyBudgetController.dispose();
    for (var controller in _categoryControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _fetchUserProfile() async {
    try {
      final user = await _authService.fetchUserProfile();
      _monthlyBudgetController.text = user.monthlyBudget.toString();
      user.categoryBudgets.forEach((key, value) {
        if (!_categories.contains(key)) {
          _categories.add(key);
        }
        _categoryControllers.putIfAbsent(key, () => TextEditingController());
        _categoryControllers[key]!.text = value.toString();
      });
    } catch (e) {
      // debugPrint('Error fetching user profile: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _saveCategoryBudgets() async {
    final Map<String, double> budgets = {};
    _categoryControllers.forEach((key, controller) {
      if (controller.text.isNotEmpty) {
        budgets[key] = double.tryParse(controller.text) ?? 0.0;
      }
    });

    try {
      await _userService.updateCategoryBudgets(budgets);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Category budgets updated')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update category budgets')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundLight,
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Settings',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: textDark,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Monthly Budget Section
                      Container(
                        decoration: BoxDecoration(
                          color: surfaceWhite,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: borderColor, width: 1),
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: primaryBlue.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.account_balance_wallet,
                                      color: primaryBlue,
                                      size: 22,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  'Monthly Budget',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: textDark,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: _monthlyBudgetController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                prefixText: '₹ ',
                                hintText: 'Enter amount',
                                hintStyle: const TextStyle(color: textLight),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: borderColor,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: borderColor,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: primaryBlue,
                                    width: 2,
                                  ),
                                ),
                              ),
                              style: const TextStyle(
                                color: textDark,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () async {
                                  final amount = double.tryParse(
                                    _monthlyBudgetController.text,
                                  );
                                  if (amount != null) {
                                    try {
                                      await _userService.updateMonthlyBudget(
                                        amount,
                                      );
                                      if (!context.mounted) return;
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text('Budget updated'),
                                        ),
                                      );
                                    } catch (e) {
                                      if (!context.mounted) return;
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Failed to update budget',
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                },
                                icon: const Icon(Icons.save, size: 18),
                                label: const Text('Save Budget'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryBlue,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Category Budgets Section
                      Container(
                        decoration: BoxDecoration(
                          color: surfaceWhite,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: borderColor, width: 1),
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: primaryBlue.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.category,
                                      color: primaryBlue,
                                      size: 22,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  'Category Budgets',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: textDark,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            ..._categories.map((category) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        category,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: textDark,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: TextField(
                                        controller:
                                            _categoryControllers[category],
                                        keyboardType: TextInputType.number,
                                        textAlign: TextAlign.right,
                                        decoration: InputDecoration(
                                          prefixText: '₹ ',
                                          hintText: '0',
                                          hintStyle: const TextStyle(
                                            color: textLight,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            borderSide: const BorderSide(
                                              color: borderColor,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            borderSide: const BorderSide(
                                              color: borderColor,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            borderSide: const BorderSide(
                                              color: primaryBlue,
                                              width: 2,
                                            ),
                                          ),
                                          isDense: true,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                vertical: 8,
                                                horizontal: 8,
                                              ),
                                        ),
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: textDark,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: _saveCategoryBudgets,
                                icon: const Icon(Icons.save, size: 18),
                                label: const Text('Save Category Budgets'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryBlue,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Logout Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            await _authService.logout();
                            if (!context.mounted) return;
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              LoginScreen.routeName,
                              (route) => false,
                            );
                          },
                          icon: const Icon(Icons.logout, size: 18),
                          label: const Text('Logout'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: dangerColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
