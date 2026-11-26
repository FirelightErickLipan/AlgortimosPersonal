import 'package:flutter/material.dart';

import '../../algorithms/assignment/domain/services/delivery_solution.dart';
import '../widgets/web_explanation_navbar.dart';
import 'widgets/assignment/cost_matrix_table.dart';
import 'widgets/assignment/delivery_exercise_data.dart';
import 'widgets/assignment/delivery_graph_view.dart';
import 'widgets/project/project_page.dart';

/// Pestaña 5 — Aplicación: muestra directamente el grafo del problema de
/// delivery con la solución óptima ya calculada (Método Húngaro). Los nodos
/// se pueden arrastrar para explorar el grafo.
class ApplicationScreen extends StatefulWidget {
  const ApplicationScreen({super.key});

  @override
  State<ApplicationScreen> createState() => _ApplicationScreenState();
}

class _ApplicationScreenState extends State<ApplicationScreen> {
  late final DeliverySolution _solution;

  @override
  void initState() {
    super.initState();
    _solution = DeliverySolution.solve();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final total = _solution.totalMinutes;
    final intuitive = DeliveryExercise.intuitiveTotal;
    final saved = intuitive - total;
    final percent = (saved * 100 / intuitive).round();

    return ProjectPage(
      activePage: ExplanationWebPage.aplicacion,
      badge: 'APLICACIÓN',
      title: 'Aplicación interactiva: el grafo de entregas ya resuelto',
      children: [
        const ProjectParagraph(
          'Esta es la herramienta que desarrollé para el problema de delivery. Abajo se ve el grafo bipartito del ejercicio: '
          'a la izquierda los 4 repartidores (Origen), a la derecha los 4 pedidos (Destino) y en cada arista el tiempo en minutos. '
          'El Método Húngaro ya se ejecutó y las aristas verdes son la asignación óptima.',
        ),
        const SizedBox(height: 20),
        DeliveryGraphView(solution: _solution),
        const SizedBox(height: 24),
        ProjectResponsiveGrid(
          columns: 3,
          children: [
            ProjectStat(
              value: 'Z = $total min',
              label: 'tiempo total mínimo de entrega (solución óptima)',
              icon: Icons.verified_rounded,
              color: const Color(0xFF1B8A5A),
            ),
            ProjectStat(
              value: '$intuitive min',
              label: 'tiempo con la asignación intuitiva (R1→P2, R2→P1, R3→P3, R4→P4)',
              icon: Icons.timer_outlined,
              color: const Color(0xFFC62828),
            ),
            ProjectStat(
              value: '−$saved min (−$percent %)',
              label: 'ahorro al usar el Método Húngaro con los mismos recursos',
              icon: Icons.trending_down_rounded,
              color: const Color(0xFFE8710A),
            ),
          ],
        ),
        const ProjectSectionTitle(
          'Cómo usar la aplicación',
          kicker: 'GUÍA RÁPIDA',
        ),
        const ProjectCard(
          icon: Icons.list_alt_rounded,
          title: 'Qué puedes hacer en el grafo',
          child: ProjectList(
            numbered: true,
            items: [
              'Observa las aristas verdes: son las 4 parejas repartidor–pedido que dan el menor tiempo total.',
              'Arrastra cualquier nodo (R1–R4 o P1–P4) para reubicarlo y ver mejor las conexiones. Las aristas lo siguen.',
              'Usa "Mostrar todas las aristas" para ocultar las combinaciones descartadas y ver solo la solución.',
              'Pulsa "Restablecer posiciones" para volver a la disposición original.',
              'Baja para revisar la matriz de costos y el paso a paso del algoritmo.',
            ],
          ),
        ),
        const ProjectSectionTitle(
          'Resultado de la asignación',
          kicker: 'SOLUCIÓN',
        ),
        ProjectResponsiveGrid(
          columns: 2,
          children: [
            ProjectCard(
              icon: Icons.alt_route_rounded,
              title: 'Quién lleva cada pedido',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final p in _solution.pairs)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle_rounded,
                            size: 18,
                            color: const Color(0xFF1B8A5A),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            '${p.courierLabel} → ${p.orderLabel}',
                            style: TextStyle(
                              fontSize: 15.5,
                              fontWeight: FontWeight.bold,
                              color: cs.onSurface,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            '${p.minutes} min',
                            style: TextStyle(
                              fontSize: 15,
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const Divider(height: 24),
                  Text(
                    'Total: Z = $total minutos',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: cs.primary,
                    ),
                  ),
                ],
              ),
            ),
            ProjectCard(
              icon: Icons.table_chart_outlined,
              title: 'Matriz de costos con la solución',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Las celdas resaltadas son las parejas elegidas.',
                    style: TextStyle(fontSize: 14, color: cs.onSurfaceVariant),
                  ),
                  const SizedBox(height: 12),
                  CostMatrixTable(
                    values: DeliveryExercise.times,
                    showMinutes: true,
                    highlighted: _solution.cells,
                    maxWidth: 460,
                  ),
                ],
              ),
            ),
          ],
        ),
        const ProjectSectionTitle(
          'Paso a paso del Método Húngaro',
          kicker: 'CÓMO SE CALCULÓ',
        ),
        const ProjectParagraph(
          'Estos son los pasos que realiza el algoritmo sobre la matriz de tiempos hasta llegar a la asignación óptima.',
        ),
        const SizedBox(height: 16),
        _StepCard(
          number: 1,
          title: 'Matriz original',
          description:
              'Partimos de la matriz de tiempos en minutos (filas: repartidores, columnas: pedidos).',
          values: DeliveryExercise.times,
        ),
        const SizedBox(height: 16),
        const _StepCard(
          number: 2,
          title: 'Reducción por filas',
          description:
              'Se resta a cada fila su valor mínimo (5, 2, 3 y 2). Así aparece al menos un cero en cada fila.',
          values: DeliveryExercise.afterRowReduction,
        ),
        const SizedBox(height: 16),
        const _StepCard(
          number: 3,
          title: 'Reducción por columnas',
          description:
              'Se resta a cada columna su mínimo (0, 0, 0 y 2). Ahora hay al menos un cero en cada fila y en cada columna.',
          values: DeliveryExercise.afterColumnReduction,
        ),
        const SizedBox(height: 16),
        const _StepCard(
          number: 4,
          title: 'Cubrir los ceros con el mínimo de líneas',
          description:
              'Los ceros se pueden cubrir con 3 líneas (fila R1, columna P1 y columna P3), pero se necesitan 4 (n = 4). '
              'Todavía no hay asignación completa, así que se ajusta la matriz: el menor valor no cubierto es 1; '
              'se resta a las celdas no cubiertas y se suma a las celdas cubiertas por dos líneas.',
          values: DeliveryExercise.afterColumnReduction,
        ),
        const SizedBox(height: 16),
        _StepCard(
          number: 5,
          title: 'Asignación sobre los ceros',
          description:
              'Tras el ajuste, 4 líneas cubren todos los ceros y es posible elegir un cero por fila y por columna (celdas resaltadas): '
              '${_solution.pairs.map((p) => '${p.courierLabel}→${p.orderLabel}').join(', ')}. '
              'Sumando los tiempos originales de esas parejas se obtiene Z = $total minutos.',
          values: DeliveryExercise.afterAdjustment,
          highlighted: _solution.cells,
        ),
        const SizedBox(height: 28),
        const ProjectCallout(
          icon: Icons.fact_check_outlined,
          text:
              'Verificación: probando las 24 asignaciones posibles por fuerza bruta, el mínimo también es 15 minutos. '
              'El Método Húngaro llega al mismo resultado sin revisarlas todas.',
        ),
      ],
    );
  }
}

class _StepCard extends StatelessWidget {
  final int number;
  final String title;
  final String description;
  final List<List<int>> values;
  final Set<(int, int)> highlighted;

  const _StepCard({
    required this.number,
    required this.title,
    required this.description,
    required this.values,
    this.highlighted = const {},
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return ProjectCard(
      icon: Icons.format_list_numbered_rounded,
      title: 'Paso $number · $title',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final table = CostMatrixTable(
            values: values,
            highlighted: highlighted,
            maxWidth: 360,
          );
          final text = Text(
            description,
            style: TextStyle(
              fontSize: 15,
              height: 1.55,
              color: cs.onSurfaceVariant,
            ),
          );
          if (constraints.maxWidth < 700) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [text, const SizedBox(height: 14), table],
            );
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: text),
              const SizedBox(width: 24),
              SizedBox(width: 360, child: table),
            ],
          );
        },
      ),
    );
  }
}
