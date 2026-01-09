import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smith_chart/state/circuit_state.dart';
import 'package:smith_chart/state/auth_state.dart';
import 'package:smith_chart/components_panel.dart';
import 'package:smith_chart/smith_chart_widget.dart';
import 'package:smith_chart/results_panel.dart';
import 'package:smith_chart/ui/schematic_widget.dart';
import 'package:smith_chart/ai/ai_assistant_panel.dart';
import 'package:smith_chart/ui/landing_page.dart';
import 'package:smith_chart/ui/examples_page.dart';
import 'package:smith_chart/ui/login_page.dart';
import 'package:smith_chart/ui/assessment_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthState())],
      child: const MyApp(),
    ),
  );
}

enum AppView { landing, engineering, examples }

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final CircuitState circuitState = CircuitState();

  @override
  void initState() {
    super.initState();
    circuitState.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SMITH CHART.IO | RF Engineering Lab',
      theme: ThemeData.light(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: const Color(0xFFF5F5FA),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF0055FF),
          secondary: Color(0xFFD50055),
          surface: Color(0xFFFFFFFF),
        ),
      ),
      darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F0F1A),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00D2FF),
          secondary: Color(0xFFFF007F),
          surface: Color(0xFF1E1E2F),
        ),
      ),
      themeMode: circuitState.themeMode,
      home: Consumer<AuthState>(
        builder: (context, auth, _) {
          if (auth.role == UserRole.none) {
            return const LoginPage();
          }
          if (auth.role == UserRole.student && !auth.isAssessmentComplete) {
            return const AssessmentPage();
          }
          return SmithChartApp(
            circuitState: circuitState,
            initialView: auth.hasFailedAssessment
                ? AppView.examples
                : AppView.landing,
          );
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SmithChartApp extends StatefulWidget {
  final CircuitState circuitState;
  final AppView initialView;

  const SmithChartApp({
    required this.circuitState,
    this.initialView = AppView.landing,
    super.key,
  });

  @override
  State<SmithChartApp> createState() => _SmithChartAppState();
}

class _SmithChartAppState extends State<SmithChartApp> {
  late AppView _currentView;

  @override
  void initState() {
    super.initState();
    _currentView = widget.initialView;
  }

  @override
  Widget build(BuildContext context) {
    switch (_currentView) {
      case AppView.landing:
        return LandingPage(
          onStartEngineering: () =>
              setState(() => _currentView = AppView.engineering),
          onStartTutorials: () =>
              setState(() => _currentView = AppView.examples),
        );
      case AppView.examples:
        return ExamplesPage(
          state: widget.circuitState,
          onBack: () => setState(() => _currentView = AppView.landing),
          onApply: () => setState(() => _currentView = AppView.engineering),
        );
      case AppView.engineering:
        return SmithChartHomeScreen(
          circuitState: widget.circuitState,
          onExit: () => setState(() => _currentView = AppView.landing),
        );
    }
  }
}

class SmithChartHomeScreen extends StatefulWidget {
  final CircuitState circuitState;
  final VoidCallback onExit;
  const SmithChartHomeScreen({
    required this.circuitState,
    required this.onExit,
    super.key,
  });

  @override
  State<SmithChartHomeScreen> createState() => _SmithChartHomeScreenState();
}

class _SmithChartHomeScreenState extends State<SmithChartHomeScreen> {
  bool _showAiPanel = false;

  @override
  Widget build(BuildContext context) {
    final circuitState = widget.circuitState;
    return ListenableBuilder(
      listenable: circuitState,
      builder: (context, child) {
        bool isMobile = MediaQuery.of(context).size.width <= 900;

        return DefaultTabController(
          length: isMobile ? 3 : 1,
          child: Scaffold(
            body: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  bool showTabs = constraints.maxWidth <= 900;
                  final isDark =
                      Theme.of(context).brightness == Brightness.dark;
                  return Stack(
                    children: [
                      // MAIN CONTENT
                      Container(
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            center: Alignment.center,
                            radius: 1.5,
                            colors: isDark
                                ? [
                                    const Color(0xFF1A1A2E),
                                    const Color(0xFF0F0F1A),
                                  ]
                                : [
                                    const Color(0xFFFFFFFF),
                                    const Color(0xFFE0E0E5),
                                  ],
                          ),
                        ),
                        child: Column(
                          children: [
                            // AppBar
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              color: Colors.black.withValues(
                                alpha: 0.8,
                              ), // Darker for contrast
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.radar,
                                    color: Color(0xFF00F0FF),
                                  ),
                                  const SizedBox(width: 10),
                                  const Text(
                                    'SMITH CHART.IO',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 2,
                                      color: Colors.white,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.home,
                                      color: Colors.white,
                                    ),
                                    onPressed: widget.onExit,
                                    tooltip: 'Exit to Home',
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.undo,
                                      color: Colors.grey,
                                    ),
                                    onPressed: circuitState.elements.length > 1
                                        ? () => circuitState.removeLast()
                                        : null,
                                  ),
                                  // Theme Toggle
                                  IconButton(
                                    icon: Icon(
                                      circuitState.themeMode == ThemeMode.light
                                          ? Icons.dark_mode
                                          : Icons.light_mode,
                                      color: Colors.white,
                                    ),
                                    onPressed: circuitState.toggleTheme,
                                  ),
                                  // AI Toggle
                                  IconButton(
                                    icon: Icon(
                                      Icons.psychology,
                                      color: _showAiPanel
                                          ? const Color(0xFF6200EE)
                                          : Colors.white,
                                    ),
                                    onPressed: () {
                                      setState(
                                        () => _showAiPanel = !_showAiPanel,
                                      );
                                    },
                                  ),
                                  // Logout
                                  IconButton(
                                    icon: const Icon(
                                      Icons.logout,
                                      color: Colors.redAccent,
                                    ),
                                    onPressed: () => Provider.of<AuthState>(
                                      context,
                                      listen: false,
                                    ).logout(),
                                    tooltip: 'Logout',
                                  ),
                                ],
                              ),
                            ),
                            // Team Badge
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    const Color(
                                      0xFF00D2FF,
                                    ).withValues(alpha: 0.0),
                                    const Color(
                                      0xFF00D2FF,
                                    ).withValues(alpha: 0.2),
                                    const Color(
                                      0xFF00D2FF,
                                    ).withValues(alpha: 0.0),
                                  ],
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  "PUBLISHED BY AKATSUKI | RF EXCELLENCE",
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2.5,
                                    color: Color(0xFF00D2FF),
                                  ),
                                ),
                              ),
                            ),
                            if (showTabs)
                              Container(
                                color: Colors.black.withOpacity(0.8),
                                child: const TabBar(
                                  tabs: [
                                    Tab(
                                      icon: Icon(Icons.show_chart),
                                      text: "Chart",
                                    ),
                                    Tab(
                                      icon: Icon(
                                        Icons.settings_input_component,
                                      ),
                                      text: "Parts",
                                    ),
                                    Tab(
                                      icon: Icon(Icons.bar_chart),
                                      text: "Results",
                                    ),
                                  ],
                                  indicatorColor: Color(0xFF00F0FF),
                                  labelColor: Color(0xFF00F0FF),
                                  unselectedLabelColor: Colors.white60,
                                ),
                              ),
                            Expanded(
                              child: constraints.maxWidth > 900
                                  ? Row(
                                      children: [
                                        SizedBox(
                                          width: 280,
                                          child: Padding(
                                            padding: const EdgeInsets.all(12),
                                            child: ComponentsPanel(
                                              state: circuitState,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(24.0),
                                            child: Column(
                                              children: [
                                                Expanded(
                                                  child: InteractiveViewer(
                                                    minScale: 0.5,
                                                    maxScale: 5.0,
                                                    child: SmithChartWidget(
                                                      trajectory: circuitState
                                                          .trajectory,
                                                      elements:
                                                          circuitState.elements,
                                                      isAdmittanceView:
                                                          circuitState
                                                              .isAdmittanceView,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                // Schematic View
                                                SizedBox(
                                                  height: 140,
                                                  child: SchematicWidget(
                                                    elements:
                                                        circuitState.elements,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 300,
                                          child: Padding(
                                            padding: const EdgeInsets.all(12),
                                            child: ResultsPanel(
                                              state: circuitState,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : TabBarView(
                                      children: [
                                        // TAB 1: CHART
                                        Padding(
                                          padding: const EdgeInsets.all(12),
                                          child: Column(
                                            children: [
                                              Expanded(
                                                child: InteractiveViewer(
                                                  minScale: 1.0,
                                                  maxScale: 4.0,
                                                  boundaryMargin:
                                                      const EdgeInsets.all(20),
                                                  child: SmithChartWidget(
                                                    trajectory:
                                                        circuitState.trajectory,
                                                    elements:
                                                        circuitState.elements,
                                                    isAdmittanceView:
                                                        circuitState
                                                            .isAdmittanceView,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              SizedBox(
                                                height: 100,
                                                child: SchematicWidget(
                                                  elements:
                                                      circuitState.elements,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // TAB 2: COMPONENTS
                                        Padding(
                                          padding: const EdgeInsets.all(12),
                                          child: ComponentsPanel(
                                            state: circuitState,
                                          ),
                                        ),
                                        // TAB 3: RESULTS
                                        Padding(
                                          padding: const EdgeInsets.all(12),
                                          child: ResultsPanel(
                                            state: circuitState,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ],
                        ),
                      ),

                      // AI OVERLAY
                      if (_showAiPanel)
                        Positioned(
                          right: constraints.maxWidth > 600 ? 20 : 10,
                          top: 80,
                          bottom: 20,
                          width: constraints.maxWidth > 600
                              ? 350
                              : constraints.maxWidth - 20,
                          child: Material(
                            elevation: 8,
                            borderRadius: BorderRadius.circular(16),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: AiAssistantPanel(
                                state: circuitState,
                                onClose: () =>
                                    setState(() => _showAiPanel = false),
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
