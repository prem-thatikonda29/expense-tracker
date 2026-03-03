import 'package:flutter/material.dart';
import '../../services/user_service.dart';
import '../home/dashboard_screen.dart';

class OnboardingScreen extends StatefulWidget {
  static const routeName = '/onboarding';

  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  // Color Constants
  static const Color primaryBlue = Color(0xFF137FEC);
  static const Color backgroundLight = Color(0xFFF6F7F8);
  static const Color surfaceWhite = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textMedium = Color(0xFF64748B);
  static const Color textLight = Color(0xFF94A3B8);
  static const Color borderColor = Color(0xFFE2E8F0);
  static const Color accentLight = Color(0xFFF0F7FF);

  final PageController _pageController = PageController();
  final _monthlyBudgetController = TextEditingController();
  final Map<String, TextEditingController> _categoryControllers = {};
  // Default categories for onboarding
  final List<String> _categories = [
    'Food',
    'Transport',
    'Shopping',
    'Entertainment',
    'Bills',
    'Education',
    'Health',
    'Other',
  ];

  final UserService _userService = UserService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    for (var category in _categories) {
      _categoryControllers[category] = TextEditingController();
    }
    _pageController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _monthlyBudgetController.dispose();
    for (var controller in _categoryControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _saveMonthlyBudgetAndContinue() async {
    final amount = double.tryParse(_monthlyBudgetController.text);
    if (amount != null && amount > 0) {
      setState(() {
        _isLoading = true;
      });
      try {
        await _userService.updateMonthlyBudget(amount);
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Failed to save budget')));
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
    if (mounted) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _finishOnboarding() async {
    setState(() {
      _isLoading = true;
    });

    final Map<String, double> budgets = {};
    _categoryControllers.forEach((key, controller) {
      if (controller.text.isNotEmpty) {
        final val = double.tryParse(controller.text);
        if (val != null && val > 0) {
          budgets[key] = val;
        }
      }
    });

    if (budgets.isNotEmpty) {
      try {
        await _userService.updateCategoryBudgets(budgets);
      } catch (e) {
        // Continue anyway if category save fails, user can try again in settings
      }
    }

    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed(DashboardScreen.routeName);
  }

  void _skipOnboarding() {
    Navigator.of(context).pushReplacementNamed(DashboardScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundLight,
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [_buildMonthlyBudgetStep(), _buildCategoryBudgetStep()],
        ),
      ),
    );
  }

  Widget _buildMonthlyBudgetStep() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            // Progress Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Step 1 of 2',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: primaryBlue,
                    letterSpacing: 0.5,
                  ),
                ),
                TextButton(
                  onPressed: _skipOnboarding,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                  ),
                  child: const Text(
                    'Skip',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: textLight,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Progress Bar
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: LinearProgressIndicator(
                value: 0.5,
                minHeight: 4,
                backgroundColor: borderColor,
                valueColor: const AlwaysStoppedAnimation<Color>(primaryBlue),
              ),
            ),
            const SizedBox(height: 32),
            // Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: accentLight,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Center(
                child: Icon(Icons.savings, size: 40, color: primaryBlue),
              ),
            ),
            const SizedBox(height: 32),
            // Title
            RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: textDark,
                  height: 1.2,
                ),
                children: [
                  TextSpan(text: 'Set Your\nMonthly '),
                  TextSpan(
                    text: 'Budget',
                    style: TextStyle(color: primaryBlue),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Description
            const Text(
              'Tracking starts with a goal. How much do you want to spend this month? You can change this later.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: textMedium, height: 1.5),
            ),
            const SizedBox(height: 48),
            // Input Field
            Column(
              children: [
                const Text(
                  'MONTHLY LIMIT (₹)',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: textLight,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: surfaceWhite,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: borderColor, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _monthlyBudgetController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: textDark,
                    ),
                    decoration: InputDecoration(
                      prefixText: '₹ ',
                      prefixStyle: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w600,
                        color: textLight,
                      ),
                      hintText: '5,000',
                      hintStyle: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: borderColor,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Helper Text
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.lock, size: 14, color: textLight),
                SizedBox(width: 6),
                Text(
                  'Private to you',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: textLight,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 48),
            // Quick Chips
            SizedBox(
              height: 44,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildChip('₹ 3k', false, () {
                    _monthlyBudgetController.text = '3000';
                  }),
                  _buildChip('₹ 5k', true, () {
                    _monthlyBudgetController.text = '5000';
                  }),
                  _buildChip('₹ 8k', false, () {
                    _monthlyBudgetController.text = '8000';
                  }),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Continue Button
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: primaryBlue.withValues(alpha: 0.3),
                    blurRadius: 16,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveMonthlyBudgetAndContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    disabledBackgroundColor: primaryBlue,
                    foregroundColor: surfaceWhite,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              surfaceWhite,
                            ),
                          ),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Continue',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward, size: 20),
                          ],
                        ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Skip Button
            TextButton(
              onPressed: _skipOnboarding,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text(
                "I'll set this later",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: textMedium,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String label, bool isActive, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: isActive ? accentLight : surfaceWhite,
            border: Border.all(
              color: isActive ? primaryBlue : borderColor,
              width: isActive ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isActive ? primaryBlue : textMedium,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryBudgetStep() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            // Progress Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Step 2 of 2',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: primaryBlue,
                    letterSpacing: 0.5,
                  ),
                ),
                TextButton(
                  onPressed: _skipOnboarding,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                  ),
                  child: const Text(
                    'Skip',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: textLight,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Progress Bar
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: const LinearProgressIndicator(
                value: 1.0,
                minHeight: 4,
                backgroundColor: borderColor,
                valueColor: AlwaysStoppedAnimation<Color>(primaryBlue),
              ),
            ),
            const SizedBox(height: 32),
            // Title
            const Text(
              'Set Category Budgets',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: textDark,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Totally optional! You can set these later.',
              style: TextStyle(fontSize: 14, color: textMedium),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            // Categories List
            Column(
              children: [
                ..._categories.map((category) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: surfaceWhite,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              category,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: textDark,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 100,
                            child: TextField(
                              controller: _categoryControllers[category],
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.right,
                              decoration: InputDecoration(
                                prefixText: '₹ ',
                                hintText: '0',
                                hintStyle: const TextStyle(color: textLight),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(
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
                    ),
                  );
                }),
              ],
            ),
            const SizedBox(height: 24),
            // Finish Button
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: primaryBlue.withValues(alpha: 0.3),
                    blurRadius: 16,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _finishOnboarding,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    disabledBackgroundColor: primaryBlue,
                    foregroundColor: surfaceWhite,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              surfaceWhite,
                            ),
                          ),
                        )
                      : const Text(
                          'Finish',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
