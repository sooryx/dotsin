import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/health_models.dart';
import '../../../data/repositories/health_repository.dart';

class MetricDetailState extends Equatable {
  const MetricDetailState({
    this.loading = true,
    this.metric,
    this.expandedIndex,
    this.error,
  });

  final bool loading;
  final MetricDetail? metric;
  final int? expandedIndex;
  final String? error;

  MetricDetailState copyWith({
    bool? loading,
    MetricDetail? metric,
    int? expandedIndex,
    bool clearExpanded = false,
    String? error,
  }) {
    return MetricDetailState(
      loading: loading ?? this.loading,
      metric: metric ?? this.metric,
      expandedIndex: clearExpanded ? null : (expandedIndex ?? this.expandedIndex),
      error: error,
    );
  }

  @override
  List<Object?> get props => [loading, metric, expandedIndex, error];
}

class MetricDetailCubit extends Cubit<MetricDetailState> {
  MetricDetailCubit(this._repository) : super(const MetricDetailState());

  final HealthRepository _repository;

  Future<void> load(String metricId) async {
    emit(state.copyWith(loading: true, error: null));
    try {
      final data = await _repository.load();
      final metric = data.metricById(metricId) ?? data.metrics.first;
      emit(state.copyWith(loading: false, metric: metric));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  void toggleImpact(int index) {
    if (state.expandedIndex == index) {
      emit(state.copyWith(clearExpanded: true));
    } else {
      emit(state.copyWith(expandedIndex: index));
    }
  }
}
