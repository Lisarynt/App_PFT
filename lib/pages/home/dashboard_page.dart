import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/transaction_provider.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';

// Import animations
import '../../widgets/animations/fade_in_slide.dart';
import '../../widgets/animations/bouncy_card.dart';
import '../../widgets/animations/animated_number.dart';
import '../../widgets/animations/pixel_fab.dart';
import '../../widgets/animations/rotating_icon.dart';
import '../../widgets/animations/bouncing_icon.dart';

import '../transactions/transactions_list_page.dart';
import '../transactions/add_transaction_page.dart';
import '../reports/category_report_page.dart';
import '../reports/period_report_page.dart';
import '../budget/budget_planning_page.dart';
import '../profile/profile_page.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const DashboardPage(),
    const TransactionsListScreen(),
    const CategoryReportScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final transactionProvider =
        Provider.of<TransactionProvider>(context, listen: false);

    if (authProvider.user != null) {
      transactionProvider.getTransactions(authProvider.user!.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      // PIXEL BOTTOM NAV
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: AppColors.black,
              width: AppConstants.pixelBorderWidth,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textLight,
          selectedLabelStyle: PixelTextStyles.caption,
          unselectedLabelStyle: PixelTextStyles.caption,
          selectedFontSize: AppConstants.fontSizeS,
          unselectedFontSize: AppConstants.fontSizeS,
          elevation: 0,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home, size: 28),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long, size: 28),
              label: 'Transaksi',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart, size: 28),
              label: 'Laporan',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person, size: 28),
              label: 'Profil',
            ),
          ],
        ),
      ),
      // PIXEL FAB WITH ANIMATION
      floatingActionButton: _currentIndex == 0 || _currentIndex == 1
          ? PixelFAB(
              backgroundColor: AppColors.expense,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddTransactionScreen(),
                  ),
                );
              },
            )
          : null,
    );
  }
}

