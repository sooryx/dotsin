import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../core/app_text.dart';
import '../data/repositories/health_repository.dart';
import '../features/blood/blood_metrics_screen.dart';
import '../features/details/metric_detail_screen.dart';
import '../features/organ/organ_detail_screen.dart';
import '../features/phenotype/cubit/phenotype_cubit.dart';
import '../features/phenotype/phenotype_hub_screen.dart';

/// iOS-style push (slide from right + parallax on the previous route).
CupertinoPage<void> _cupertinoPage({
  required GoRouterState state,
  required Widget child,
}) {
  return CupertinoPage<void>(
    key: state.pageKey,
    name: state.name ?? state.path,
    child: child,
  );
}

GoRouter createRouter({String initialLocation = '/'}) {
  return GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: '/',
        pageBuilder: (context, state) => _cupertinoPage(
          state: state,
          child: const PhenotypeHubScreen(),
        ),
      ),
      GoRoute(
        path: '/organ/:id',
        pageBuilder: (context, state) => _cupertinoPage(
          state: state,
          child: OrganDetailScreen(organId: state.pathParameters['id']!),
        ),
      ),
      GoRoute(
        path: '/details/:id',
        pageBuilder: (context, state) => _cupertinoPage(
          state: state,
          child: MetricDetailScreen(metricId: state.pathParameters['id']!),
        ),
      ),
      GoRoute(
        path: '/blood',
        pageBuilder: (context, state) => _cupertinoPage(
          state: state,
          child: const BloodMetricsScreen(),
        ),
      ),
    ],
  );
}

class HealthDataHubApp extends StatefulWidget {
  const HealthDataHubApp({super.key, this.initialLocation = '/'});

  final String initialLocation;

  @override
  State<HealthDataHubApp> createState() => _HealthDataHubAppState();
}

class _HealthDataHubAppState extends State<HealthDataHubApp> {
  late final _repository = HealthRepository();
  late final _router = createRouter(initialLocation: widget.initialLocation);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _repository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => PhenotypeCubit(_repository)..load()),
        ],
        child: MaterialApp.router(
          title: 'Health Data Hub',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.dark(),
          routerConfig: _router,
        ),
      ),
    );
  }
}
