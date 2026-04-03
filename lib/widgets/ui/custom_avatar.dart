import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class CustomAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? fallbackText;
  final Widget? fallbackIcon;
  final double radius;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const CustomAvatar({
    super.key,
    this.imageUrl,
    this.fallbackText,
    this.fallbackIcon,
    this.radius = 20, // Aproximadamente size-10 (40px de diámetro)
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    // El color de fondo "muted"
    final bgColor = backgroundColor ?? AppColors.surfaceLight;
    final fgColor = foregroundColor ?? AppColors.textMain;

    return CircleAvatar(
      radius: radius,
      backgroundColor: bgColor,
      foregroundColor: fgColor,
      // Si la imagen existe, proveemos un NetworkImage; CircleAvatar maneja el error internamente mostrando el child
      backgroundImage: imageUrl != null && imageUrl!.isNotEmpty
          ? NetworkImage(imageUrl!)
          : null,
      onBackgroundImageError: imageUrl != null && imageUrl!.isNotEmpty
          ? (exception, stackTrace) {
              // Flutter llamará este callback si la imagen falla pero a la vez dibujará el 'child' subyacente
            }
          : null,
      // El contenido de respaldo (Fallback)
      child: _buildFallback(context),
    );
  }

  Widget? _buildFallback(BuildContext context) {
    // Si tenemos una imagen (pero falla) o no la tenemos, esto se renderiza como fondo
    if (fallbackText != null && fallbackText!.isNotEmpty) {
      // Tomamos hasta 2 caracteres del texto de respaldo
      final String displayInitials = fallbackText!.length > 2
          ? fallbackText!.substring(0, 2).toUpperCase()
          : fallbackText!.toUpperCase();

      return Text(
        displayInitials,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
      );
    }

    if (fallbackIcon != null) {
      return fallbackIcon!;
    }

    // Por defecto, devolvemos un icono de usuario genérico si no hay fallbackText ni imageUrl válida
    if (imageUrl == null || imageUrl!.isEmpty) {
      return Icon(
        Icons.person,
        size: radius * 1.2,
      );
    }

    // Retorna null silenciosamente si se supone que la imagen cargará (el CircleAvatar internamente ya lo maneja hasta que da error)
    return null;
  }
}