//
// ======================
// DASHBOARD HOME PAGE
// ======================
//

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final transactionProvider = Provider.of<TransactionProvider>(context);

    final totalIncome = transactionProvider.getTotalIncome();
    final totalExpense = transactionProvider.getTotalExpense();
    final balance = transactionProvider.getBalance();

    return Scaffold(
      body: PixelBackgroundApp(  // ← BACKGROUND IMAGE
        child: SafeArea(
          child: Stack(
            children: [
              // DECORATIVE ICONS
              Positioned(
                top: 15,
                right: 50,
                child: RotatingIcon(emoji: '☀️', fontSize: 40),
              ),

              // MAIN CONTENT
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // HEADER
                    Padding(
                      padding: EdgeInsets.all(AppConstants.spacingXL),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FadeInSlide(
                            delay: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      Helpers.getGreeting(),
                                      style: PixelTextStyles.bodyLight,
                                    ),
                                    SizedBox(height: AppConstants.spacingXS),
                                    Text(
                                      authProvider.userModel?.name ?? 'User',
                                      style: PixelTextStyles.h2,
                                    ),
                                  ],
                                ),
                                _buildPixelIconButton(
                                  icon: Icons.notifications,
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: AppConstants.spacingXL),

                          // BALANCE CARD
                          FadeInSlide(
                            delay: 200,
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(AppConstants.spacingXL),
                              decoration: PixelDecorations.pixelCard(),
                              child: Column(
                                children: [
                                  BouncingIcon(emoji: '💰', fontSize: 40),
                                  SizedBox(height: AppConstants.spacingS),
                                  Text(
                                    'Total Saldo',
                                    style: PixelTextStyles.caption,
                                  ),
                                  SizedBox(height: AppConstants.spacingS),
                                  AnimatedNumber(
                                    value: balance,
                                    style: PixelTextStyles.h2,
                                  ),
                                  SizedBox(height: AppConstants.spacingXL),
                                  // Income & Expense
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _buildPixelStatCard(
                                          title: 'Pemasukan',
                                          amount: totalIncome,
                                          icon: '⬇️',
                                          color: AppColors.income,
                                          bgColor: AppColors.incomeBg,
                                        ),
                                      ),
                                      SizedBox(width: AppConstants.spacingM),
                                      Expanded(
                                        child: _buildPixelStatCard(
                                          title: 'Pengeluaran',
                                          amount: totalExpense,
                                          icon: '⬆️',
                                          color: AppColors.expense,
                                          bgColor: AppColors.expenseBg,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: AppConstants.spacingM),

                    // FITUR SECTION
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppConstants.spacingXL,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FadeInSlide(
                            delay: 400,
                            child: Text('Fitur', style: PixelTextStyles.h3),
                          ),
                          SizedBox(height: AppConstants.spacingL),
                          GridView.count(
                            crossAxisCount: 2,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisSpacing: AppConstants.spacingM,
                            mainAxisSpacing: AppConstants.spacingM,
                            children: [
                              FadeInSlide(
                                delay: 500,
                                child: _buildPixelMenuCard(
                                  context,
                                  title: 'Laporan\nKategori',
                                  icon: '📊',
                                  color: AppColors.primary,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const CategoryReportScreen(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              FadeInSlide(
                                delay: 600,
                                child: _buildPixelMenuCard(
                                  context,
                                  title: 'Laporan\nPeriode',
                                  icon: '📅',
                                  color: AppColors.secondary,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const PeriodReportScreen(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              FadeInSlide(
                                delay: 700,
                                child: _buildPixelMenuCard(
                                  context,
                                  title: 'Budget\nPlanning',
                                  icon: '💼',
                                  color: AppColors.warning,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const BudgetPlanningScreen(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              FadeInSlide(
                                delay: 800,
                                child: _buildPixelMenuCard(
                                  context,
                                  title: 'Riwayat\nTransaksi',
                                  icon: '🔄',
                                  color: AppColors.success,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const TransactionsListScreen(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 100), // Space for FAB
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ======================
  // COMPONENTS
  // ======================

  Widget _buildPixelStatCard({
    required String title,
    required double amount,
    required String icon,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      padding: EdgeInsets.all(AppConstants.spacingM),
      decoration: PixelDecorations.pixelStatCard(bgColor: bgColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(icon, style: TextStyle(fontSize: AppConstants.iconSizeS)),
              SizedBox(width: AppConstants.spacingXS),
              Expanded(
                child: Text(
                  title,
                  style: PixelTextStyles.label.copyWith(color: color),
                ),
              ),
            ],
          ),
          SizedBox(height: AppConstants.spacingS),
          AnimatedNumber(
            value: amount,
            style: PixelTextStyles.body.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPixelMenuCard(
    BuildContext context, {
    required String title,
    required String icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return BouncyCard(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(AppConstants.spacingL),
        decoration: PixelDecorations.pixelCard(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                border: Border.all(
                  color: AppColors.black,
                  width: AppConstants.pixelBorderWidthThin,
                ),
                borderRadius: BorderRadius.circular(AppConstants.pixelCardRadius),
              ),
              alignment: Alignment.center,
              child: Text(
                icon,
                style: TextStyle(fontSize: AppConstants.iconSizeL),
              ),
            ),
            SizedBox(height: AppConstants.spacingM),
            Text(
              title,
              textAlign: TextAlign.center,
              style: PixelTextStyles.caption.copyWith(
                color: AppColors.textDark,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPixelIconButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return BouncyCard(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(
            color: AppColors.black,
            width: AppConstants.pixelBorderWidthThin,
          ),
          borderRadius: BorderRadius.circular(AppConstants.pixelCardRadius),
          boxShadow: [
            BoxShadow(
              color: AppColors.black,
              offset: const Offset(2, 2),
              blurRadius: 0,
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(AppConstants.spacingS),
          child: Icon(
            icon,
            color: AppColors.primary,
            size: AppConstants.iconSizeM,
          ),
        ),
      ),
    );
  }
}