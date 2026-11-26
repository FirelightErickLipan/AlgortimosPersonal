import 'package:flutter/material.dart';

import '../../../widgets/math_rich_text.dart';
import 'cost_matrix_table.dart';
import 'delivery_exercise_data.dart';

/// Marco teórico ampliado: modelo, historia, teorema de König, casos
/// especiales, complejidad y el ejercicio resuelto paso a paso.
class HungarianTheorySection extends StatelessWidget {
  const HungarianTheorySection({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'FUNDAMENTO MATEMÁTICO',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.5,
            color: cs.primary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Modelo, historia y complejidad',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: cs.onSurface,
          ),
        ),
        const SizedBox(height: 24),
        LayoutBuilder(
          builder: (context, constraints) {
            final twoColumns = constraints.maxWidth >= 800;
            final cardWidth = twoColumns
                ? (constraints.maxWidth - 16) / 2
                : constraints.maxWidth;
            return Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                SizedBox(
                  width: cardWidth,
                  child: const _TheoryCard(
                    icon: Icons.functions_rounded,
                    title: 'Problema de asignación',
                    body:
                        'Es un caso particular del problema de transporte donde cada oferta y cada demanda valen 1. Se modela como un grafo bipartito ponderado y como un programa lineal:',
                    formula:
                        r'$\min Z=\sum_i\sum_j c_{ij}x_{ij}$'
                        '\n'
                        r'$\sum_j x_{ij}=1,\quad \sum_i x_{ij}=1,\quad x_{ij}\in\{0,1\}$',
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  child: const _TheoryCard(
                    icon: Icons.history_edu_rounded,
                    title: 'Historia: ¿por qué "Húngaro"?',
                    body:
                        'Harold Kuhn lo publicó en 1955 basándose en los trabajos de los matemáticos húngaros König y Egerváry; de ahí su nombre. James Munkres lo analizó en 1957, por eso también se le conoce como algoritmo de Kuhn–Munkres.',
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  child: const _TheoryCard(
                    icon: Icons.rule_rounded,
                    title: 'Teorema de König',
                    body:
                        'En un grafo bipartito, el número máximo de ceros independientes es igual al mínimo número de líneas que cubren todos los ceros. Si ese número es igual a n, existe una asignación óptima sobre los ceros.',
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  child: const _TheoryCard(
                    icon: Icons.tune_rounded,
                    title: 'Casos especiales',
                    body:
                        'Matriz no cuadrada: se agregan filas o columnas ficticias con costo 0.\nMaximización: se convierte con c′ = máx(C) − c.\nAsignación prohibida: se usa un costo muy grande (∞).',
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 24),
        const _ComplexityCard(),
        const SizedBox(height: 48),
        const _ExerciseWalkthrough(),
      ],
    );
  }
}

class _TheoryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;
  final String? formula;

  const _TheoryCard({
    required this.icon,
    required this.title,
    required this.body,
    this.formula,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: cs.primary, size: 26),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: cs.onSurface,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            body,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: cs.onSurfaceVariant,
            ),
          ),
          if (formula != null) ...[
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: MathRichText(text: formula!),
            ),
          ],
        ],
      ),
    );
  }
}

class _ComplexityCard extends StatelessWidget {
  const _ComplexityCard();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cs.primaryContainer.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cs.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.speed_rounded, color: cs.primary, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Complejidad: O(n³) frente a O(n!)',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: cs.onSurface,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'La fuerza bruta prueba todas las permutaciones: con 10 recursos ya hay 3 628 800 combinaciones. '
            'Con n = 20 serían ≈ 2,4 × 10¹⁸ combinaciones, mientras que el Método Húngaro necesita del orden de 8 000 operaciones (20³).',
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: cs.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExerciseWalkthrough extends StatelessWidget {
  const _ExerciseWalkthrough();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'EJERCICIO RESUELTO',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.5,
            color: cs.primary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          '4 repartidores × 4 pedidos, paso a paso',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: cs.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Matriz de tiempos en minutos (filas = repartidores, columnas = pedidos).',
          style: TextStyle(fontSize: 14, color: cs.onSurfaceVariant),
        ),
        const SizedBox(height: 16),
        const CostMatrixTable(values: DeliveryExercise.times),
        const SizedBox(height: 24),
        const _ExerciseStep(
          number: 1,
          title: 'Reducción por filas',
          description:
              'Se resta el mínimo de cada fila (5, 2, 3 y 2). Cada fila queda con al menos un cero.',
          matrix: DeliveryExercise.afterRowReduction,
        ),
        const _ExerciseStep(
          number: 2,
          title: 'Reducción por columnas',
          description:
              'Se resta el mínimo de cada columna (0, 0, 0 y 2). Ahora cada columna también tiene un cero.',
          matrix: DeliveryExercise.afterColumnReduction,
        ),
        const _ExerciseStep(
          number: 3,
          title: 'Cubrir los ceros con el mínimo de líneas',
          description:
              'Bastan 3 líneas (Fila 1, Columna 1 y Columna 3). Como 3 < 4, todavía no es óptimo.',
        ),
        const _ExerciseStep(
          number: 4,
          title: 'Ajustar la matriz',
          description:
              'El menor valor no cubierto es 1. Se resta 1 a las celdas no cubiertas y se suma 1 a las que están en el cruce de dos líneas.',
          matrix: DeliveryExercise.afterAdjustment,
        ),
        const _ExerciseStep(
          number: 5,
          title: 'Volver a cubrir los ceros',
          description:
              'Ahora se necesitan 4 líneas = n, por lo tanto existe una asignación óptima sobre los ceros.',
        ),
        _ExerciseStep(
          number: 6,
          title: 'Asignar sobre los ceros',
          description:
              'R1→P2 (5 min), R2→P4 (5 min), R3→P3 (3 min) y R4→P1 (2 min): total Z = ${DeliveryExercise.optimalTotal} min.',
          matrix: DeliveryExercise.times,
          highlighted: DeliveryExercise.optimalCells,
          showMinutes: true,
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: cs.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.4)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.compare_arrows_rounded, color: cs.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Comparación: una asignación intuitiva (R1→P2, R2→P1, R3→P3, R4→P4) da '
                  '${DeliveryExercise.intuitiveTotal} min. El Método Húngaro da '
                  '${DeliveryExercise.optimalTotal} min: ahorra '
                  '${DeliveryExercise.intuitiveTotal - DeliveryExercise.optimalTotal} min (25 %).',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: cs.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ExerciseStep extends StatelessWidget {
  final int number;
  final String title;
  final String description;
  final List<List<int>>? matrix;
  final Set<(int, int)> highlighted;
  final bool showMinutes;

  const _ExerciseStep({
    required this.number,
    required this.title,
    required this.description,
    this.matrix,
    this.highlighted = const {},
    this.showMinutes = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 15,
            backgroundColor: cs.primary,
            child: Text(
              '$number',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: cs.onPrimary,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: cs.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: cs.onSurfaceVariant,
                  ),
                ),
                if (matrix != null) ...[
                  const SizedBox(height: 12),
                  CostMatrixTable(
                    values: matrix!,
                    highlighted: highlighted,
                    showMinutes: showMinutes,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
