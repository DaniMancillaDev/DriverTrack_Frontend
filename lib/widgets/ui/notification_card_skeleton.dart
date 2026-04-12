import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../core/responsive/responsive.dart';
import '../../theme/app_color_scheme.dart';
import 'skeleton_loader.dart';

/// Marcador de posición (skeleton) para la tarjeta de notificación.
/// 
/// Replica la estructura visual de [NotificationCard] utilizando [SkeletonLoader] 
/// para proporcionar feedback visual inmediato mientras se obtienen las 
/// notificaciones del servidor.
class NotificationCardSkeleton extends StatelessWidget {
  const NotificationCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final r = context.responsive;

    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Padding(
        padding: EdgeInsets.all(r.space(AppSpacing.lg)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Marcador de posición del icono
            SkeletonLoader(
              width: r.dim(38),
              height: r.dim(38),
              borderRadius: r.r(12),
            ),
            SizedBox(width: r.space(AppSpacing.s)),
            
            // Marcadores de posición del contenido
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título
                  SkeletonLoader(
                    width: r.dim(160),
                    height: r.dim(14),
                  ),
                  SizedBox(height: r.space(10)),
                  
                  // Línea 1 del mensaje
                  SkeletonLoader(
                    width: double.infinity,
                    height: r.dim(12),
                  ),
                  SizedBox(height: r.space(6)),
                  
                  // Línea 2 del mensaje
                  SkeletonLoader(
                    width: r.dim(120),
                    height: r.dim(12),
                  ),
                  SizedBox(height: r.space(12)),
                  
                  // Fila de marca temporal
                  Row(
                    children: [
                      SkeletonLoader(
                        width: r.dim(5),
                        height: r.dim(5),
                        borderRadius: 10,
                      ),
                      SizedBox(width: r.space(4)),
                      SkeletonLoader(
                        width: r.dim(40),
                        height: r.dim(10),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
