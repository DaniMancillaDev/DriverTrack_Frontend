import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../core/responsive/responsive.dart';
import '../../core/i18n/translations.g.dart';
import '../../theme/app_color_scheme.dart';

/// Indicador visual de fortaleza de contraseña.
///
/// Muestra 3 segmentos de color y checks de requisitos mínimos:
/// 8+ caracteres, mayúscula y número. Si la contraseña está vacía,
/// retorna un widget vacío para no ocupar espacio.
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
                  color: i < score ? colors[score - 1] : context.colors.borderLight,
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
                  _buildCheckItem(
                    context,
                    checks[0],
                    t.registration.passwordCheck8Chars,
                  ),
                  SizedBox(width: r.space(AppSpacing.s)),
                  _buildCheckItem(
                    context,
                    checks[1],
                    t.registration.passwordCheckUppercase,
                  ),
                  SizedBox(width: r.space(AppSpacing.s)),
                  _buildCheckItem(
                    context,
                    checks[2],
                    t.registration.passwordCheckNumber,
                  ),
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
          color: ok ? AppColors.green : context.colors.textDim,
        ),
        SizedBox(width: context.responsive.space(4)),
        Flexible(
          child: Text(
            label,
            style: AppTextStyles.label(context).copyWith(
              color: ok ? AppColors.green : context.colors.textDim,
              fontWeight: FontWeight.w400,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
