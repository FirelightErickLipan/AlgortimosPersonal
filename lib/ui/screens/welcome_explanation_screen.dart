import 'package:flutter/material.dart';

import '../widgets/video_resource_card.dart';
import '../widgets/web_explanation_navbar.dart';
import 'application_screen.dart';
import 'widgets/project/project_page.dart';
import 'widgets/welcome/welcome_footer_section.dart';
import 'widgets/welcome/welcome_hero_section.dart';

/// Título del problema que resuelve el proyecto (se reutiliza en la web).
const String kProjectProblemTitle =
    'Entregas más rápidas: ¿qué repartidor lleva cada pedido?';

/// Pestaña 1 — Introducción del proyecto final.
class WelcomeExplanationScreen extends StatelessWidget {
  const WelcomeExplanationScreen({super.key});

  void _openApplication(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const ApplicationScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;

    return WebExplanationShell(
      activePage: ExplanationWebPage.introduccion,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            WelcomeHeroSection(
              badge: 'Análisis de Algoritmos · Examen final',
              title: kProjectProblemTitle,
              subtitle:
                  'Cómo un algoritmo de 1955 permite a una empresa de delivery asignar cada pedido al repartidor ideal y reducir el tiempo total de entrega.',
              primaryLabel: 'Ver la solución en acción',
              onOpenEditor: () => _openApplication(context),
            ),
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 48.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildIntroduction(context, colorScheme, screenWidth),
                      const SizedBox(height: 36),
                      _buildProblemSummary(),
                      const ProjectSectionTitle(
                        'La idea en una imagen',
                        kicker: 'ANTES Y DESPUÉS',
                      ),
                      const ProjectParagraph(
                        'Con exactamente los mismos repartidores y los mismos pedidos, la forma de asignarlos cambia el resultado. '
                        'Una asignación "a ojo" (cada repartidor toma el pedido que le parece más cercano, en orden) suma 20 minutos en total. '
                        'El Método Húngaro encuentra la combinación óptima: 15 minutos, es decir, 5 minutos menos (25 %) sin contratar a nadie más.',
                      ),
                      const SizedBox(height: 18),
                      const ProjectFigure(
                        assetPath: 'assets/images/before_after.png',
                        caption:
                            'Figura 1. Tiempo total de entrega con una asignación intuitiva frente a la asignación óptima del Método Húngaro.',
                      ),
                      const ProjectSectionTitle(
                        '¿Por qué hace falta un algoritmo?',
                        kicker: 'EL PUNTO DE PARTIDA',
                      ),
                      const ProjectParagraph(
                        'Con 4 repartidores y 4 pedidos existen 4! = 24 formas distintas de asignarlos; una persona podría revisarlas todas. '
                        'Pero el número crece de forma factorial: con 10 repartidores ya son 3 628 800 combinaciones y con 20 superan los 2,4 × 10¹⁸. '
                        'Ninguna computadora puede revisar todas esas combinaciones una por una en un tiempo razonable, y menos todavía en el minuto que tiene una app de delivery para responder al cliente.',
                      ),
                      const SizedBox(height: 18),
                      const ProjectFigure(
                        assetPath: 'assets/images/combinatorics.png',
                        caption:
                            'Figura 2. Crecimiento del número de asignaciones posibles (n!) a medida que aumentan repartidores y pedidos. Escala logarítmica.',
                      ),
                      const SizedBox(height: 18),
                      const ProjectCallout(
                        icon: Icons.lightbulb_outline_rounded,
                        text:
                            'El Método Húngaro evita probar todas las combinaciones: encuentra la mejor en un número de pasos del orden de n³. '
                            'Para n = 100 repartidores son del orden de un millón de operaciones, algo que una computadora resuelve en milisegundos.',
                      ),
                      const ProjectSectionTitle(
                        '¿Qué voy a hacer en este proyecto?',
                        kicker: 'ALCANCE',
                      ),
                      const ProjectParagraph(
                        'El proyecto consiste en tomar un algoritmo visto en clases y aplicarlo a un problema de la vida real. '
                        'Elegí el Algoritmo de Asignación (Método Húngaro) y lo apliqué al reparto de pedidos de delivery. El recorrido de esta página es el siguiente:',
                      ),
                      const SizedBox(height: 14),
                      const ProjectCard(
                        icon: Icons.route_rounded,
                        title: 'Recorrido de la página',
                        child: ProjectList(
                          numbered: true,
                          items: [
                            'Problema: describo la situación crítica de una empresa de delivery que asigna mal sus pedidos y qué consecuencias tiene.',
                            'Objetivo: defino qué quiero lograr y cómo voy a medirlo.',
                            'Marco teórico: explico el Método Húngaro, su historia, el grafo bipartito y los pasos del algoritmo.',
                            'Aplicación: muestro el grafo del ejercicio ya resuelto, con las rutas óptimas resaltadas, y el paso a paso del cálculo.',
                            'Conclusiones: analizo si el método se puede llevar a la vida real, sus límites y mejoras futuras.',
                          ],
                        ),
                      ),
                      const SizedBox(height: 56),
                      _buildSectionHeader(
                        context,
                        badge: 'MATERIAL AUDIOVISUAL',
                        title: 'Videos recomendados',
                        subtitle:
                            'Dos explicaciones para entender cómo se resuelve un problema de asignación antes de ver la aplicación.',
                      ),
                      const SizedBox(height: 28),
                      _buildVideosSection(screenWidth),
                    ],
                  ),
                ),
              ),
            ),
            WelcomeFooterSection(
              title: 'Proyecto — Delivery con el Método Húngaro',
              actionLabel: 'Ver la aplicación',
              copyright:
                  '© Proyecto final de Análisis de Algoritmos · Neil Erick Lipan Valdez.',
              onOpenEditor: () => _openApplication(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIntroduction(
    BuildContext context,
    ColorScheme colorScheme,
    double width,
  ) {
    final text = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'INTRODUCCIÓN',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.5,
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          kProjectProblemTitle,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: colorScheme.onSurface,
            letterSpacing: -0.5,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Cada vez que alguien pide comida o un paquete desde el celular, detrás ocurre una decisión que el cliente no ve: '
          '¿cuál de los repartidores disponibles debe llevar ese pedido? Cuando hay pocos pedidos, la decisión parece obvia. '
          'Cuando hay decenas de pedidos y decenas de repartidores repartidos por la ciudad, decidir "a ojo" hace que algunos clientes esperen de más, '
          'que los repartidores recorran distancias innecesarias y que la empresa gaste más combustible y pierda clientes.',
          style: TextStyle(
            fontSize: 16,
            height: 1.6,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Este proyecto resuelve ese problema con el Algoritmo de Asignación (Método Húngaro), visto en el curso, y lo convierte en una aplicación interactiva '
          'donde se puede ver el grafo de repartidores y pedidos con la solución óptima ya marcada.',
          style: TextStyle(
            fontSize: 16,
            height: 1.6,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );

    final image = ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Image.asset(
        'assets/images/delivery_map.png',
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => Container(
          height: 200,
          color: colorScheme.primaryContainer.withValues(alpha: 0.4),
          child: Center(
            child: Icon(
              Icons.delivery_dining_rounded,
              size: 64,
              color: colorScheme.primary,
            ),
          ),
        ),
      ),
    );

    if (width < 900) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [text, const SizedBox(height: 28), image],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(flex: 5, child: text),
        const SizedBox(width: 40),
        Expanded(flex: 4, child: image),
      ],
    );
  }

  Widget _buildProblemSummary() {
    return ProjectCard(
      icon: Icons.summarize_rounded,
      title: 'Resumen del problema',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          ProjectParagraph(
            'Una empresa de delivery recibe 4 pedidos al mismo tiempo y tiene 4 repartidores libres en distintos puntos de la ciudad. '
            'Se sabe cuántos minutos tardaría cada repartidor en llegar a cada pedido. Cada repartidor solo puede llevar un pedido y cada pedido '
            'necesita un solo repartidor. La pregunta es: ¿qué repartidor debe ir a cada pedido para que el tiempo total sea el mínimo posible?',
          ),
          SizedBox(height: 18),
          ProjectResponsiveGrid(
            columns: 3,
            children: [
              ProjectStat(
                value: '24',
                label: 'formas de asignar 4 pedidos a 4 repartidores',
                icon: Icons.shuffle_rounded,
              ),
              ProjectStat(
                value: '3 628 800',
                label: 'formas de asignar 10 pedidos a 10 repartidores',
                icon: Icons.trending_up_rounded,
                color: Color(0xFFE8710A),
              ),
              ProjectStat(
                value: '15 min',
                label: 'tiempo total óptimo frente a 20 min de la asignación intuitiva',
                icon: Icons.timer_outlined,
                color: Color(0xFF1B8A5A),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVideosSection(double width) {
    const videos = [
      VideoResourceCard(
        title: 'Asignación por matriz de ceros',
        description:
            'Cómo restar mínimos por filas y columnas para resolver problemas de asignación 1 a 1.',
        videoUrl: 'https://www.youtube.com/watch?v=T4TrFA39AJU',
        durationOrAuthor: 'Explicación en video',
      ),
      VideoResourceCard(
        title: 'Métodos de asignación',
        description:
            'Estrategias para encontrar una combinación óptima y comparar sus resultados.',
        videoUrl: 'https://www.youtube.com/watch?v=_XvIC2KvWvo',
        durationOrAuthor: 'Métodos de solución',
      ),
    ];

    if (width < 760) {
      return Column(
        children: [videos[0], const SizedBox(height: 20), videos[1]],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: videos[0]),
        const SizedBox(width: 24),
        Expanded(child: videos[1]),
      ],
    );
  }

  Widget _buildSectionHeader(
    BuildContext context, {
    required String badge,
    required String title,
    required String subtitle,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          badge,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.5,
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: colorScheme.onSurface,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: TextStyle(fontSize: 16, color: colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }
}
