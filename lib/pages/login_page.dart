import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/ui/custom_input.dart';
import '../widgets/ui/custom_button.dart';
import '../utils/form_validators.dart';
import '../utils/snackbar_helper.dart';
import 'package:go_router/go_router.dart';
import '../core/i18n/translations.g.dart';
import '../core/responsive/responsive.dart';
import '../theme/app_color_scheme.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _showPassword = false;
  bool _isLoading = false;
  String? _emailError;
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

    // Inicia la animación de entrada con un pequeño delay para que sea notoria
    Future.delayed(const Duration(milliseconds: 80), () {
      if (mounted) _animCtrl.forward();
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animCtrl.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    setState(() {
      _emailError = FormValidators.email(_emailController.text, context);
      _passwordError = FormValidators.password(
        _passwordController.text,
        context,
        isLogin: true,
      );
    });

    if (_emailError == null && _passwordError == null) {
      setState(() => _isLoading = true);

      try {
        await ref
            .read(authProvider.notifier)
            .login(_emailController.text.trim(), _passwordController.text);
      } catch (e) {
        if (mounted) {
          SnackBarHelper.error(
            context,
            e.toString().replaceAll('Exception: ', ''),
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
      backgroundColor: context.colors.background,
      body: Stack(
        children: [
          // Gradiente radial de fondo — ancla visual naranja en la parte superior
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

          // Contenido principal con animación de entrada
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding:
                    EdgeInsets.symmetric(horizontal: r.space(AppSpacing.lg)),
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
                          _buildLogo(r),
                          SizedBox(height: r.space(AppSpacing.xl)),
                          _buildHeader(),
                          SizedBox(height: r.space(AppSpacing.xxl)),
                          _buildLoginForm(r),
                          SizedBox(height: r.space(AppSpacing.xl)),
                          _buildFooterLinks(),
                          SizedBox(height: r.space(AppSpacing.lg)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo(AppResponsive r) {
    final logoSize = r.dim(88);
    return Column(
      children: [
        // Halo exterior sutil
        Container(
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
                Icons.directions_car_rounded,
                color: Colors.white,
                size: AppIconSizes.huge(context),
              ),
            ),
          ),
        ),
        SizedBox(height: r.space(AppSpacing.s)),
        // Nombre de la app debajo del logo
        Text(
          'DriverTrack',
          style: AppTextStyles.caption(context).copyWith(
            color: context.colors.textDim,
            letterSpacing: 1.8,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    final t = Translations.of(context);
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
            children: [
              TextSpan(text: t.auth.welcomeBack),
            ],
          ),
        ),
        SizedBox(height: context.responsive.space(AppSpacing.xs)),
        Text(
          t.auth.signInSubtitle,
          textAlign: TextAlign.center,
          style: AppTextStyles.bodySmall(
            context,
          ).copyWith(color: context.colors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildLoginForm(AppResponsive r) {
    final t = Translations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomInput(
          controller: _emailController,
          label: t.auth.emailAddress,
          placeholder: t.auth.emailPlaceholder,
          keyboardType: TextInputType.emailAddress,
          errorText: _emailError,
          prefixIcon: Icon(
            Icons.mail_outline_rounded,
            size: AppIconSizes.md(context),
            color: context.colors.textMuted,
          ),
        ),
        SizedBox(height: r.space(AppSpacing.md)),
        CustomInput(
          controller: _passwordController,
          label: t.auth.password,
          placeholder: '••••••••',
          obscureText: !_showPassword,
          errorText: _passwordError,
          prefixIcon: Icon(
            Icons.lock_outline_rounded,
            size: AppIconSizes.md(context),
            color: context.colors.textMuted,
          ),
          suffixIcon: GestureDetector(
            onTap: () => setState(() => _showPassword = !_showPassword),
            child: Icon(
              _showPassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              size: AppIconSizes.md(context),
              color: context.colors.textMuted,
            ),
          ),
        ),
        SizedBox(height: r.space(AppSpacing.s)),

        // Forgot password — más visible en naranja
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () {},
            child: Text(
              t.auth.forgotPassword,
              style: AppTextStyles.caption(context).copyWith(
                color: AppColors.orangeSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        SizedBox(height: r.space(AppSpacing.lg)),
        _buildLoginButton(t),
      ],
    );
  }

  Widget _buildLoginButton(Translations t) {
    return CustomButton(
      onPressed: _handleLogin,
      variant: ButtonVariant.gradient,
      isLoading: _isLoading,
      child: Text(t.auth.signIn),
    );
  }

  Widget _buildFooterLinks() {
    final t = Translations.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Text(
            t.auth.noAccount,
            style: AppTextStyles.bodySmall(
              context,
            ).copyWith(color: context.colors.textSecondary),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        TextButton(
          onPressed: () => context.go('/registration'),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            minimumSize: Size.zero,
          ),
          child: Text(
            t.auth.signUp,
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
