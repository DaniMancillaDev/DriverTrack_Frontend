import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/ui/custom_input.dart';
import '../widgets/ui/custom_button.dart';
import '../utils/form_validators.dart';
import '../core/i18n/translations.g.dart';
import '../core/responsive/responsive.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _showPassword = false;
  bool _isLoading = false;
  String? _emailError;
  String? _passwordError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    setState(() {
      _emailError = FormValidators.email(_emailController.text, context);
      _passwordError = FormValidators.password(_passwordController.text, context, isLogin: true);
    });

    if (_emailError == null && _passwordError == null) {
      setState(() => _isLoading = true);

      try {
        await ref
            .read(authProvider.notifier)
            .login(_emailController.text.trim(), _passwordController.text);
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
            padding: EdgeInsets.symmetric(horizontal: r.space(AppSpacing.lg)),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: r.value(mobile: 400, tablet: 480)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLogo(r),
                  SizedBox(height: r.space(AppSpacing.xxxl)),
                  _buildHeader(),
                  SizedBox(height: r.space(AppSpacing.xl)),
                  _buildLoginForm(r),
                  SizedBox(height: r.space(AppSpacing.lg)),
                  _buildFooterLinks(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo(AppResponsive r) {
    final logoSize = r.dim(80);
    return Container(
      width: logoSize,
      height: logoSize,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(r.r(AppRadius.xl)),
        boxShadow: [
          BoxShadow(
            color: AppColors.orangePrimary.withValues(alpha: 0.3),
            blurRadius: 32,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Icon(Icons.directions_car, color: Colors.white, size: AppIconSizes.huge(context)),
    );
  }

  Widget _buildHeader() {
    final t = Translations.of(context);
    return Column(
      children: [
        Text(
          t.auth.welcomeBack,
          style: AppTextStyles.headline(context).copyWith(
            color: AppColors.textMain,
          ),
        ),
        SizedBox(height: context.responsive.space(AppSpacing.xs)),
        Text(
          t.auth.signInSubtitle,
          textAlign: TextAlign.center,
          style: AppTextStyles.bodySmall(context).copyWith(
            color: AppColors.textSecondary,
          ),
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
              Icons.mail_outline,
              size: AppIconSizes.md(context),
              color: AppColors.textMuted,
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
          ),
          SizedBox(height: r.space(AppSpacing.s)),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {},
              child: Text(
                t.auth.forgotPassword,
                style: AppTextStyles.bodySmall(context).copyWith(
                  color: AppColors.cyan,
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
            style: AppTextStyles.bodySmall(context).copyWith(
              color: AppColors.textSecondary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        TextButton(
          onPressed: () =>
              Navigator.of(context).pushReplacementNamed('/registration'),
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
          ),
          child: Text(
            t.auth.signUp,
            style: AppTextStyles.bodyMedium(context).copyWith(
              color: AppColors.cyan,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
