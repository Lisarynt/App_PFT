import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/transaction_provider.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';
import '../../widgets/animations/fade_in_slide.dart';
import '../../widgets/animations/bouncy_card.dart';
import '../../widgets/animations/animated_number.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final transactionProvider = Provider.of<TransactionProvider>(context);
    final user = authProvider.userModel;

    final totalTransactions = transactionProvider.transactions.length;
    final totalIncome = transactionProvider.getTotalIncome();
    final totalExpense = transactionProvider.getTotalExpense();

    return Scaffold(
      body: PixelBackgroundApp(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                FadeInSlide(
                  delay: 0,
                  child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.all(AppConstants.spacingXL),
                    padding: EdgeInsets.all(AppConstants.spacingXXL),
                    decoration: PixelDecorations.pixelCard(
                      bgColor: const Color.fromARGB(255, 243, 243, 166),
                    ),
                    child: Column(
                      children: [
                        // LOGOUT BUTTON
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Profil', style: PixelTextStyles.h3.copyWith(color: const Color.fromARGB(255, 0, 0, 0))),
                            BouncyCard(
                              onTap: () => _showPixelLogoutDialog(context, authProvider),
                              child: Container(
                                padding: EdgeInsets.all(AppConstants.spacingS),
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  border: Border.all(
                                    color: AppColors.black,
                                    width: AppConstants.pixelBorderWidthThin,
                                  ),
                                  borderRadius: BorderRadius.circular(AppConstants.pixelCardRadius),
                                ),
                                child: Icon(
                                  Icons.logout,
                                  color: AppColors.danger,
                                  size: AppConstants.iconSizeM,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: AppConstants.spacingXL),
                        
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            border: Border.all(
                              color: AppColors.black,
                              width: AppConstants.pixelBorderWidth,
                            ),
                            borderRadius: BorderRadius.circular(AppConstants.pixelCardRadius),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.black,
                                offset: Offset(4, 4),
                                blurRadius: 0,
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            user?.name.substring(0, 1).toUpperCase() ?? 'U',
                            style: PixelTextStyles.h1.copyWith(
                              fontSize: 48,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        SizedBox(height: AppConstants.spacingL),
                        
                        Text(
                          user?.name ?? 'User',
                          style: PixelTextStyles.h2.copyWith(color: const Color.fromARGB(255, 0, 0, 0)),
                        ),
                        SizedBox(height: AppConstants.spacingS),
                        Text(
                          user?.email ?? '',
                          style: PixelTextStyles.body.copyWith(
                            color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // STATISTICS SECTION
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppConstants.spacingXL),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FadeInSlide(
                        delay: 200,
                        child: Text('Statistik', style: PixelTextStyles.h3),
                      ),
                      SizedBox(height: AppConstants.spacingL),
                      
                      Row(
                        children: [
                          Expanded(
                            child: FadeInSlide(
                              delay: 300,
                              child: _buildPixelStatCard(
                                title: 'Total Transaksi',
                                value: totalTransactions.toString(),
                                emoji: '📝',
                                color: AppColors.primary,
                                bgColor: AppColors.primary.withOpacity(0.1),
                                isNumber: false,
                              ),
                            ),
                          ),
                          SizedBox(width: AppConstants.spacingM),
                          Expanded(
                            child: FadeInSlide(
                              delay: 400,
                              child: _buildPixelStatCard(
                                title: 'Total Pemasukan',
                                value: Helpers.shortenNumber(totalIncome),
                                emoji: '⬇️',
                                color: AppColors.income,
                                bgColor: AppColors.incomeBg,
                                isNumber: false,
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      SizedBox(height: AppConstants.spacingM),
                      
                      FadeInSlide(
                        delay: 500,
                        child: _buildPixelStatCardFull(
                          title: 'Total Pengeluaran',
                          value: totalExpense,
                          emoji: '⬆️',
                          color: AppColors.expense,
                          bgColor: AppColors.expenseBg,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: AppConstants.spacingXXL),

                // MENU SECTION
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppConstants.spacingXL),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FadeInSlide(
                        delay: 600,
                        child: Text('Pengaturan', style: PixelTextStyles.h3),
                      ),
                      SizedBox(height: AppConstants.spacingL),
                      
                      FadeInSlide(
                        delay: 700,
                        child: _buildPixelMenuItem(
                          context,
                          title: 'Edit Profil',
                          emoji: '👤',
                          color: AppColors.primary,
                          onTap: () => _showPixelEditProfileDialog(context, authProvider),
                        ),
                      ),
                      
                      FadeInSlide(
                        delay: 800,
                        child: _buildPixelMenuItem(
                          context,
                          title: 'Tentang Aplikasi',
                          emoji: 'ℹ️',
                          color: AppColors.secondary,
                          onTap: () => _showPixelAboutDialog(context),
                        ),
                      ),
                      
                      FadeInSlide(
                        delay: 900,
                        child: _buildPixelMenuItem(
                          context,
                          title: 'Keluar',
                          emoji: '🚪',
                          color: AppColors.danger,
                          onTap: () => _showPixelLogoutDialog(context, authProvider),
                          isDestructive: true,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: AppConstants.spacingXXL),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPixelStatCard({
    required String title,
    required String value,
    required String emoji,
    required Color color,
    required Color bgColor,
    required bool isNumber,
  }) {
    return Container(
      padding: EdgeInsets.all(AppConstants.spacingL),
      decoration: PixelDecorations.pixelCard(),
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: bgColor,
              border: Border.all(
                color: AppColors.black,
                width: AppConstants.pixelBorderWidthThin,
              ),
              borderRadius: BorderRadius.circular(AppConstants.pixelCardRadius),
            ),
            alignment: Alignment.center,
            child: Text(emoji, style: TextStyle(fontSize: 28)),
          ),
          SizedBox(height: AppConstants.spacingM),
          Text(
            title,
            style: PixelTextStyles.label,
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
          SizedBox(height: AppConstants.spacingXS),
          Text(
            value,
            style: PixelTextStyles.h3.copyWith(color: color),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPixelStatCardFull({
    required String title,
    required double value,
    required String emoji,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      padding: EdgeInsets.all(AppConstants.spacingL),
      decoration: PixelDecorations.pixelCard(),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: bgColor,
              border: Border.all(
                color: AppColors.black,
                width: AppConstants.pixelBorderWidthThin,
              ),
              borderRadius: BorderRadius.circular(AppConstants.pixelCardRadius),
            ),
            alignment: Alignment.center,
            child: Text(emoji, style: TextStyle(fontSize: 28)),
          ),
          SizedBox(width: AppConstants.spacingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: PixelTextStyles.label),
                SizedBox(height: AppConstants.spacingXS),
                AnimatedNumber(
                  value: value,
                  style: PixelTextStyles.h3.copyWith(color: color),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPixelMenuItem(
    BuildContext context, {
    required String title,
    required String emoji,
    required Color color,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppConstants.spacingM),
      child: BouncyCard(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(AppConstants.spacingL),
          decoration: PixelDecorations.pixelCard(
            bgColor: isDestructive 
                ? AppColors.danger.withOpacity(0.1) 
                : AppColors.white,
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  border: Border.all(
                    color: AppColors.black,
                    width: AppConstants.pixelBorderWidthThin,
                  ),
                  borderRadius: BorderRadius.circular(AppConstants.pixelCardRadius),
                ),
                alignment: Alignment.center,
                child: Text(emoji, style: TextStyle(fontSize: 20)),
              ),
              SizedBox(width: AppConstants.spacingM),
              Expanded(
                child: Text(
                  title,
                  style: PixelTextStyles.body.copyWith(
                    color: isDestructive ? AppColors.danger : AppColors.textDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: isDestructive ? AppColors.danger : AppColors.textLight,
                size: AppConstants.iconSizeM,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPixelEditProfileDialog(BuildContext context, AuthProvider authProvider) {
    final nameController = TextEditingController(text: authProvider.userModel?.name);

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.pixelCardRadius),
          side: BorderSide(
            color: AppColors.black,
            width: AppConstants.pixelBorderWidth,
          ),
        ),
        child: Container(
          padding: EdgeInsets.all(AppConstants.spacingXL),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppConstants.pixelCardRadius),
            boxShadow: [
              BoxShadow(
                color: AppColors.black,
                offset: Offset(4, 4),
                blurRadius: 0,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('✏️', style: TextStyle(fontSize: 48)),
              SizedBox(height: AppConstants.spacingL),
              Text('Edit Profil', style: PixelTextStyles.h3),
              SizedBox(height: AppConstants.spacingXL),
              
              CustomTextField(
                controller: nameController,
                label: 'Nama',
                prefixIcon: Icons.person,
              ),
              
              SizedBox(height: AppConstants.spacingXL),
              
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'Batal',
                      onPressed: () => Navigator.pop(context),
                      isOutlined: true,
                    ),
                  ),
                  SizedBox(width: AppConstants.spacingM),
                  Expanded(
                    child: CustomButton(
                      text: 'Simpan',
                      onPressed: () async {
                        if (nameController.text.trim().isNotEmpty) {
                          final success = await authProvider.updateProfile({
                            'name': nameController.text.trim(),
                          });

                          if (context.mounted) {
                            Navigator.pop(context);
                            if (success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '✅ Profil berhasil diupdate',
                                    style: PixelTextStyles.body.copyWith(color: AppColors.white),
                                  ),
                                  backgroundColor: AppColors.success,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(AppConstants.pixelButtonRadius),
                                    side: BorderSide(color: AppColors.black, width: 2),
                                  ),
                                ),
                              );
                            }
                          }
                        }
                      },
                      backgroundColor: AppColors.primary,
                      icon: Icons.save,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPixelAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.pixelCardRadius),
          side: BorderSide(
            color: AppColors.black,
            width: AppConstants.pixelBorderWidth,
          ),
        ),
        child: Container(
          padding: EdgeInsets.all(AppConstants.spacingXXL),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppConstants.pixelCardRadius),
            boxShadow: [
              BoxShadow(
                color: AppColors.black,
                offset: Offset(4, 4),
                blurRadius: 0,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('🎮', style: TextStyle(fontSize: 64)),
              SizedBox(height: AppConstants.spacingL),
              Text(
                AppConstants.appName,
                style: PixelTextStyles.h2,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppConstants.spacingS),
              Text(
                'Versi ${AppConstants.appVersion}',
                style: PixelTextStyles.caption,
              ),
              SizedBox(height: AppConstants.spacingL),
              Container(
                padding: EdgeInsets.all(AppConstants.spacingM),
                decoration: BoxDecoration(
                  color: AppColors.inputBg,
                  border: Border.all(
                    color: AppColors.black,
                    width: AppConstants.pixelBorderWidthThin,
                  ),
                  borderRadius: BorderRadius.circular(AppConstants.pixelCardRadius),
                ),
                child: Text(
                  AppConstants.appTagline,
                  style: PixelTextStyles.body,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: AppConstants.spacingXL),
              CustomButton(
                text: 'Tutup',
                onPressed: () => Navigator.pop(context),
                backgroundColor: AppColors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPixelLogoutDialog(BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.pixelCardRadius),
          side: BorderSide(
            color: AppColors.black,
            width: AppConstants.pixelBorderWidth,
          ),
        ),
        child: Container(
          padding: EdgeInsets.all(AppConstants.spacingXL),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppConstants.pixelCardRadius),
            boxShadow: [
              BoxShadow(
                color: AppColors.black,
                offset: Offset(4, 4),
                blurRadius: 0,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('👋', style: TextStyle(fontSize: 48)),
              SizedBox(height: AppConstants.spacingL),
              Text(
                'Keluar Aplikasi?',
                style: PixelTextStyles.h3,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppConstants.spacingM),
              Text(
                'Kamu yakin mau keluar dari\naplikasi ini?',
                style: PixelTextStyles.caption,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppConstants.spacingXL),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'Batal',
                      onPressed: () => Navigator.pop(context),
                      isOutlined: true,
                    ),
                  ),
                  SizedBox(width: AppConstants.spacingM),
                  Expanded(
                    child: CustomButton(
                      text: 'Keluar',
                      onPressed: () async {
                        Navigator.pop(context);
                        await authProvider.signOut();
                      },
                      backgroundColor: AppColors.danger,
                      icon: Icons.logout,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}