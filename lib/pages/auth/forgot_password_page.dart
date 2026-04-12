import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/forgot_password_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/ui/custom_input.dart';
import '../../widgets/ui/custom_button.dart';
import '../../widgets/ui/password_strength_indicator.dart';
import '../../core/validation/form_validators.dart';
import '../../core/presentation/ui/snackbar_presentation.dart';
import '../../core/error/error_mapper.dart';
import '../../core/i18n/translations.g.dart';
import '../../core/responsive/responsive.dart';
import '../../theme/app_color_scheme.dart';

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage>
    with SingleTickerProviderStateMixin {
  final _pageController = PageController();

  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _showPassword = false;
  bool _showConfirmPassword = false;

  String? _emailError;
  String? _otpError;
  String? _passwordError;
  String? _confirmPasswordError;

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
    _pageController.dispose();
    _emailController.dispose();
    _otpController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _animCtrl.dispose();
    super.dispose();
  }

  void _animateToPage(int page) {
    if (_pageController.hasClients) {
      _pageController.animateToPage(
        page,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _handleRequestOtp() async {
    final t = Translations.of(context);
    setState(() {
      _emailError = FormValidators.email(_emailController.text, context);
    });
    if (_emailError != null) return;

    final success = await ref
        .read(forgotPasswordProvider.notifier)
        .requestOtp(_emailController.text.trim());

    if (success && mounted) {
      _animateToPage(1);
    } else if (mounted) {
      final errorMsg = ref.read(forgotPasswordProvider).error;
      SnackBarHelper.error(context, errorMsg ?? t.forgotPassword.errorRequestOtp);
    }
  }

  void _handleVerifyOtp() async {
    final t = Translations.of(context);
    final otp = _otpController.text.trim();
    if (otp.length != 6) {
      setState(() => _otpError = t.forgotPassword.otpInvalid);
      return;
    }
    setState(() => _otpError = null);

    final success = await ref
        .read(forgotPasswordProvider.notifier)
        .verifyOtp(otp);

    if (success && mounted) {
      _animateToPage(2);
    } else if (mounted) {
      final errorMsg = ref.read(forgotPasswordProvider).error;
      SnackBarHelper.error(context, errorMsg ?? t.forgotPassword.errorVerifyOtp);
    }
  }

  void _handleResetPassword() async {
    final t = Translations.of(context);
    setState(() {
      _passwordError = FormValidators.password(_passwordController.text, context);
      _confirmPasswordError = _passwordController.text != _confirmPasswordController.text
          ? t.forgotPassword.passwordsMismatch
          : null;
    });
    if (_passwordError != null || _confirmPasswordError != null) return;

    final success = await ref
        .read(forgotPasswordProvider.notifier)
        .resetPassword(_passwordController.text);

    if (success && mounted) {
      _animateToPage(3);
    } else if (mounted) {
      final errorMsg = ref.read(forgotPasswordProvider).error;
      SnackBarHelper.error(context, errorMsg ?? t.forgotPassword.errorResetPassword);
    }
  }

  // ─── Current step metadata ────────────────────────────────────

  _StepMeta _metaFor(ForgotPasswordStep step, Translations t) {
    switch (step) {
      case ForgotPasswordStep.requestEmail:
        return _StepMeta(
          icon: Icons.lock_reset_rounded,
          title: t.forgotPassword.titleStep1,
          subtitle: t.forgotPassword.subtitleStep1,
          isSuccess: false,
        );
      case ForgotPasswordStep.verifyOtp:
        return _StepMeta(
          icon: Icons.mark_email_read_rounded,
          title: t.forgotPassword.titleStep2,
          subtitle: t.forgotPassword.subtitleStep2,
          isSuccess: false,
        );
      case ForgotPasswordStep.resetPassword:
        return _StepMeta(
          icon: Icons.password_rounded,
          title: t.forgotPassword.titleStep3,
          subtitle: t.forgotPassword.subtitleStep3,
          isSuccess: false,
        );
      case ForgotPasswordStep.success:
        return _StepMeta(
          icon: Icons.check_circle_rounded,
          title: t.forgotPassword.titleSuccess,
          subtitle: t.forgotPassword.subtitleSuccess,
          isSuccess: true,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(forgotPasswordProvider);
    final t = Translations.of(context);
    final r = context.responsive;
    final meta = _metaFor(state.step, t);

    return Scaffold(
      backgroundColor: context.colors.background,
      body: Stack(
        children: [
          // ── Resplandor radial de fondo (igual que LoginPage) ──────
          Positioned(
            top: -100,
            left: -80,
            right: -80,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 600),
              height: r.dim(350),
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0, -0.6),
                  radius: 0.9,
                  colors: [
                    (meta.isSuccess ? AppColors.green : AppColors.orangePrimary)
                        .withValues(alpha: 0.12),
                    (meta.isSuccess ? AppColors.green : AppColors.orangePrimary)
                        .withValues(alpha: 0.03),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // ── Contenido principal ────────────────────────────────────
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: r.space(AppSpacing.lg)),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: r.value(mobile: 400, tablet: 480),
                  ),
                  child: FadeTransition(
                    opacity: _fadeAnim,
                    child: SlideTransition(
                      position: _slideAnim,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: r.space(AppSpacing.xxl)),
                          _buildLogo(r, meta),
                          SizedBox(height: r.space(AppSpacing.xl)),
                          _buildHeader(meta),
                          SizedBox(height: r.space(AppSpacing.xxl)),
                          // ── PageView con los 4 pasos ───────────────
                          SizedBox(
                            height: r.dim(_pageHeight(state.step, r)),
                            child: PageView(
                              controller: _pageController,
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                _buildEmailStep(state, r),
                                _buildOtpStep(state, r),
                                _buildNewPasswordStep(state, r),
                                _buildSuccessStep(r),
                              ],
                            ),
                          ),
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
                onPressed: () {
                  if (state.step == ForgotPasswordStep.requestEmail ||
                      state.step == ForgotPasswordStep.success) {
                    context.pop();
                  } else {
                    ref.read(forgotPasswordProvider.notifier).reset();
                    context.pop();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Altura dinámica según contexto del paso
  double _pageHeight(ForgotPasswordStep step, AppResponsive r) {
    switch (step) {
      case ForgotPasswordStep.requestEmail:
        return r.isMobile ? 220 : 240;
      case ForgotPasswordStep.verifyOtp:
        return r.isMobile ? 220 : 240;
      case ForgotPasswordStep.resetPassword:
        return r.isMobile ? 400 : 430;
      case ForgotPasswordStep.success:
        return r.isMobile ? 280 : 300;
    }
  }

  // ─── Logo (halo + icono) ──────────────────────────────────────

  Widget _buildLogo(AppResponsive r, _StepMeta meta) {
    final logoSize = r.dim(88);
    final glowColor = meta.isSuccess ? AppColors.green : AppColors.orangePrimary;
    final gradient = meta.isSuccess
        ? const LinearGradient(
            colors: [AppColors.green, Colors.greenAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
        : AppColors.primaryGradient;

    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          width: logoSize + 24,
          height: logoSize + 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: glowColor.withValues(alpha: 0.15),
              width: 1.5,
            ),
          ),
          child: Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              width: logoSize,
              height: logoSize,
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(r.r(AppRadius.xxl)),
                boxShadow: [
                  BoxShadow(
                    color: glowColor.withValues(alpha: 0.38),
                    blurRadius: 36,
                    offset: const Offset(0, 14),
                  ),
                ],
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                transitionBuilder: (child, anim) =>
                    ScaleTransition(scale: anim, child: child),
                child: Icon(
                  meta.icon,
                  key: ValueKey(meta.icon),
                  color: Colors.white,
                  size: AppIconSizes.huge(context),
                ),
              ),
            ),
          ),
        ),

      ],
    );
  }

  // ─── Header title + subtitle ──────────────────────────────────

  Widget _buildHeader(_StepMeta meta) {
    return Column(
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Text(
            meta.title,
            key: ValueKey(meta.title),
            textAlign: TextAlign.center,
            style: AppTextStyles.headline(context).copyWith(
              color: context.colors.textMain,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),
        ),
        SizedBox(height: context.responsive.space(AppSpacing.xs)),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Text(
            meta.subtitle,
            key: ValueKey(meta.subtitle),
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySmall(context)
                .copyWith(color: context.colors.textSecondary),
          ),
        ),
      ],
    );
  }

  // ─── Paso 1: Email ────────────────────────────────────────────

  Widget _buildEmailStep(ForgotPasswordState state, AppResponsive r) {
    final t = Translations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomInput(
          controller: _emailController,
          label: t.forgotPassword.emailLabel,
          placeholder: t.forgotPassword.emailPlaceholder,
          keyboardType: TextInputType.emailAddress,
          errorText: _emailError,
          prefixIcon: Icon(
            Icons.mail_outline_rounded,
            size: AppIconSizes.md(context),
            color: context.colors.textMuted,
          ),
          onChanged: (_) {
            if (_emailError != null) {
              setState(() =>
                  _emailError = FormValidators.email(_emailController.text, context));
            }
          },
        ),
        SizedBox(height: r.space(AppSpacing.lg)),
        CustomButton(
          onPressed: _handleRequestOtp,
          variant: ButtonVariant.gradient,
          isLoading: state.isLoading,
          child: Text(t.forgotPassword.sendCode,
              style: AppTextStyles.button(context).copyWith(color: Colors.white)),
        ),
      ],
    );
  }

  // ─── Paso 2: OTP ─────────────────────────────────────────────

  Widget _buildOtpStep(ForgotPasswordState state, AppResponsive r) {
    final t = Translations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomInput(
          controller: _otpController,
          label: t.forgotPassword.otpLabel,
          placeholder: t.forgotPassword.otpPlaceholder,
          keyboardType: TextInputType.number,
          maxLength: 6,
          errorText: _otpError,
          subHint: _otpError == null ? t.forgotPassword.otpHint : null,
          prefixIcon: Icon(
            Icons.pin_outlined,
            size: AppIconSizes.md(context),
            color: context.colors.textMuted,
          ),
          onChanged: (_) {
            if (_otpError != null && _otpController.text.trim().length == 6) {
              setState(() => _otpError = null);
            }
          },
        ),
        SizedBox(height: r.space(AppSpacing.lg)),
        CustomButton(
          onPressed: _handleVerifyOtp,
          variant: ButtonVariant.gradient,
          isLoading: state.isLoading,
          child: Text(t.forgotPassword.verifyCode,
              style: AppTextStyles.button(context).copyWith(color: Colors.white)),
        ),
      ],
    );
  }

  // ─── Paso 3: Nueva contraseña ─────────────────────────────────

  Widget _buildNewPasswordStep(ForgotPasswordState state, AppResponsive r) {
    final t = Translations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomInput(
          controller: _passwordController,
          label: t.forgotPassword.newPasswordLabel,
          placeholder: t.forgotPassword.passwordPlaceholder,
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
        SizedBox(height: r.space(AppSpacing.md)),
        CustomInput(
          controller: _confirmPasswordController,
          label: t.forgotPassword.confirmPasswordLabel,
          placeholder: t.forgotPassword.passwordPlaceholder,
          obscureText: !_showConfirmPassword,
          errorText: _confirmPasswordError,
          prefixIcon: Icon(Icons.lock_reset_rounded,
              size: AppIconSizes.md(context), color: context.colors.textMuted),
          suffixIcon: GestureDetector(
            onTap: () => setState(() => _showConfirmPassword = !_showConfirmPassword),
            child: Icon(
              _showConfirmPassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              size: AppIconSizes.md(context),
              color: context.colors.textMuted,
            ),
          ),
          onChanged: (_) {
            if (_confirmPasswordError != null &&
                _passwordController.text == _confirmPasswordController.text) {
              setState(() => _confirmPasswordError = null);
            }
          },
        ),
        SizedBox(height: r.space(AppSpacing.lg)),
        CustomButton(
          onPressed: _handleResetPassword,
          variant: ButtonVariant.gradient,
          isLoading: state.isLoading,
          child: Text(t.forgotPassword.updatePassword,
              style: AppTextStyles.button(context).copyWith(color: Colors.white)),
        ),
      ],
    );
  }

  // ─── Paso 4: Éxito ────────────────────────────────────────────

  Widget _buildSuccessStep(AppResponsive r) {
    final t = Translations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 600),
          curve: Curves.elasticOut,
          builder: (context, value, _) => Transform.scale(
            scale: value,
            child: Container(
              padding: EdgeInsets.all(r.space(AppSpacing.lg)),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.green.withValues(alpha: 0.1),
                border: Border.all(
                    color: AppColors.green.withValues(alpha: 0.3), width: 2),
              ),
              child: Icon(Icons.check_circle_rounded,
                  size: r.dim(64), color: AppColors.green),
            ),
          ),
        ),
        SizedBox(height: r.space(AppSpacing.xl)),
        Text(
          t.forgotPassword.successMessage,
          textAlign: TextAlign.center,
          style: AppTextStyles.bodySmall(context)
              .copyWith(color: context.colors.textSecondary),
        ),
        SizedBox(height: r.space(AppSpacing.xl)),
        CustomButton(
          onPressed: () => context.pop(),
          gradientColors: [
            AppColors.green,
            AppColors.green.withValues(alpha: 0.8),
          ],
          child: Text(t.forgotPassword.goToLogin,
              style: AppTextStyles.button(context).copyWith(color: Colors.white)),
        ),
      ],
    );
  }
}

// ─── Metadata del paso ─────────────────────────────────────────────────────

class _StepMeta {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isSuccess;

  const _StepMeta({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSuccess,
  });
}
