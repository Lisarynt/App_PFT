class Validators {
  // Email validator
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email tidak boleh kosong';
    }
    
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    
    if (!emailRegex.hasMatch(value)) {
      return 'Email tidak valid';
    }
    
    return null;
  }

  // Password validator
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }
    
    if (value.length < 6) {
      return 'Password minimal 6 karakter';
    }
    
    return null;
  }

  // Confirm password validator
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Konfirmasi password tidak boleh kosong';
    }
    
    if (value != password) {
      return 'Password tidak sama';
    }
    
    return null;
  }

  // Name validator
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nama tidak boleh kosong';
    }
    
    if (value.length < 3) {
      return 'Nama minimal 3 karakter';
    }
    
    return null;
  }

  // Amount validator
  static String? validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Jumlah tidak boleh kosong';
    }
    
    final amount = double.tryParse(value.replaceAll(',', '').replaceAll('.', ''));
    
    if (amount == null) {
      return 'Jumlah harus berupa angka';
    }
    
    if (amount <= 0) {
      return 'Jumlah harus lebih dari 0';
    }
    
    return null;
  }

  // Required field validator
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName tidak boleh kosong';
    }
    return null;
  }

  // Phone number validator (Indonesia)
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nomor telepon tidak boleh kosong';
    }
    
    // Remove spaces and dashes
    final cleanValue = value.replaceAll(RegExp(r'[\s-]'), '');
    
    // Check if starts with 08 or +62 or 62
    final phoneRegex = RegExp(r'^(08|628|\+628)[0-9]{8,11}$');
    
    if (!phoneRegex.hasMatch(cleanValue)) {
      return 'Nomor telepon tidak valid';
    }
    
    return null;
  }

  // Date validator
  static String? validateDate(DateTime? value) {
    if (value == null) {
      return 'Tanggal tidak boleh kosong';
    }
    
    if (value.isAfter(DateTime.now())) {
      return 'Tanggal tidak boleh lebih dari hari ini';
    }
    
    return null;
  }

  // Budget amount validator
  static String? validateBudget(String? value, double spentAmount) {
    final validationResult = validateAmount(value);
    if (validationResult != null) return validationResult;
    
    final amount = double.parse(value!.replaceAll(',', '').replaceAll('.', ''));
    
    if (amount < spentAmount) {
      return 'Budget tidak boleh kurang dari pengeluaran saat ini';
    }
    
    return null;
  }
}