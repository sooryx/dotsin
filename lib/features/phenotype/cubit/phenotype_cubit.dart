import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/health_models.dart';
import '../../../data/repositories/health_repository.dart';

enum HubTab { genotype, phenotype }

enum HormoneTab { dopamine, serotonin }

enum HubFocus { blood, hormone }

class PhenotypeState extends Equatable {
  const PhenotypeState({
    this.loading = true,
    this.data,
    this.hubTab = HubTab.phenotype,
    this.hormoneTab = HormoneTab.dopamine,
    this.drawerOpen = false,
    this.selectedOrganId = 'heart',
    this.focus,
    this.error,
  });

  final bool loading;
  final PhenotypeData? data;
  final HubTab hubTab;
  final HormoneTab hormoneTab;
  final bool drawerOpen;
  final String selectedOrganId;
  final HubFocus? focus;
  final String? error;

  PhenotypeState copyWith({
    bool? loading,
    PhenotypeData? data,
    HubTab? hubTab,
    HormoneTab? hormoneTab,
    bool? drawerOpen,
    String? selectedOrganId,
    HubFocus? focus,
    String? error,
  }) {
    return PhenotypeState(
      loading: loading ?? this.loading,
      data: data ?? this.data,
      hubTab: hubTab ?? this.hubTab,
      hormoneTab: hormoneTab ?? this.hormoneTab,
      drawerOpen: drawerOpen ?? this.drawerOpen,
      selectedOrganId: selectedOrganId ?? this.selectedOrganId,
      focus: focus,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props =>
      [loading, data, hubTab, hormoneTab, drawerOpen, selectedOrganId, focus, error];
}

class PhenotypeCubit extends Cubit<PhenotypeState> {
  PhenotypeCubit(this._repository) : super(const PhenotypeState());

  final HealthRepository _repository;

  Future<void> load() async {
    emit(state.copyWith(loading: true));
    try {
      final data = await _repository.load();
      emit(state.copyWith(loading: false, data: data));
    } catch (error) {
      emit(state.copyWith(loading: false, error: error.toString()));
    }
  }

  void setHubTab(HubTab tab) => emit(state.copyWith(hubTab: tab, drawerOpen: false));

  void setHormoneTab(HormoneTab tab) => emit(state.copyWith(hormoneTab: tab));

  void toggleDrawer() => emit(state.copyWith(drawerOpen: !state.drawerOpen));

  void closeDrawer() => emit(state.copyWith(drawerOpen: false));

  void selectOrgan(String id) => emit(state.copyWith(selectedOrganId: id, drawerOpen: false));

  void focusBlood() => emit(state.copyWith(focus: HubFocus.blood, drawerOpen: false));

  void focusHormone() => emit(
        state.copyWith(
          focus: HubFocus.hormone,
          drawerOpen: false,
          hormoneTab: HormoneTab.dopamine,
        ),
      );

  void clearFocus() => emit(state.copyWith());
}
