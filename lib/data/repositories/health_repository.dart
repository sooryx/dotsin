import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/health_models.dart';

class HealthRepository {
  PhenotypeData? _cache;

  Future<PhenotypeData> load() async {
    if (_cache != null) return _cache!;
    final raw = await rootBundle.loadString('assets/data/phenotype.json');
    _cache = PhenotypeData.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    return _cache!;
  }
}
