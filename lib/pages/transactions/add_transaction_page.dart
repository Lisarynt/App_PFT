import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/transaction_provider.dart';
import '../../models/transaction_model.dart';
import '../../utils/constants.dart';
import '../../utils/validators.dart';
import '../../utils/helpers.dart';
import '../../widgets/animations/fade_in_slide.dart';
import '../../widgets/animations/bouncy_card.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({Key? key}) : super(key: key);

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _type = 'expense';
  String? _selectedCategory;
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  List<String> get _categories {
    return _type == 'expense'
        ? TransactionCategories.expenseCategories
        : TransactionCategories.incomeCategories;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: AppColors.white,
              surface: AppColors.white,
              onSurface: AppColors.textDark,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedCategory == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '⚠️ Pilih kategori terlebih dahulu',
              style: PixelTextStyles.body.copyWith(color: AppColors.white),
            ),
            backgroundColor: AppColors.danger,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.pixelButtonRadius),
              side: BorderSide(color: AppColors.black, width: 2),
            ),
          ),
        );
        return;
      }

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final transactionProvider =
          Provider.of<TransactionProvider>(context, listen: false);

      final amount = Helpers.parseDouble(_amountController.text);

      final transaction = TransactionModel(
        userId: authProvider.user!.uid,
        type: _type,
        amount: amount,
        category: _selectedCategory!,
        description: _descriptionController.text.trim(),
        date: _selectedDate,
        createdAt: DateTime.now(),
      );

      final success = await transactionProvider.addTransaction(transaction);

      if (success && mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '✅ Transaksi berhasil ditambahkan',
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
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '❌ ${transactionProvider.errorMessage ?? 'Gagal menambahkan transaksi'}',
              style: PixelTextStyles.body.copyWith(color: AppColors.white),
            ),
            backgroundColor: AppColors.danger,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PixelBackgroundApp(
        child: SafeArea(
          child: Column(
            children: [
              // PIXEL HEADER
              _buildPixelHeader(context),
              
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(AppConstants.spacingXL),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // TYPE SELECTOR
                        FadeInSlide(
                          delay: 0,
                          child: Row(
                            children: [
                              Expanded(
                                child: _buildPixelTypeButton('Pengeluaran', 'expense', '⬆️'),
                              ),
                              SizedBox(width: AppConstants.spacingM),
                              Expanded(
                                child: _buildPixelTypeButton('Pemasukan', 'income', '⬇️'),
                              ),
                            ],
                          ),
                        ),
                        
                        SizedBox(height: AppConstants.spacingXL),

                        // AMOUNT FIELD
                        FadeInSlide(
                          delay: 100,
                          child: CustomTextField(
                            controller: _amountController,
                            label: 'Jumlah',
                            hint: 'Masukkan jumlah',
                            prefixIcon: Icons.attach_money,
                            keyboardType: TextInputType.number,
                            validator: Validators.validateAmount,
                          ),
                        ),
                        
                        SizedBox(height: AppConstants.spacingL),

                        // CATEGORY DROPDOWN
                        FadeInSlide(
                          delay: 200,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppConstants.spacingL,
                              vertical: AppConstants.spacingXS,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              border: Border.all(
                                color: _selectedCategory == null 
                                    ? AppColors.black 
                                    : AppColors.primary,
                                width: _selectedCategory == null 
                                    ? AppConstants.pixelBorderWidthThin 
                                    : AppConstants.pixelBorderWidth,
                              ),
                              borderRadius: BorderRadius.circular(AppConstants.pixelCardRadius),
                            ),
                            child: DropdownButtonFormField<String>(
                              value: _selectedCategory,
                              decoration: InputDecoration(
                                labelText: 'Kategori',
                                labelStyle: PixelTextStyles.bodyLight,
                                prefixIcon: Icon(
                                  Icons.category,
                                  size: AppConstants.iconSizeM,
                                ),
                                border: InputBorder.none,
                                errorStyle: PixelTextStyles.caption.copyWith(
                                  color: AppColors.danger,
                                ),
                              ),
                              style: PixelTextStyles.body,
                              items: _categories.map((category) {
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
                                setState(() {
                                  _selectedCategory = value;
                                });
                              },
                              validator: (value) =>
                                  value == null ? 'Pilih kategori' : null,
                            ),
                          ),
                        ),
                        
                        SizedBox(height: AppConstants.spacingL),

                        // DATE PICKER
                        FadeInSlide(
                          delay: 300,
                          child: BouncyCard(
                            onTap: () => _selectDate(context),
                            child: Container(
                              padding: EdgeInsets.all(AppConstants.spacingL),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                border: Border.all(
                                  color: AppColors.black,
                                  width: AppConstants.pixelBorderWidthThin,
                                ),
                                borderRadius: BorderRadius.circular(AppConstants.pixelCardRadius),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    color: AppColors.primary,
                                    size: AppConstants.iconSizeM,
                                  ),
                                  SizedBox(width: AppConstants.spacingL),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Tanggal',
                                          style: PixelTextStyles.label,
                                        ),
                                        SizedBox(height: AppConstants.spacingXS),
                                        Text(
                                          Helpers.formatDate(_selectedDate),
                                          style: PixelTextStyles.body,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    Icons.chevron_right,
                                    color: AppColors.textLight,
                                    size: AppConstants.iconSizeM,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        
                        SizedBox(height: AppConstants.spacingL),

                        // DESCRIPTION FIELD
                        FadeInSlide(
                          delay: 400,
                          child: CustomTextField(
                            controller: _descriptionController,
                            label: 'Deskripsi',
                            hint: 'Masukkan deskripsi',
                            prefixIcon: Icons.description,
                            maxLines: 3,
                            validator: (value) =>
                                Validators.validateRequired(value, 'Deskripsi'),
                          ),
                        ),
                        
                        SizedBox(height: AppConstants.spacingXXL),

                        // SUBMIT BUTTON
                        FadeInSlide(
                          delay: 500,
                          child: Consumer<TransactionProvider>(
                            builder: (context, transactionProvider, child) {
                              return CustomButton(
                                text: 'Simpan',
                                onPressed: _handleSubmit,
                                isLoading: transactionProvider.isLoading,
                                backgroundColor: _type == 'expense' 
                                    ? AppColors.expense 
                                    : AppColors.income,
                                icon: Icons.save,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
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
          Text('Tambah Transaksi', style: PixelTextStyles.h2),
        ],
      ),
    );
  }

  // ======================
  // PIXEL TYPE BUTTON
  // ======================
  Widget _buildPixelTypeButton(String label, String type, String emoji) {
    final isSelected = _type == type;
    final color = type == 'income' ? AppColors.income : AppColors.expense;

    return BouncyCard(
      onTap: () {
        setState(() {
          _type = type;
          _selectedCategory = null; // Reset category when type changes
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: AppConstants.spacingL),
        decoration: BoxDecoration(
          color: isSelected ? color : AppColors.white,
          border: Border.all(
            color: AppColors.black,
            width: isSelected 
                ? AppConstants.pixelBorderWidth 
                : AppConstants.pixelBorderWidthThin,
          ),
          borderRadius: BorderRadius.circular(AppConstants.pixelButtonRadius),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.black,
                    offset: Offset(4, 4),
                    blurRadius: 0,
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            Text(emoji, style: TextStyle(fontSize: 24)),
            SizedBox(height: AppConstants.spacingXS),
            Text(
              label,
              textAlign: TextAlign.center,
              style: PixelTextStyles.body.copyWith(
                color: isSelected ? AppColors.white : AppColors.textDark,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}