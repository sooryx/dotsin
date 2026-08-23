import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/health_models.dart';
import '../../../data/repositories/health_repository.dart';

class OrganState extends Equatable {
  const OrganState({
    this.loading = true,
    this.organ,
    this.error,
  });

  final bool loading;
  final OrganSummary? organ;
  final String? error;

  OrganState copyWith({bool? loading, OrganSummary? organ, String? error}) {
    return OrganState(
      loading: loading ?? this.loading,
      organ: organ ?? this.organ,
      error: error,
    );
  }

  @override
  List<Object?> get props => [loading, organ, error];
}

class OrganCubit extends Cubit<OrganState> {
  OrganCubit(this._repository) : super(const OrganState());

  final HealthRepository _repository;

  Future<void> load(String organId) async {
    emit(state.copyWith(loading: true, error: null));
    try {
      final data = await _repository.load();
      final organ = data.organById(organId);
      if (organ == null) {
        emit(state.copyWith(loading: false, error: 'Organ not found'));
        return;
      }
      emit(state.copyWith(loading: false, organ: organ));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }
}
