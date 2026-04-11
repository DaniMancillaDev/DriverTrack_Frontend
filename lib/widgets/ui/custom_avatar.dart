import '../../theme/app_color_scheme.dart';

/// Orquestador de identidad visual para usuarios y activos de flota.
/// 
/// Su responsabilidad es gestionar la representación gráfica mediante tres 
/// niveles de respaldo (Fallback): 
/// 1. **Imagen**: Renderizado prioritario de [imageUrl].
/// 2. **Texto**: Iniciales dinámicas basadas en [fallbackText].
/// 3. **Icono**: Glifo genérico como garantía de visualización final.
class CustomAvatar extends StatelessWidget {
  /// URL remota de la imagen de perfil.
  final String? imageUrl;
  /// Texto (ej. nombre) para generar las iniciales de respaldo.
  final String? fallbackText;
  /// Icono personalizado para mostrar si no hay imagen ni texto.
  final Widget? fallbackIcon;
  /// Radio del círculo (el diámetro será el doble).
  final double radius;
  /// Color de fondo del contenedor circular.
  final Color? backgroundColor;
  /// Color del contenido de respaldo (texto o icono).
  final Color? foregroundColor;

  const CustomAvatar({
    super.key,
    this.imageUrl,
    this.fallbackText,
    this.fallbackIcon,
    this.radius = 20,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // El color de fondo "muted"
    final bgColor = backgroundColor ?? context.colors.surfaceLight;
    final fgColor = foregroundColor ?? context.colors.textMain;

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
        style: Theme.of(
          context,
        ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
      );
    }

    if (fallbackIcon != null) {
      return fallbackIcon!;
    }

    // Por defecto, devolvemos un icono de usuario genérico si no hay fallbackText ni imageUrl válida
    if (imageUrl == null || imageUrl!.isEmpty) {
      return Icon(Icons.person, size: radius * 1.2);
    }

    // Retorna null silenciosamente si se supone que la imagen cargará (el CircleAvatar internamente ya lo maneja hasta que da error)
    return null;
  }
}
