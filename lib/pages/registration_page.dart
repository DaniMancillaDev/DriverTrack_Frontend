import 'package:flutter/material.dart';
import 'dart:async';
import '../theme/app_theme.dart';
import '../widgets/ui/custom_input.dart';
import '../widgets/ui/custom_button.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _showPassword = false;
  bool _submitted = false;

  String? _fullNameError;
  String? _phoneError;
  String? _emailError;
  String? _birthDateError;
  String? _passwordError;

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _birthDateController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) return "Full name is required";
    if (value.trim().length < 3) return "Name must be at least 3 characters";
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) return "Phone number is required";
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 10 || digits.length > 15) return "Phone must be 10–15 digits";
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return "Email is required";
    if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value)) {
      return "Enter a valid email address";
    }
    return null;
  }

  String? _validateBirthDate(String? value) {
    if (value == null || value.isEmpty) return "Birth date is required";
    try {
      final dob = DateTime.parse(value);
      final age = DateTime.now().difference(dob).inDays / 365.25;
      if (age < 16) return "You must be at least 16 years old";
    } catch (e) {
      return "Invalid date format";
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return "Password is required";
    if (value.length < 8) return "Password must be at least 8 characters";
    if (!RegExp(r'[A-Z]').hasMatch(value)) return "Must contain at least one uppercase letter";
    if (!RegExp(r'[0-9]').hasMatch(value)) return "Must contain at least one number";
    return null;
  }

  void _handleSubmit() {
    setState(() {
      _fullNameError = _validateFullName(_fullNameController.text);
      _phoneError = _validatePhone(_phoneController.text);
      _emailError = _validateEmail(_emailController.text);
      _birthDateError = _validateBirthDate(_birthDateController.text);
      _passwordError = _validatePassword(_passwordController.text);
    });

    if (_fullNameError == null &&
        _phoneError == null &&
        _emailError == null &&
        _birthDateError == null &&
        _passwordError == null) {
      setState(() => _submitted = true);
      Timer(const Duration(milliseconds: 1200), () {
        if (mounted) {
          Navigator.of(context).pushReplacementNamed('/app');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final bool isMobile = constraints.maxWidth < 600;
              
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Column(
                    children: [
                      _buildHeader(isMobile),
                      _buildFormCard(isMobile),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: isMobile ? 32 : 48,
        bottom: isMobile ? 32 : 40,
        left: 24,
        right: 24,
      ),
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: const Alignment(0, -1),
          radius: 0.8,
          colors: [
            AppColors.orangePrimary.withOpacity(0.12),
            Colors.transparent,
          ],
        ),
      ),
      child: Column(
        children: [
          Container(
            width: isMobile ? 56 : 64,
            height: isMobile ? 56 : 64,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppColors.orangePrimary.withOpacity(0.35),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(Icons.directions_car, color: Colors.white, size: 32),
          ),
          const SizedBox(height: 12),
          const Text(
            'DriveTrack',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Your intelligent vehicle companion',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormCard(bool isMobile) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : 24,
        vertical: isMobile ? 16 : 0,
      ),
      padding: EdgeInsets.all(isMobile ? 20 : 28),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(isMobile ? 24 : 32),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Create Account',
            style: TextStyle(
              color: Colors.white,
              fontSize: isMobile ? 18 : 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Fill in your details to get started',
            style: TextStyle(
              color: AppColors.textDim,
              fontSize: isMobile ? 12 : 13,
            ),
          ),
          const SizedBox(height: 20),
          CustomInput(
            controller: _fullNameController,
            label: 'FULL NAME',
            placeholder: 'John Doe',
            errorText: _fullNameError,
            prefixIcon: const Icon(Icons.person_outline, size: 18, color: AppColors.textDim),
            onChanged: (_) {
              if (_fullNameError != null) {
                setState(() => _fullNameError = _validateFullName(_fullNameController.text));
              }
            },
          ),
          const SizedBox(height: 20),
          CustomInput(
            controller: _phoneController,
            label: 'PHONE NUMBER',
            placeholder: '+1 234 567 8900',
            keyboardType: TextInputType.phone,
            errorText: _phoneError,
            subHint: _phoneError == null ? '10–15 digits, including country code' : null,
            prefixIcon: const Icon(Icons.phone_outlined, size: 18, color: AppColors.textDim),
            onChanged: (_) {
              if (_phoneError != null) {
                setState(() => _phoneError = _validatePhone(_phoneController.text));
              }
            },
          ),
          const SizedBox(height: 20),
          CustomInput(
            controller: _emailController,
            label: 'EMAIL ADDRESS',
            placeholder: 'john@example.com',
            keyboardType: TextInputType.emailAddress,
            errorText: _emailError,
            prefixIcon: const Icon(Icons.mail_outline, size: 18, color: AppColors.textDim),
            onChanged: (_) {
              if (_emailError != null) {
                setState(() => _emailError = _validateEmail(_emailController.text));
              }
            },
          ),
          const SizedBox(height: 20),
          CustomInput(
            controller: _birthDateController,
            label: 'DATE OF BIRTH',
            placeholder: 'YYYY-MM-DD',
            keyboardType: TextInputType.datetime,
            errorText: _birthDateError,
            prefixIcon: const Icon(Icons.calendar_today_outlined, size: 18, color: AppColors.textDim),
            onChanged: (_) {
              if (_birthDateError != null) {
                setState(() => _birthDateError = _validateBirthDate(_birthDateController.text));
              }
            },
          ),
          const SizedBox(height: 20),
          CustomInput(
            controller: _passwordController,
            label: 'PASSWORD',
            placeholder: 'Min. 8 characters',
            obscureText: !_showPassword,
            errorText: _passwordError,
            prefixIcon: const Icon(Icons.lock_outline, size: 18, color: AppColors.textDim),
            suffixIcon: GestureDetector(
              onTap: () => setState(() => _showPassword = !_showPassword),
              child: Icon(
                _showPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                size: 18,
                color: AppColors.textDim,
              ),
            ),
            onChanged: (val) {
              setState(() {
                if (_passwordError != null) {
                  _passwordError = _validatePassword(val);
                }
              });
            },
          ),
          PasswordStrengthIndicator(password: _passwordController.text),
          const SizedBox(height: 24),
          _buildSubmitButton(),
          const SizedBox(height: 20),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Already have an account? ',
                  style: TextStyle(color: AppColors.textDim, fontSize: 13),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pushReplacementNamed('/'),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    'Sign In',
                    style: TextStyle(
                      color: AppColors.cyan,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return CustomButton(
      onPressed: _handleSubmit,
      variant: ButtonVariant.gradient,
      gradientColors: _submitted ? [const Color(0xFF4CAF82), const Color(0xFF00D4A0)] : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_submitted)
            const Icon(Icons.check_circle, color: Colors.white, size: 20)
          else
            const SizedBox.shrink(),
          if (_submitted) const SizedBox(width: 8) else const SizedBox.shrink(),
          Flexible(
            child: Text(
              _submitted ? 'Welcome to DriveTrack!' : 'Create Account',
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          if (!_submitted) const SizedBox(width: 8) else const SizedBox.shrink(),
          if (!_submitted)
            const Icon(Icons.chevron_right, color: Colors.white, size: 20)
          else
            const SizedBox.shrink(),
        ],
      ),
    );
  }
}


class PasswordStrengthIndicator extends StatelessWidget {
  final String password;

  const PasswordStrengthIndicator({super.key, required this.password});

  @override
  Widget build(BuildContext context) {
    if (password.isEmpty) return const SizedBox.shrink();

    final checks = [
      password.length >= 8,
      RegExp(r'[A-Z]').hasMatch(password),
      RegExp(r'[0-9]').hasMatch(password),
    ];
    final score = checks.where((c) => c).length;
    final colors = [AppColors.red, AppColors.orangeSecondary, AppColors.green];
    final labels = ["Weak", "Fair", "Strong"];

    return Column(
      children: [
        const SizedBox(height: 8),
        Row(
          children: List.generate(3, (i) {
            return Expanded(
              child: Container(
                height: 3,
                margin: EdgeInsets.only(right: i == 2 ? 0 : 6),
                decoration: BoxDecoration(
                  color: i < score ? colors[score - 1] : AppColors.borderLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                _buildCheckItem(checks[0], "8+ characters"),
                const SizedBox(width: 12),
                _buildCheckItem(checks[1], "Uppercase"),
                const SizedBox(width: 12),
                _buildCheckItem(checks[2], "Number"),
              ],
            ),
            if (score > 0)
              Text(
                labels[score - 1],
                style: TextStyle(
                  fontSize: 11,
                  color: colors[score - 1],
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildCheckItem(bool ok, String label) {
    return Row(
      children: [
        Icon(
          Icons.check_circle,
          size: 10,
          color: ok ? AppColors.green : AppColors.textDim,
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: ok ? AppColors.green : AppColors.textDim,
          ),
        ),
      ],
    );
  }
}
