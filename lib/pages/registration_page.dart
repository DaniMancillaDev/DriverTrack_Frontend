import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/ui/custom_input.dart';
import '../widgets/ui/custom_button.dart';
import '../utils/form_validators.dart';
import '../core/i18n/translations.g.dart';
import '../core/responsive/responsive.dart';

class RegistrationPage extends ConsumerStatefulWidget {
  const RegistrationPage({super.key});

  @override
  ConsumerState<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends ConsumerState<RegistrationPage> {
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _showPassword = false;
  bool _submitted = false;
  bool _isLoading = false;

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

  void _handleSubmit() async {
    setState(() {
      _fullNameError = FormValidators.fullName(_fullNameController.text, context);
      _phoneError = FormValidators.phone(_phoneController.text, context);
      _emailError = FormValidators.email(_emailController.text, context);
      _birthDateError = FormValidators.birthDate(_birthDateController.text, context);
      _passwordError = FormValidators.password(_passwordController.text, context);
    });

    if (_fullNameError == null &&
        _phoneError == null &&
        _emailError == null &&
        _birthDateError == null &&
        _passwordError == null) {
      setState(() => _isLoading = true);
      try {
        await ref
            .read(authProvider.notifier)
            .register(
              _emailController.text.trim(),
              _passwordController.text,
              _fullNameController.text.trim(),
            );

        if (mounted) {
          setState(() => _submitted = true);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString().replaceAll('Exception: ', '')),
              backgroundColor: AppColors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final r = context.responsive;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: r.value(mobile: 600, tablet: 640)),
              child: Column(
                children: [
                  _buildHeader(r),
                  _buildFormCard(r),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(AppResponsive r) {
    final t = Translations.of(context);
    final isMobile = r.isMobile;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: isMobile ? r.space(AppSpacing.xl) : r.space(AppSpacing.xxxl),
        bottom: isMobile ? r.space(AppSpacing.xl) : r.space(AppSpacing.xxl),
        left: r.space(AppSpacing.lg),
        right: r.space(AppSpacing.lg),
      ),
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: const Alignment(0, -1),
          radius: 0.8,
          colors: [
            AppColors.orangePrimary.withValues(alpha: 0.12),
            Colors.transparent,
          ],
        ),
      ),
      child: Column(
        children: [
          Container(
            width: r.dim(isMobile ? 56 : 64),
            height: r.dim(isMobile ? 56 : 64),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(r.r(AppRadius.xl)),
              boxShadow: [
                BoxShadow(
                  color: AppColors.orangePrimary.withValues(alpha: 0.35),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Icon(
              Icons.directions_car,
              color: Colors.white,
              size: AppIconSizes.xxl(context),
            ),
          ),
          SizedBox(height: r.space(AppSpacing.s)),
          Text(
            t.common.appName,
            style: AppTextStyles.headline(context).copyWith(
              color: AppColors.textMain,
              fontSize: r.sp(26),
            ),
          ),
          SizedBox(height: r.space(AppSpacing.xxs)),
          Text(
            t.registration.appTagline,
            style: AppTextStyles.bodySmall(context).copyWith(
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormCard(AppResponsive r) {
    final t = Translations.of(context);
    final isMobile = r.isMobile;
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: isMobile ? r.space(AppSpacing.s) : r.space(AppSpacing.lg),
        vertical: isMobile ? r.space(AppSpacing.md) : r.space(AppSpacing.zero),
      ),
      padding: EdgeInsets.only(bottom: r.space(AppSpacing.xxxl)),
      decoration: const BoxDecoration(
        color: Colors.transparent, // Freed the inputs from a bounding border box (Tip 1)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t.registration.title,
            style: AppTextStyles.headlineMedium(context).copyWith(
              color: AppColors.textMain,
              fontSize: r.sp(isMobile ? 18 : 20),
            ),
          ),
          SizedBox(height: r.space(AppSpacing.xxs)),
          Text(
            t.registration.subtitle,
            style: AppTextStyles.caption(context).copyWith(
              color: AppColors.textSecondary,
              fontSize: r.sp(isMobile ? 12 : 13),
            ),
          ),
          SizedBox(height: r.space(AppSpacing.lg)),
          CustomInput(
            controller: _fullNameController,
            label: t.registration.fullName,
            placeholder: t.registration.fullNamePlaceholder,
            errorText: _fullNameError,
            prefixIcon: Icon(
              Icons.person_outline,
              size: AppIconSizes.md(context),
              color: AppColors.textMuted,
            ),
            onChanged: (_) {
              if (_fullNameError != null) {
                setState(
                  () => _fullNameError = FormValidators.fullName(
                    _fullNameController.text, context,
                  ),
                );
              }
            },
          ),
          SizedBox(height: r.space(AppSpacing.lg)),
          CustomInput(
            controller: _phoneController,
            label: t.registration.phoneNumber,
            placeholder: t.registration.phonePlaceholder,
            keyboardType: TextInputType.phone,
            errorText: _phoneError,
            subHint: _phoneError == null ? t.registration.phoneHint : null,
            prefixIcon: Icon(
              Icons.phone_outlined,
              size: AppIconSizes.md(context),
              color: AppColors.textMuted,
            ),
            onChanged: (_) {
              if (_phoneError != null) {
                setState(
                  () => _phoneError = FormValidators.phone(_phoneController.text, context),
                );
              }
            },
          ),
          SizedBox(height: r.space(AppSpacing.lg)),
          CustomInput(
            controller: _emailController,
            label: t.auth.emailAddress,
            placeholder: t.auth.emailPlaceholder,
            keyboardType: TextInputType.emailAddress,
            errorText: _emailError,
            prefixIcon: Icon(
              Icons.mail_outline,
              size: AppIconSizes.md(context),
              color: AppColors.textMuted,
            ),
            onChanged: (_) {
              if (_emailError != null) {
                setState(
                  () => _emailError = FormValidators.email(_emailController.text, context),
                );
              }
            },
          ),
          SizedBox(height: r.space(AppSpacing.lg)),
          CustomInput(
            controller: _birthDateController,
            label: t.registration.dateOfBirth,
            placeholder: t.registration.datePlaceholder,
            keyboardType: TextInputType.datetime,
            errorText: _birthDateError,
            prefixIcon: Icon(
              Icons.calendar_today_outlined,
              size: AppIconSizes.md(context),
              color: AppColors.textMuted,
            ),
            onChanged: (_) {
              if (_birthDateError != null) {
                setState(
                  () => _birthDateError = FormValidators.birthDate(
                    _birthDateController.text, context,
                  ),
                );
              }
            },
          ),
          SizedBox(height: r.space(AppSpacing.lg)),
          CustomInput(
            controller: _passwordController,
            label: t.auth.password,
            placeholder: t.registration.passwordPlaceholder,
            obscureText: !_showPassword,
            errorText: _passwordError,
            prefixIcon: Icon(
              Icons.lock_outline,
              size: AppIconSizes.md(context),
              color: AppColors.textMuted,
            ),
            suffixIcon: GestureDetector(
              onTap: () => setState(() => _showPassword = !_showPassword),
              child: Icon(
                _showPassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                size: AppIconSizes.md(context),
                color: AppColors.textMuted,
              ),
            ),
            onChanged: (val) {
              setState(() {
                if (_passwordError != null) {
                  _passwordError = FormValidators.password(val, context);
                }
              });
            },
          ),
          PasswordStrengthIndicator(password: _passwordController.text),
          SizedBox(height: r.space(AppSpacing.lg)),
          _buildSubmitButton(t),
          SizedBox(height: r.space(AppSpacing.md)),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    t.registration.alreadyHaveAccount,
                    style: AppTextStyles.bodySmall(context).copyWith(
                      color: AppColors.textSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                TextButton(
                  onPressed: () =>
                      Navigator.of(context).pushReplacementNamed('/'),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    t.auth.signIn,
                    style: AppTextStyles.bodySmall(context).copyWith(
                      color: AppColors.cyan,
                      fontWeight: FontWeight.w700,
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

  Widget _buildSubmitButton(Translations t) {
    return CustomButton(
      onPressed: _handleSubmit,
      variant: ButtonVariant.gradient,
      isLoading: _isLoading,
      gradientColors: _submitted
          ? [AppColors.green, AppColors.green.withValues(alpha: 0.8)]
          : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_submitted)
            Icon(Icons.check_circle, color: Colors.white, size: AppIconSizes.lg(context))
          else
            const SizedBox.shrink(),
          if (_submitted) SizedBox(width: context.responsive.space(AppSpacing.xs)) else const SizedBox.shrink(),
          Flexible(
            child: Text(
              _submitted ? t.registration.welcomeSuccess : t.registration.createAccount,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.button(context).copyWith(
                color: Colors.white,
              ),
            ),
          ),
          if (!_submitted)
            SizedBox(width: context.responsive.space(AppSpacing.xs))
          else
            const SizedBox.shrink(),
          if (!_submitted)
            Icon(Icons.chevron_right, color: Colors.white, size: AppIconSizes.lg(context))
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

    final t = Translations.of(context);
    final r = context.responsive;

    final checks = [
      password.length >= 8,
      RegExp(r'[A-Z]').hasMatch(password),
      RegExp(r'[0-9]').hasMatch(password),
    ];
    final score = checks.where((c) => c).length;
    final colors = [AppColors.red, AppColors.orangeSecondary, AppColors.green];
    final labels = [
      t.registration.passwordWeak,
      t.registration.passwordFair,
      t.registration.passwordStrong,
    ];

    return Column(
      children: [
        SizedBox(height: r.space(AppSpacing.xs)),
        Row(
          children: List.generate(3, (i) {
            return Expanded(
              child: Container(
                height: 3,
                margin: EdgeInsets.only(right: i == 2 ? 0 : r.space(6)),
                decoration: BoxDecoration(
                  color: i < score ? colors[score - 1] : AppColors.borderLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        ),
        SizedBox(height: r.space(AppSpacing.xs)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Row(
                children: [
                  _buildCheckItem(context, checks[0], t.registration.passwordCheck8Chars),
                  SizedBox(width: r.space(AppSpacing.s)),
                  _buildCheckItem(context, checks[1], t.registration.passwordCheckUppercase),
                  SizedBox(width: r.space(AppSpacing.s)),
                  _buildCheckItem(context, checks[2], t.registration.passwordCheckNumber),
                ],
              ),
            ),
            if (score > 0)
              Text(
                labels[score - 1],
                style: AppTextStyles.caption(context).copyWith(
                  color: colors[score - 1],
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildCheckItem(BuildContext context, bool ok, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.check_circle,
          size: AppIconSizes.xxs(context),
          color: ok ? AppColors.green : AppColors.textDim,
        ),
        SizedBox(width: context.responsive.space(4)),
        Flexible(
          child: Text(
            label,
            style: AppTextStyles.label(context).copyWith(
              color: ok ? AppColors.green : AppColors.textDim,
              fontWeight: FontWeight.w400,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
