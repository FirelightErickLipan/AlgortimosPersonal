import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../screens/application_screen.dart';
import '../screens/assignment_algo_screen.dart';
import '../screens/conclusions_screen.dart';
import '../screens/contact_screen.dart';
import '../screens/objective_screen.dart';
import '../screens/problem_screen.dart';
import '../screens/welcome_explanation_screen.dart';

enum ExplanationWebPage {
  introduccion,
  problema,
  objetivo,
  marcoTeorico,
  aplicacion,
  conclusiones,
  equipo,
}

class WebExplanationShell extends ConsumerWidget {
  final ExplanationWebPage activePage;
  final Widget? child;

  const WebExplanationShell({super.key, required this.activePage, this.child});

  void _navigateTo(BuildContext context, ExplanationWebPage page) {
    if (page == activePage) return;

    Widget targetScreen;
    switch (page) {
      case ExplanationWebPage.introduccion:
        targetScreen = const WelcomeExplanationScreen();
        break;
      case ExplanationWebPage.problema:
        targetScreen = const ProblemScreen();
        break;
      case ExplanationWebPage.objetivo:
        targetScreen = const ObjectiveScreen();
        break;
      case ExplanationWebPage.marcoTeorico:
        targetScreen = const AssignmentAlgoScreen();
        break;
      case ExplanationWebPage.aplicacion:
        targetScreen = const ApplicationScreen();
        break;
      case ExplanationWebPage.conclusiones:
        targetScreen = const ConclusionsScreen();
        break;
      case ExplanationWebPage.equipo:
        targetScreen = const ContactScreen();
        break;
    }

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => targetScreen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
        transitionDuration: const Duration(milliseconds: 250),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final width = MediaQuery.of(context).size.width;

    if (width >= 1024) {
      // Desktop Viewport Layout: Left Vertical Sidebar Navigation (>= 1024px)
      return Scaffold(
        backgroundColor: colorScheme.surface,
        body: SafeArea(
          top: true,
          bottom: true,
          left: true,
          right: true,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Left Desktop Vertical Menu Sidebar (270px)
              Container(
                width: 270,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHigh,
                  border: Border(
                    right: BorderSide(
                      color: colorScheme.outline.withValues(alpha: 0.25),
                      width: 1.5,
                    ),
                  ),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 20,
                          ),
                          child: _buildSidebarMenuContent(context, ref),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Right Scrollable Main Content Area
              Expanded(
                child: SizedBox(
                  height: double.infinity,
                  child: child ?? const SizedBox.shrink(),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Mobile & Tablet Viewport Layout (< 1024px) with Side Drawer
    final topPadding = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      drawer: Drawer(
        backgroundColor: colorScheme.surfaceContainerHigh,
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 20,
                    ),
                    child: _buildSidebarMenuContent(
                      context,
                      ref,
                      isDrawer: true,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60 + (topPadding > 0 ? topPadding : 0)),
        child: Container(
          padding: EdgeInsets.only(
            top: topPadding > 0 ? topPadding + 4 : 8,
            bottom: 8,
            left: 16,
            right: 16,
          ),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHigh,
            border: Border(
              bottom: BorderSide(
                color: colorScheme.outline.withValues(alpha: 0.25),
                width: 1.5,
              ),
            ),
          ),
          child: Row(
            children: [
              // Mobile Hamburger Drawer Trigger Button (on the LEFT side)
              Builder(
                builder: (scaffoldCtx) => IconButton(
                  icon: Icon(
                    Icons.menu_rounded,
                    color: colorScheme.primary,
                    size: 26,
                  ),
                  tooltip: 'Abrir Menú Principal',
                  onPressed: () => Scaffold.of(scaffoldCtx).openDrawer(),
                ),
              ),
              const SizedBox(width: 4),

              // Mobile Logo & Brand Title
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: colorScheme.outline.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(3),
                        child: Icon(
                          Icons.hub_rounded,
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Proyecto',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        left: true,
        right: true,
        bottom: true,
        child: child ?? const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildSidebarMenuContent(
    BuildContext context,
    WidgetRef ref, {
    bool isDrawer = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top Logo & Brand Title + Close Button (if drawer)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  if (isDrawer) Navigator.of(context).pop();
                  _navigateTo(context, ExplanationWebPage.introduccion);
                },
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 6,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: colorScheme.outline.withValues(alpha: 0.3),
                            width: 1.5,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Icon(
                          Icons.hub_rounded,
                          color: colorScheme.primary,
                        ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Proyecto',
                          style: const TextStyle(
                            fontSize: 15.5,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.3,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (isDrawer)
              IconButton(
                icon: Icon(
                  Icons.close_rounded,
                  color: colorScheme.onSurfaceVariant,
                ),
                tooltip: 'Cerrar Menú',
                onPressed: () => Navigator.of(context).pop(),
              ),
          ],
        ),
        const SizedBox(height: 18),

        const SizedBox(height: 4),
        const Divider(height: 1),
        const SizedBox(height: 16),

        // Sidebar Section Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            'TEMAS Y GUÍAS',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
              color: colorScheme.primary,
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Vertical Navigation Menu Items
        _buildVerticalNavLink(
          context,
          label: '1. Introducción',
          page: ExplanationWebPage.introduccion,
          icon: Icons.home_outlined,
          isDrawer: isDrawer,
        ),
        const SizedBox(height: 6),
        _buildVerticalNavLink(
          context,
          label: '2. Problema',
          page: ExplanationWebPage.problema,
          icon: Icons.help_outline_rounded,
          isDrawer: isDrawer,
        ),
        const SizedBox(height: 6),
        _buildVerticalNavLink(
          context,
          label: '3. Objetivo',
          page: ExplanationWebPage.objetivo,
          icon: Icons.flag_outlined,
          isDrawer: isDrawer,
        ),
        const SizedBox(height: 6),
        _buildVerticalNavLink(
          context,
          label: '4. Marco teórico',
          page: ExplanationWebPage.marcoTeorico,
          icon: Icons.menu_book_outlined,
          isDrawer: isDrawer,
        ),
        const SizedBox(height: 6),
        _buildVerticalNavLink(
          context,
          label: '5. Aplicación',
          page: ExplanationWebPage.aplicacion,
          icon: Icons.assignment_turned_in_outlined,
          isDrawer: isDrawer,
        ),
        const SizedBox(height: 6),
        _buildVerticalNavLink(
          context,
          label: '6. Conclusiones',
          page: ExplanationWebPage.conclusiones,
          icon: Icons.check_circle_outline_rounded,
          isDrawer: isDrawer,
        ),
        const SizedBox(height: 16),
        const Divider(height: 1, indent: 12, endIndent: 12),
        const SizedBox(height: 12),
        _buildVerticalNavLink(
          context,
          label: 'Equipo',
          page: ExplanationWebPage.equipo,
          icon: Icons.people_outline_rounded,
          isDrawer: isDrawer,
        ),
      ],
    );
  }

  Widget _buildVerticalNavLink(
    BuildContext context, {
    required String label,
    required ExplanationWebPage page,
    required IconData icon,
    bool isDrawer = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final isActive = page == activePage;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (isDrawer) Navigator.of(context).pop();
          _navigateTo(context, page);
        },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: isActive
                ? colorScheme.primaryContainer.withValues(alpha: 0.8)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: isActive
                ? Border.all(
                    color: colorScheme.primary.withValues(alpha: 0.4),
                    width: 1.5,
                  )
                : Border.all(color: Colors.transparent),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 18,
                color: isActive
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                    fontSize: 13.5,
                    color: isActive
                        ? colorScheme.onSurface
                        : colorScheme.onSurfaceVariant,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

typedef WebExplanationNavbar = WebExplanationShell;
