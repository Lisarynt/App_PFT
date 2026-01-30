import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/budget_provider.dart';
import '../../providers/transaction_provider.dart';
import '../../models/budget_model.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';
import '../../utils/validators.dart';
import '../../widgets/animations/fade_in_slide.dart';
import '../../widgets/animations/bouncy_card.dart';
import '../../widgets/animations/pixel_fab.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';

class BudgetPlanningScreen extends StatefulWidget {
  const BudgetPlanningScreen({Key? key}) : super(key: key);

  @override
  State<BudgetPlanningScreen> createState() => _BudgetPlanningScreenState();
} 

class _BudgetPlanningScreenState extends State<BudgetPlanningScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadBudgets();
    });
  }

  void _loadBudgets() {
    final authProvider = context.read<AuthProvider>();
    final budgetProvider = context.read<BudgetProvider>();

    if (authProvider.user != null) {
      budgetProvider.getBudgets(authProvider.user!.uid);
    }
  }

   @override
  Widget build(BuildContext context) {
    final budgetProvider = context.watch<BudgetProvider>();
    final transactionProvider = context.watch<TransactionProvider>();

    // Loading state
    if (budgetProvider.isLoading) {
      return Scaffold(
        body: PixelBackgroundApp(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: AppColors.primary,
                  strokeWidth: 4,
                ),
                SizedBox(height: AppConstants.spacingL),
                Text('Loading...', style: PixelTextStyles.body),
              ],
            ),
          ),
        ),
      );
    }

    // Error state
    if (budgetProvider.errorMessage != null) {
      return Scaffold(
        body: PixelBackgroundApp(
          child: Center(
            child: Container(
              margin: EdgeInsets.all(AppConstants.spacingXL),
              padding: EdgeInsets.all(AppConstants.spacingXL),
              decoration: PixelDecorations.pixelCard(bgColor: AppColors.expenseBg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('❌', style: TextStyle(fontSize: 48)),
                  SizedBox(height: AppConstants.spacingL),
                  Text(
                    budgetProvider.errorMessage!,
                    style: PixelTextStyles.body.copyWith(color: AppColors.danger),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    final currentMonthTransactions =
        transactionProvider.getCurrentMonthTransactions();

    final spendingByCategory = <String, double>{};
    for (var t in currentMonthTransactions.where((t) => t.type == 'expense')) {
      spendingByCategory[t.category] =
          (spendingByCategory[t.category] ?? 0) + t.amount;
    }

    return Scaffold(
      body: PixelBackgroundApp(
        child: SafeArea(
          child: Column(
            children: [
              // PIXEL HEADER
              _buildPixelHeader(context),
              
              Expanded(
                child: budgetProvider.budgets.isEmpty
                    ? _buildPixelEmptyState()
                    : ListView.builder(
                        padding: EdgeInsets.all(AppConstants.spacingXL),
                        itemCount: budgetProvider.budgets.length,
                        itemBuilder: (context, index) {
                          final budget = budgetProvider.budgets[index];
                          final spent = spendingByCategory[budget.category] ?? 0;
                          final percentage = (spent / budget.amount) * 100;

                          return FadeInSlide(
                            delay: index * 100,
                            child: _buildPixelBudgetCard(
                              budget,
                              spent,
                              percentage,
                              budgetProvider,
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: PixelFAB(
        backgroundColor: AppColors.primary,
        onPressed: () => _showPixelAddBudgetDialog(),
      ),
    );
  }

  // ======================
  // PIXEL HEADER
  // ======================
  Widget _buildPixelHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppConstants.spacingXL),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.black,
            width: AppConstants.pixelBorderWidth,
          ),
        ),
      ),
      child: Row(
        children: [
          BouncyCard(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.all(AppConstants.spacingS),
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
                    offset: Offset(2, 2),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: Icon(
                Icons.arrow_back,
                color: AppColors.primary,
                size: AppConstants.iconSizeM,
              ),
            ),
          ),
          SizedBox(width: AppConstants.spacingM),
          Text('Budget Planning', style: PixelTextStyles.h2),
        ],
      ),
    );
  }

  // ======================
  // PIXEL EMPTY STATE
  // ======================
  Widget _buildPixelEmptyState() {
    return Center(
      child: FadeInSlide(
        delay: 0,
        child: Container(
          margin: EdgeInsets.all(AppConstants.spacingXXL),
          padding: EdgeInsets.all(AppConstants.spacingXXL),
          decoration: PixelDecorations.pixelCard(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('💼', style: TextStyle(fontSize: 64)),
              SizedBox(height: AppConstants.spacingL),
              Text(
                'Belum Ada Budget',
                style: PixelTextStyles.h3,
              ),
              SizedBox(height: AppConstants.spacingS),
              Text(
                'Tekan tombol + untuk\nmenambah budget',
                style: PixelTextStyles.caption,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ======================
  // PIXEL BUDGET CARD
  // ======================
  Widget _buildPixelBudgetCard(
    BudgetModel budget,
    double spent,
    double percentage,
    BudgetProvider budgetProvider,
  ) {
    Color progressColor;
    if (percentage < 70) {
      progressColor = AppColors.success;
    } else if (percentage < 90) {
      progressColor = AppColors.warning;
    } else {
      progressColor = AppColors.danger;
    }

    final emoji = TransactionCategories.categoryIcons[budget.category] ?? '📦';

    return Padding(
      padding: EdgeInsets.only(bottom: AppConstants.spacingL),
      child: Container(
        padding: EdgeInsets.all(AppConstants.spacingL),
        decoration: PixelDecorations.pixelCard(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: progressColor.withOpacity(0.2),
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          budget.category,
                          style: PixelTextStyles.body.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: AppConstants.fontSizeL,
                          ),
                        ),
                        SizedBox(height: AppConstants.spacingXS),
                        Text(
                          'Budget Bulanan',
                          style: PixelTextStyles.label,
                        ),
                      ],
                    ),
                  ],
                ),
                _buildPixelPopupMenu(budget, budgetProvider),
              ],
            ),
            
            SizedBox(height: AppConstants.spacingL),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Terpakai', style: PixelTextStyles.label),
                    SizedBox(height: AppConstants.spacingXS),
                    Text(
                      Helpers.formatCurrency(spent),
                      style: PixelTextStyles.body.copyWith(
                        color: progressColor,
                        fontWeight: FontWeight.bold,
                        fontSize: AppConstants.fontSizeL,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Budget', style: PixelTextStyles.label),
                    SizedBox(height: AppConstants.spacingXS),
                    Text(
                      Helpers.formatCurrency(budget.amount),
                      style: PixelTextStyles.body.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: AppConstants.fontSizeL,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: AppConstants.spacingM),

            Container(
              height: 12,
              decoration: BoxDecoration(
                color: AppColors.divider,
                border: Border.all(
                  color: AppColors.black,
                  width: AppConstants.pixelBorderWidthThin,
                ),
                borderRadius: BorderRadius.circular(AppConstants.pixelCardRadius),
              ),
              child: Stack(
                children: [
                  FractionallySizedBox(
                    widthFactor: (percentage > 100 ? 100 : percentage) / 100,
                    child: Container(
                      decoration: BoxDecoration(
                        color: progressColor,
                        borderRadius: BorderRadius.circular(AppConstants.pixelCardRadius),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: AppConstants.spacingS),

            // PERCENTAGE & REMAINING
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${percentage.toStringAsFixed(0)}% terpakai',
                  style: PixelTextStyles.caption.copyWith(
                    color: progressColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Sisa: ${Helpers.formatCurrency(budget.amount - spent)}',
                  style: PixelTextStyles.caption,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ======================
  // PIXEL POPUP MENU
  // ======================
  Widget _buildPixelPopupMenu(BudgetModel budget, BudgetProvider budgetProvider) {
    return PopupMenuButton<String>(
      icon: Container(
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColors.inputBg,
          border: Border.all(
            color: AppColors.black,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(
          Icons.more_horiz,
          color: AppColors.textDark,
          size: 16,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.pixelCardRadius),
        side: BorderSide(
          color: AppColors.black,
          width: AppConstants.pixelBorderWidthThin,
        ),
      ),
      onSelected: (value) {
        if (value == 'edit') {
          _showPixelEditBudgetDialog(budget);
        } else if (value == 'delete') {
          _showPixelDeleteDialog(budget, budgetProvider);
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit, size: 18, color: AppColors.warning),
              SizedBox(width: AppConstants.spacingS),
              Text('Edit', style: PixelTextStyles.body),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete, size: 18, color: AppColors.danger),
              SizedBox(width: AppConstants.spacingS),
              Text(
                'Hapus',
                style: PixelTextStyles.body.copyWith(color: AppColors.danger),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ======================
  // ADD BUDGET DIALOG
  // ======================
  void _showPixelAddBudgetDialog() {
    final formKey = GlobalKey<FormState>();
    final amountController = TextEditingController();
    String? selectedCategory;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) {
          return Dialog(
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
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('💼', style: TextStyle(fontSize: 48)),
                    SizedBox(height: AppConstants.spacingL),
                    Text('Tambah Budget', style: PixelTextStyles.h3),
                    SizedBox(height: AppConstants.spacingXL),
                    
                    // CATEGORY DROPDOWN
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppConstants.spacingL,
                        vertical: AppConstants.spacingXS,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        border: Border.all(
                          color: AppColors.black,
                          width: AppConstants.pixelBorderWidthThin,
                        ),
                        borderRadius: BorderRadius.circular(AppConstants.pixelCardRadius),
                      ),
                      child: DropdownButtonFormField<String>(
                        value: selectedCategory,
                        decoration: InputDecoration(
                          labelText: 'Kategori',
                          labelStyle: PixelTextStyles.bodyLight,
                          border: InputBorder.none,
                        ),
                        style: PixelTextStyles.body,
                        items: TransactionCategories.expenseCategories.map((category) {
                          final emoji = TransactionCategories.categoryIcons[category] ?? '📦';
                          return DropdownMenuItem(
                            value: category,
                            child: Row(
                              children: [
                                Text(emoji, style: TextStyle(fontSize: 20)),
                                SizedBox(width: AppConstants.spacingS),
                                Text(category, style: PixelTextStyles.body),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setStateDialog(() {
                            selectedCategory = value;
                          });
                        },
                        validator: (value) => value == null ? 'Pilih kategori' : null,
                      ),
                    ),
                    
                    SizedBox(height: AppConstants.spacingL),
                    
                    // AMOUNT FIELD
                    CustomTextField(
                      controller: amountController,
                      label: 'Jumlah Budget',
                      hint: 'Masukkan jumlah',
                      prefixIcon: Icons.attach_money,
                      keyboardType: TextInputType.number,
                      validator: Validators.validateAmount,
                    ),
                    
                    SizedBox(height: AppConstants.spacingXL),
                    
                    // BUTTONS
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
                              if (formKey.currentState!.validate() && selectedCategory != null) {
                                final authProvider = Provider.of<AuthProvider>(context, listen: false);
                                final budgetProvider = Provider.of<BudgetProvider>(context, listen: false);

                                final existingBudget = budgetProvider.getBudgetByCategory(
                                  selectedCategory!,
                                  authProvider.user!.uid,
                                );

                                if (existingBudget != null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        '⚠️ Kategori ini sudah memiliki budget',
                                        style: PixelTextStyles.body.copyWith(color: AppColors.white),
                                      ),
                                      backgroundColor: AppColors.warning,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(AppConstants.pixelButtonRadius),
                                        side: BorderSide(color: AppColors.black, width: 2),
                                      ),
                                    ),
                                  );
                                  return;
                                }

                                final amount = Helpers.parseDouble(amountController.text);
                                final dateRange = Helpers.getCurrentMonthRange();

                                final budget = BudgetModel(
                                  userId: authProvider.user!.uid,
                                  category: selectedCategory!,
                                  amount: amount,
                                  period: 'monthly',
                                  startDate: dateRange['start']!,
                                  endDate: dateRange['end']!,
                                );

                                final success = await budgetProvider.addBudget(
                                  budget,
                                  authProvider.user!.uid,
                                );

                                if (context.mounted) {
                                  Navigator.pop(context);
                                  if (success) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          '✅ Budget berhasil ditambahkan',
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
        },
      ),
    );
  }

  // ======================
  // EDIT BUDGET DIALOG
  // ======================
  void _showPixelEditBudgetDialog(BudgetModel budget) {
    final formKey = GlobalKey<FormState>();
    final amountController = TextEditingController(text: budget.amount.toString());

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
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('✏️', style: TextStyle(fontSize: 48)),
                SizedBox(height: AppConstants.spacingL),
                Text('Edit Budget', style: PixelTextStyles.h3),
                SizedBox(height: AppConstants.spacingM),
                Text(
                  budget.category,
                  style: PixelTextStyles.h3.copyWith(color: AppColors.primary),
                ),
                SizedBox(height: AppConstants.spacingXL),
                
                CustomTextField(
                  controller: amountController,
                  label: 'Jumlah Budget',
                  hint: 'Masukkan jumlah',
                  prefixIcon: Icons.attach_money,
                  keyboardType: TextInputType.number,
                  validator: Validators.validateAmount,
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
                        text: 'Update',
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            final budgetProvider = Provider.of<BudgetProvider>(context, listen: false);
                            final authProvider = Provider.of<AuthProvider>(context, listen: false);
                            final amount = Helpers.parseDouble(amountController.text);

                            final updatedBudget = BudgetModel(
                              id: budget.id,
                              userId: budget.userId,
                              category: budget.category,
                              amount: amount,
                              period: budget.period,
                              startDate: budget.startDate,
                              endDate: budget.endDate,
                            );

                            final success = await budgetProvider.updateBudget(
                              updatedBudget.id!,
                              updatedBudget,
                              authProvider.user!.uid,
                            );

                            if (context.mounted) {
                              Navigator.pop(context);
                              if (success) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      '✅ Budget berhasil diupdate',
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
                        backgroundColor: AppColors.warning,
                        icon: Icons.edit,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ======================
  // DELETE DIALOG
  // ======================
  void _showPixelDeleteDialog(BudgetModel budget, BudgetProvider budgetProvider) {
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
              Text('⚠️', style: TextStyle(fontSize: 48)),
              SizedBox(height: AppConstants.spacingL),
              Text(
                'Hapus Budget?',
                style: PixelTextStyles.h3,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppConstants.spacingM),
              Text(
                'Yakin mau hapus budget\n${budget.category}?',
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
                      text: 'Hapus',
                      onPressed: () async {
                        final authProvider = Provider.of<AuthProvider>(context, listen: false);
                        Navigator.pop(context);
                        if (budget.id == null) return;
                        final success = await budgetProvider.deleteBudget(
                          budget.id!,
                          authProvider.user!.uid,
                        );

                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              success ? '✅ Budget berhasil dihapus' : '❌ Gagal menghapus budget',
                              style: PixelTextStyles.body.copyWith(color: AppColors.white),
                            ),
                            backgroundColor: success ? AppColors.success : AppColors.danger,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppConstants.pixelButtonRadius),
                              side: BorderSide(color: AppColors.black, width: 2),
                            ),
                          ),
                        );
                      },
                      backgroundColor: AppColors.danger,
                      icon: Icons.delete,
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