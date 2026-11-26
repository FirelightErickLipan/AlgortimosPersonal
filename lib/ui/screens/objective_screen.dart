import 'package:flutter/material.dart';

import '../widgets/web_explanation_navbar.dart';
import 'widgets/project/project_page.dart';

/// Pestaña 3 — Objetivo general y objetivos específicos.
class ObjectiveScreen extends StatelessWidget {
  const ObjectiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProjectPage(
      activePage: ExplanationWebPage.objetivo,
      badge: 'OBJETIVO GENERAL',
      title: 'Qué quiero lograr y cómo voy a comprobarlo',
      children: [
        ProjectParagraph(
          'En la sección anterior vimos que asignar pedidos de delivery sin un método puede desperdiciar hasta una cuarta parte del tiempo de entrega. '
          'Este proyecto busca resolver ese problema con un algoritmo visto en el curso y demostrar, con una herramienta que se puede usar, que la mejora es real.',
        ),
        SizedBox(height: 24),
        ProjectCard(
          icon: Icons.flag_outlined,
          title: 'Objetivo general',
          child: ProjectParagraph(
            'Resolver el problema de asignación de repartidores a pedidos de delivery mediante el Algoritmo Húngaro, '
            'para minimizar el tiempo total de entrega, y demostrar su aplicación en la vida real a través de una herramienta web interactiva.',
          ),
        ),
        SizedBox(height: 20),
        ProjectFigure(
          assetPath: 'assets/images/bipartite_model.png',
          caption:
              'Figura 5. Meta del proyecto: pasar de la matriz de tiempos al grafo con las aristas óptimas marcadas.',
          maxWidth: 700,
        ),
        ProjectSectionTitle(
          'Objetivos específicos',
          kicker: 'PASO A PASO',
        ),
        ProjectCard(
          icon: Icons.checklist_rounded,
          title: 'Lo que voy a hacer para cumplir el objetivo',
          child: ProjectList(
            numbered: true,
            items: [
              'Modelar el problema como un grafo bipartito (repartidores ↔ pedidos) con una matriz de costos en minutos, para que pueda ser procesado por un algoritmo.',
              'Explicar y aplicar el Método Húngaro (reducción por filas y columnas, cobertura de ceros y ajuste) mostrando cada paso del cálculo.',
              'Construir una aplicación web que muestre el grafo ya resuelto, con las aristas óptimas resaltadas, y permita mover los nodos para explorarlo.',
              'Comparar el resultado óptimo (15 min) con la asignación intuitiva (20 min) y cuantificar la mejora (25 %).',
              'Analizar si la solución se puede llevar a la vida real, qué limitaciones tiene y cómo mejorarla.',
            ],
          ),
        ),
        ProjectSectionTitle(
          'Criterios de éxito',
          kicker: 'CÓMO SE MIDE',
        ),
        ProjectResponsiveGrid(
          columns: 3,
          children: [
            ProjectStat(
              value: 'Z mínimo',
              label:
                  'La suma de tiempos de la asignación debe ser la menor posible: Z = 15 min en el ejercicio.',
              icon: Icons.timer_outlined,
              color: Color(0xFF1B8A5A),
            ),
            ProjectStat(
              value: '1 a 1',
              label:
                  'Cada repartidor atiende exactamente un pedido y cada pedido es atendido por un solo repartidor.',
              icon: Icons.link_rounded,
            ),
            ProjectStat(
              value: '25 %',
              label:
                  'Mejora frente a la asignación intuitiva (20 min → 15 min) con los mismos recursos.',
              icon: Icons.trending_down_rounded,
              color: Color(0xFFE8710A),
            ),
          ],
        ),
        SizedBox(height: 28),
        ProjectCallout(
          icon: Icons.school_outlined,
          text:
              'El propósito académico es aplicar los conocimientos aprendidos en el curso de Análisis de Algoritmos: elegir un algoritmo, entender su teoría, '
              'implementarlo y llevarlo a un problema real, no solo resolver un ejercicio en papel.',
        ),
      ],
    );
  }
}
