import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/ui/custom_input.dart';
import '../widgets/ui/custom_button.dart';
import '../widgets/ui/password_strength_indicator.dart';
import '../utils/form_validators.dart';
import '../utils/snackbar_helper.dart';
import 'package:go_router/go_router.dart';
import '../core/error/error_mapper.dart';
import '../core/i18n/translations.g.dart';
import '../core/responsive/responsive.dart';
import '../theme/app_color_scheme.dart';

class RegistrationPage extends ConsumerStatefulWidget {
  const RegistrationPage({super.key});

  @override
  ConsumerState<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends ConsumerState<RegistrationPage>
    with SingleTickerProviderStateMixin {
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

  late final AnimationController _animCtrl;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOutCubic));

    Future.delayed(const Duration(milliseconds: 80), () {
      if (mounted) _animCtrl.forward();
    });
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _birthDateController.dispose();
    _passwordController.dispose();
    _animCtrl.dispose();
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
        await ref.read(authProvider.notifier).register(
              _emailController.text.trim(),
              _passwordController.text,
              _fullNameController.text.trim(),
            );
        if (mounted) setState(() => _submitted = true);
      } catch (e) {
        if (mounted) {
          SnackBarHelper.error(context, ErrorMapper.toUserMessage(e, context));
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final r = context.responsive;

    return Scaffold(
      backgroundColor: context.colors.background,
      body: Stack(
        children: [
          // ── Resplandor radial de fondo ────────────────────────────
          Positioned(
            top: -100,
            left: -80,
            right: -80,
            child: Container(
              height: r.dim(350),
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0, -0.6),
                  radius: 0.9,
                  colors: [
                    AppColors.orangePrimary.withValues(alpha: 0.10),
                    AppColors.orangePrimary.withValues(alpha: 0.03),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // ── Contenido con animación de entrada ────────────────────
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: r.space(AppSpacing.lg)),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: r.value(mobile: 480, tablet: 520),
                  ),
                  child: FadeTransition(
                    opacity: _fadeAnim,
                    child: SlideTransition(
                      position: _slideAnim,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: r.space(AppSpacing.xxl)),
                          _buildLogo(r),
                          SizedBox(height: r.space(AppSpacing.xl)),
                          _buildHeader(t),
                          SizedBox(height: r.space(AppSpacing.xxl)),
                          _buildForm(t, r),
                          SizedBox(height: r.space(AppSpacing.lg)),
                          _buildFooter(t),
                          SizedBox(height: r.space(AppSpacing.lg)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── Botón volver flotante (no interfiere con el scroll) ────
          Positioned(
            top: 0,
            left: 0,
            child: SafeArea(
              child: BackButton(
                color: context.colors.textMain,
                onPressed: () => context.go('/login'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Logo con halo ────────────────────────────────────────────

  Widget _buildLogo(AppResponsive r) {
    final logoSize = r.dim(88);
    return Container(
      width: logoSize + 24,
      height: logoSize + 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.orangePrimary.withValues(alpha: 0.15),
          width: 1.5,
        ),
      ),
      child: Center(
        child: Container(
          width: logoSize,
          height: logoSize,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(r.r(AppRadius.xxl)),
            boxShadow: [
              BoxShadow(
                color: AppColors.orangePrimary.withValues(alpha: 0.35),
                blurRadius: 36,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: Icon(
            Icons.person_add_rounded,
            color: Colors.white,
            size: AppIconSizes.huge(context),
          ),
        ),
      ),
    );
  }

  // ─── Header ───────────────────────────────────────────────────

  Widget _buildHeader(Translations t) {
    return Column(
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: AppTextStyles.headline(context).copyWith(
              color: context.colors.textMain,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
            children: [TextSpan(text: t.registration.title)],
          ),
        ),
        SizedBox(height: context.responsive.space(AppSpacing.xs)),
        Text(
          t.registration.subtitle,
          textAlign: TextAlign.center,
          style: AppTextStyles.bodySmall(context)
              .copyWith(color: context.colors.textSecondary),
        ),
      ],
    );
  }

  // ─── Formulario ───────────────────────────────────────────────

  Widget _buildForm(Translations t, AppResponsive r) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomInput(
          controller: _fullNameController,
          label: t.registration.fullName,
          placeholder: t.registration.fullNamePlaceholder,
          errorText: _fullNameError,
          prefixIcon: Icon(Icons.person_outline_rounded,
              size: AppIconSizes.md(context), color: context.colors.textMuted),
          onChanged: (_) {
            if (_fullNameError != null) {
              setState(() => _fullNameError =
                  FormValidators.fullName(_fullNameController.text, context));
            }
          },
        ),
        SizedBox(height: r.space(AppSpacing.md)),
        CustomInput(
          controller: _phoneController,
          label: t.registration.phoneNumber,
          placeholder: t.registration.phonePlaceholder,
          keyboardType: TextInputType.phone,
          errorText: _phoneError,
          subHint: _phoneError == null ? t.registration.phoneHint : null,
          prefixIcon: Icon(Icons.phone_outlined,
              size: AppIconSizes.md(context), color: context.colors.textMuted),
          onChanged: (_) {
            if (_phoneError != null) {
              setState(() =>
                  _phoneError = FormValidators.phone(_phoneController.text, context));
            }
          },
        ),
        SizedBox(height: r.space(AppSpacing.md)),
        CustomInput(
          controller: _emailController,
          label: t.auth.emailAddress,
          placeholder: t.auth.emailPlaceholder,
          keyboardType: TextInputType.emailAddress,
          errorText: _emailError,
          prefixIcon: Icon(Icons.mail_outline_rounded,
              size: AppIconSizes.md(context), color: context.colors.textMuted),
          onChanged: (_) {
            if (_emailError != null) {
              setState(() =>
                  _emailError = FormValidators.email(_emailController.text, context));
            }
          },
        ),
        SizedBox(height: r.space(AppSpacing.md)),
        CustomInput(
          controller: _birthDateController,
          label: t.registration.dateOfBirth,
          placeholder: t.registration.datePlaceholder,
          keyboardType: TextInputType.datetime,
          errorText: _birthDateError,
          prefixIcon: Icon(Icons.calendar_today_outlined,
              size: AppIconSizes.md(context), color: context.colors.textMuted),
          onChanged: (_) {
            if (_birthDateError != null) {
              setState(() => _birthDateError =
                  FormValidators.birthDate(_birthDateController.text, context));
            }
          },
        ),
        SizedBox(height: r.space(AppSpacing.md)),
        CustomInput(
          controller: _passwordController,
          label: t.auth.password,
          placeholder: t.registration.passwordPlaceholder,
          obscureText: !_showPassword,
          errorText: _passwordError,
          prefixIcon: Icon(Icons.lock_outline_rounded,
              size: AppIconSizes.md(context), color: context.colors.textMuted),
          suffixIcon: GestureDetector(
            onTap: () => setState(() => _showPassword = !_showPassword),
            child: Icon(
              _showPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
              size: AppIconSizes.md(context),
              color: context.colors.textMuted,
            ),
          ),
          onChanged: (val) {
            setState(() {
              if (_passwordError != null)
                _passwordError = FormValidators.password(val, context);
            });
          },
        ),
        PasswordStrengthIndicator(password: _passwordController.text),
        SizedBox(height: r.space(AppSpacing.lg)),
        _buildSubmitButton(t),
      ],
    );
  }

  // ─── Botón de envío ───────────────────────────────────────────

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
          if (_submitted)
            SizedBox(width: context.responsive.space(AppSpacing.xs))
          else
            const SizedBox.shrink(),
          Flexible(
            child: Text(
              _submitted ? t.registration.welcomeSuccess : t.registration.createAccount,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.button(context).copyWith(color: Colors.white),
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

  // ─── Footer ───────────────────────────────────────────────────

  Widget _buildFooter(Translations t) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Text(
            t.registration.alreadyHaveAccount,
            style: AppTextStyles.bodySmall(context)
                .copyWith(color: context.colors.textSecondary),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        TextButton(
          onPressed: () => context.go('/login'),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            minimumSize: Size.zero,
          ),
          child: Text(
            t.auth.signIn,
            style: AppTextStyles.bodyMedium(context).copyWith(
              color: AppColors.orangePrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}
