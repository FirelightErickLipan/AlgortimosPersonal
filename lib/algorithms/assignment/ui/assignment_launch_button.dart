import 'package:flutter/material.dart';

import '../../../ui/screens/application_screen.dart';

/// Botón que lleva a la pestaña Aplicación (grafo de delivery ya resuelto).
class AssignmentLaunchButton extends StatelessWidget {
  final String label;
  final IconData icon;

  const AssignmentLaunchButton({
    super.key,
    this.label = 'Ver la aplicación con la solución',
    this.icon = Icons.assignment_turned_in_rounded,
  });

  @override
  Widget build(BuildContext context) {
    const accentColor = Color(0xFF7C4DFF);
    final isMobile = MediaQuery.of(context).size.width < 600;

    return ElevatedButton.icon(
      onPressed: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const ApplicationScreen()),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: accentColor,
        elevation: 3,
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16 : 26,
          vertical: isMobile ? 12 : 14,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      icon: Icon(icon, size: isMobile ? 18 : 20),
      label: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: isMobile ? 13 : 14,
        ),
      ),
    );
  }
}
