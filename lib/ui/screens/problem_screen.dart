import 'package:flutter/material.dart';

import '../widgets/video_resource_card.dart';
import '../widgets/web_explanation_navbar.dart';
import 'widgets/assignment/cost_matrix_table.dart';
import 'widgets/assignment/delivery_exercise_data.dart';
import 'widgets/project/project_page.dart';

/// Pestaña 2 — Definición del problema.
class ProblemScreen extends StatelessWidget {
  const ProblemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return ProjectPage(
      activePage: ExplanationWebPage.problema,
      badge: 'DEFINICIÓN DEL PROBLEMA',
      title: 'Cada pedido mal asignado cuesta tiempo, dinero y clientes',
      children: [
        const ProjectParagraph(
          'Imagina una empresa de delivery en hora pico. En el mismo instante entran 4 pedidos y hay 4 repartidores libres, '
          'cada uno en un punto distinto de la ciudad. El sistema tiene pocos segundos para decidir quién va a dónde. '
          'Si decide mal, un repartidor cruza media ciudad mientras otro, que estaba a dos cuadras, se queda esperando otro pedido.',
        ),
        const SizedBox(height: 20),
        const ProjectFigure(
          assetPath: 'assets/images/delivery_map.png',
          caption:
              'Figura 3. Escenario del problema: 4 repartidores (R1–R4) y 4 pedidos (P1–P4) en distintos puntos de la ciudad. '
              'Las flechas punteadas son una asignación cualquiera: ¿es la mejor?',
        ),
        const SizedBox(height: 24),
        const ProjectCallout(
          icon: Icons.warning_amber_rounded,
          color: Color(0xFFC62828),
          text:
              'El problema crítico: asignar "a ojo" parece razonable, pero no garantiza el mejor resultado. '
              'En nuestro ejercicio la asignación intuitiva tarda 20 minutos en total y la óptima solo 15: un 25 % de tiempo se desperdicia sin que nadie lo note.',
        ),
        const ProjectSectionTitle(
          '¿Qué pasa cuando se asigna mal?',
          kicker: 'CONSECUENCIAS',
        ),
        const ProjectResponsiveGrid(
          columns: 2,
          children: [
            ProjectCard(
              icon: Icons.hourglass_bottom_rounded,
              title: 'Clientes que esperan de más',
              child: ProjectParagraph(
                'La comida llega fría, el paquete tarda y el cliente cancela o califica mal la app. En delivery, el tiempo de espera es el producto que se vende.',
              ),
            ),
            ProjectCard(
              icon: Icons.local_gas_station_rounded,
              title: 'Costos operativos innecesarios',
              child: ProjectParagraph(
                'Más kilómetros recorridos significan más combustible, más desgaste de las motos y más horas de pago por el mismo número de entregas.',
              ),
            ),
            ProjectCard(
              icon: Icons.balance_rounded,
              title: 'Repartidores mal aprovechados',
              child: ProjectParagraph(
                'Un repartidor con un viaje largo no puede tomar el siguiente pedido a tiempo, mientras otros quedan ociosos. Se pierde capacidad de la flota.',
              ),
            ),
            ProjectCard(
              icon: Icons.trending_down_rounded,
              title: 'Pérdida de competitividad',
              child: ProjectParagraph(
                'Si otra empresa promete y cumple entregas más rápidas con los mismos recursos, los clientes migran. La eficiencia de la asignación es una ventaja competitiva.',
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const ProjectCard(
          icon: Icons.calculate_outlined,
          title: 'Una cuenta ilustrativa (hipotética)',
          child: ProjectParagraph(
            'En nuestro ejercicio la mala asignación desperdicia 5 minutos en cada lote de 4 pedidos. Si esa diferencia se repitiera en 100 lotes al día, '
            'serían 100 × 5 = 500 minutos, es decir, más de 8 horas de trabajo de repartidores perdidas cada día, solo por decidir peor. '
            'Es una extrapolación con fines ilustrativos: no son datos reales de una empresa, pero muestra cómo un error pequeño se multiplica.',
          ),
        ),
        const ProjectSectionTitle(
          '¿Por qué no basta con "elegir lo más cercano"?',
          kicker: 'EL RETO',
        ),
        const ProjectParagraph(
          'Una idea natural es una estrategia golosa (voraz): que cada repartidor, en orden, tome el pedido que le queda más cerca entre los que siguen libres. '
          'En el ejercicio, R1 elige P2 (5 min), R2 elige P1 (2 min), R3 elige P3 (3 min) y a R4 solo le queda P4, que le toma 10 minutos. Total: 20 minutos. '
          'Cada decisión era buena por separado, pero el resultado global no lo es: la última asignación quedó muy cara. '
          'El Método Húngaro, en cambio, mira la matriz completa y acepta que R2 vaya a P4 (5 min) para que R4 pueda ir a P1 (2 min); el total baja a 15 minutos.',
        ),
        const ProjectSectionTitle(
          'Definición formal del problema',
          kicker: 'MODELO',
        ),
        const ProjectResponsiveGrid(
          columns: 2,
          children: [
            ProjectCard(
              icon: Icons.input_rounded,
              title: 'Datos de entrada',
              child: ProjectList(
                items: [
                  'n repartidores (aquí n = 4) y n pedidos.',
                  'Una matriz de costos C donde cij es el tiempo, en minutos, que tarda el repartidor i en llegar al pedido j.',
                ],
              ),
            ),
            ProjectCard(
              icon: Icons.output_rounded,
              title: 'Salida esperada',
              child: ProjectList(
                items: [
                  'Una asignación 1 a 1: a cada repartidor se le asigna un pedido distinto.',
                  'El tiempo total mínimo Z = suma de los tiempos de las parejas elegidas.',
                ],
              ),
            ),
            ProjectCard(
              icon: Icons.rule_rounded,
              title: 'Restricciones',
              child: ProjectList(
                items: [
                  'Un repartidor atiende un solo pedido.',
                  'Un pedido lo atiende un solo repartidor.',
                  'El número de repartidores es igual al de pedidos (matriz cuadrada).',
                  'Todos los tiempos son conocidos y no negativos.',
                ],
              ),
            ),
            ProjectCard(
              icon: Icons.flag_circle_outlined,
              title: 'Pregunta a resolver',
              child: ProjectParagraph(
                '¿Qué repartidor debe atender cada pedido para que el tiempo total de entrega sea el menor posible, y cómo encontrarlo sin revisar todas las combinaciones?',
              ),
            ),
          ],
        ),
        const ProjectSectionTitle(
          'El problema como grafo',
          kicker: 'REPRESENTACIÓN',
        ),
        const ProjectParagraph(
          'Para que una computadora lo entienda, el problema se modela como un grafo bipartito: de un lado los repartidores (Origen), del otro los pedidos (Destino) '
          'y cada arista lleva como peso el tiempo en minutos. Resolver el problema equivale a elegir 4 aristas que no compartan nodos y cuya suma de pesos sea mínima.',
        ),
        const SizedBox(height: 18),
        const ProjectFigure(
          assetPath: 'assets/images/bipartite_model.png',
          caption:
              'Figura 4. Grafo bipartito del problema. Las aristas verdes son la asignación óptima que encuentra el algoritmo (se explica en el marco teórico).',
        ),
        const SizedBox(height: 24),
        ProjectCard(
          icon: Icons.table_chart_outlined,
          title: 'Matriz de costos (tiempo en minutos)',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Filas: repartidores (R1–R4). Columnas: pedidos (P1–P4). Cada celda es el tiempo que tardaría ese repartidor en llegar a ese pedido.',
                style: TextStyle(fontSize: 14, color: cs.onSurfaceVariant),
              ),
              const SizedBox(height: 12),
              const CostMatrixTable(
                values: DeliveryExercise.times,
                showMinutes: true,
                maxWidth: 560,
              ),
            ],
          ),
        ),
        const ProjectSectionTitle(
          'Para entender mejor el problema',
          kicker: 'VIDEO',
        ),
        const VideoResourceCard(
          title: 'Asignación por matriz de ceros',
          description:
              'Explicación en video de cómo se resuelve un problema de asignación como el de los repartidores.',
          videoUrl: 'https://www.youtube.com/watch?v=T4TrFA39AJU',
          durationOrAuthor: 'Explicación en video',
        ),
      ],
    );
  }
}
