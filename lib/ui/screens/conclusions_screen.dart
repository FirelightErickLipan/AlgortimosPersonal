import 'package:flutter/material.dart';

import '../widgets/web_explanation_navbar.dart';
import 'widgets/project/project_page.dart';

/// Pestaña 6 — Conclusiones.
class ConclusionsScreen extends StatelessWidget {
  const ConclusionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProjectPage(
      activePage: ExplanationWebPage.conclusiones,
      badge: 'CONCLUSIONES',
      title: '¿Se puede llevar a la vida real? Sí, y con resultados medibles',
      children: [
        ProjectParagraph(
          'Después de modelar el problema, estudiar el algoritmo y construir la aplicación, estas son las conclusiones del proyecto. '
          'La idea central: asignar bien no requiere más repartidores ni más dinero, solo una mejor decisión.',
        ),
        SizedBox(height: 24),
        ProjectResponsiveGrid(
          columns: 3,
          children: [
            ProjectStat(
              value: '15 min',
              label: 'tiempo total óptimo encontrado por el Método Húngaro',
              icon: Icons.verified_rounded,
              color: Color(0xFF1B8A5A),
            ),
            ProjectStat(
              value: '−25 %',
              label: 'frente a la asignación intuitiva de 20 minutos',
              icon: Icons.trending_down_rounded,
              color: Color(0xFFE8710A),
            ),
            ProjectStat(
              value: 'O(n³)',
              label: 'complejidad: apta para cientos de repartidores y pedidos',
              icon: Icons.speed_rounded,
            ),
          ],
        ),
        SizedBox(height: 24),
        ProjectFigure(
          assetPath: 'assets/images/before_after.png',
          caption:
              'Figura 6. Resultado del proyecto: la misma flota y los mismos pedidos, con 5 minutos menos de tiempo total gracias a la asignación óptima.',
        ),
        ProjectSectionTitle(
          'Conclusiones principales',
          kicker: 'RESULTADOS',
        ),
        ProjectCard(
          icon: Icons.check_circle_outline_rounded,
          title: 'Lo que se logró',
          child: ProjectList(
            items: [
              'El problema de delivery se modeló correctamente como un grafo bipartito con pesos y se resolvió con el Método Húngaro.',
              'El algoritmo encontró la asignación óptima R1→P2, R2→P4, R3→P3, R4→P1 con un tiempo total de 15 minutos, un 25 % menos que la asignación intuitiva (20 min). El resultado coincide con el de la fuerza bruta sobre las 24 combinaciones.',
              'La aplicación web permite ver el grafo ya resuelto, mover los nodos para explorarlo y revisar el paso a paso, lo que facilita entender por qué la solución es óptima.',
              'Con complejidad O(n³), el método es aplicable a problemas reales de decenas o cientos de recursos, donde probar todas las combinaciones (n!) es imposible.',
            ],
          ),
        ),
        ProjectSectionTitle(
          'De la teoría a la vida real',
          kicker: 'APLICABILIDAD',
        ),
        ProjectParagraph(
          'El ejercicio de delivery es un ejemplo, pero la estructura del problema (asignar recursos a tareas con un costo para cada pareja, de forma 1 a 1) aparece en muchos sectores. '
          'Cambiando solo el significado de las filas, las columnas y el costo, el mismo algoritmo y la misma aplicación sirven para otros casos.',
        ),
        SizedBox(height: 18),
        ProjectFigure(
          assetPath: 'assets/images/real_world_uses.png',
          caption:
              'Figura 7. Otros problemas reales con la misma estructura que el reparto de pedidos.',
        ),
        SizedBox(height: 20),
        ProjectResponsiveGrid(
          columns: 2,
          children: [
            ProjectCard(
              icon: Icons.local_taxi_outlined,
              title: 'Transporte y logística',
              child: ProjectParagraph(
                'Asignar conductores de taxi o de apps de transporte a pasajeros, camiones a rutas o repartidores a pedidos, minimizando tiempos de llegada o distancia.',
              ),
            ),
            ProjectCard(
              icon: Icons.local_hospital_outlined,
              title: 'Emergencias y salud',
              child: ProjectParagraph(
                'Asignar ambulancias a emergencias o personal médico a turnos, donde reducir minutos puede ser decisivo.',
              ),
            ),
            ProjectCard(
              icon: Icons.school_outlined,
              title: 'Educación y empresas',
              child: ProjectParagraph(
                'Asignar docentes a cursos y aulas, o empleados a turnos y proyectos, minimizando conflictos o costos.',
              ),
            ),
            ProjectCard(
              icon: Icons.precision_manufacturing_outlined,
              title: 'Industria',
              child: ProjectParagraph(
                'Asignar máquinas a trabajos o lotes a celdas de producción, reduciendo tiempos de preparación y de fabricación.',
              ),
            ),
          ],
        ),
        ProjectSectionTitle(
          'Limitaciones',
          kicker: 'LO QUE FALTA',
        ),
        ProjectCard(
          icon: Icons.warning_amber_rounded,
          title: 'Qué no resuelve este proyecto',
          child: ProjectList(
            items: [
              'Asume costos fijos y conocidos; si los tiempos cambian en tiempo real (tráfico, lluvia), la matriz debe recalcularse cada vez.',
              'Resuelve asignación 1 a 1; si un repartidor puede llevar varios pedidos a la vez, se necesita el problema de transporte o de ruteo de vehículos.',
              'No considera prioridades, ventanas horarias ni capacidad de carga de cada repartidor.',
              'El ejercicio es de tamaño pequeño (4 × 4); con miles de pedidos simultáneos se requeriría una implementación optimizada y datos reales.',
            ],
          ),
        ),
        ProjectSectionTitle(
          'Trabajo futuro',
          kicker: 'PRÓXIMOS PASOS',
        ),
        ProjectCard(
          icon: Icons.rocket_launch_outlined,
          title: 'Cómo se podría mejorar',
          child: ProjectList(
            items: [
              'Conectar la aplicación con datos reales (GPS y servicios de mapas) para calcular la matriz de tiempos automáticamente.',
              'Recalcular la asignación de forma periódica a medida que llegan nuevos pedidos.',
              'Agregar restricciones adicionales: prioridad de clientes, capacidad y tipo de vehículo.',
              'Medir el ahorro con datos históricos de una empresa real para validar el 25 % obtenido en el ejercicio.',
            ],
          ),
        ),
        SizedBox(height: 28),
        ProjectCallout(
          icon: Icons.emoji_objects_outlined,
          text:
              'Conclusión final: un algoritmo bien elegido convierte una decisión intuitiva en una decisión óptima y demostrable. '
              'El Método Húngaro, visto en clase, no es solo teoría: se puede llevar a una aplicación real que ahorra tiempo, dinero y mejora la experiencia del cliente.',
        ),
      ],
    );
  }
}
