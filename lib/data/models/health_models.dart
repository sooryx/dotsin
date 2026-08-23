class CalloutData {
  const CalloutData({
    required this.text,
    required this.status,
    this.linkLabel,
  });

  final String text;
  final String status; // good | bad
  final String? linkLabel;

  factory CalloutData.fromJson(Map<String, dynamic> json) => CalloutData(
        text: json['text'] as String,
        status: json['status'] as String? ?? 'bad',
        linkLabel: json['linkLabel'] as String?,
      );
}

class ChartPoint {
  const ChartPoint(this.x, this.y, {this.dot = false});

  final double x;
  final double y;
  final bool dot;

  factory ChartPoint.fromJson(Map<String, dynamic> json) => ChartPoint(
        (json['x'] as num).toDouble(),
        (json['y'] as num).toDouble(),
        dot: json['dot'] as bool? ?? false,
      );
}

class MetricChip {
  const MetricChip({required this.value, required this.label});

  final String value;
  final String label;

  factory MetricChip.fromJson(Map<String, dynamic> json) => MetricChip(
        value: json['value'].toString(),
        label: json['label'] as String,
      );
}

class RiskMetric {
  const RiskMetric({
    required this.id,
    required this.name,
    required this.range,
    required this.value,
    required this.status,
  });

  final String id;
  final String name;
  final String range;
  final String value;
  final String status; // good | warn | bad

  factory RiskMetric.fromJson(Map<String, dynamic> json) => RiskMetric(
        id: json['id'] as String,
        name: json['name'] as String,
        range: json['range'] as String,
        value: json['value'].toString(),
        status: json['status'] as String? ?? 'warn',
      );
}

class OrganSummary {
  const OrganSummary({
    required this.id,
    required this.name,
    required this.iconAsset,
    required this.heroAsset,
    required this.overviewTitle,
    required this.gaugeTitle,
    required this.score,
    required this.gaugeTheme,
    required this.callouts,
    required this.recommendationTitle,
    required this.recommendationIntro,
    required this.recommendations,
    required this.riskSectionTitle,
    required this.strengths,
    required this.weaknesses,
    required this.riskMetrics,
  });

  final String id;
  final String name;
  final String iconAsset;
  final String heroAsset;
  final String overviewTitle;
  final String gaugeTitle;
  final double score;
  final String gaugeTheme; // green | amber | red
  final List<CalloutData> callouts;
  final String recommendationTitle;
  final String recommendationIntro;
  final List<String> recommendations;
  final String riskSectionTitle;
  final List<MetricChip> strengths;
  final List<MetricChip> weaknesses;
  final List<RiskMetric> riskMetrics;

  factory OrganSummary.fromJson(Map<String, dynamic> json) => OrganSummary(
        id: json['id'] as String,
        name: json['name'] as String,
        iconAsset: json['iconAsset'] as String,
        heroAsset: json['heroAsset'] as String,
        overviewTitle: json['overviewTitle'] as String,
        gaugeTitle: json['gaugeTitle'] as String,
        score: (json['score'] as num).toDouble(),
        gaugeTheme: json['gaugeTheme'] as String? ?? 'green',
        callouts: (json['callouts'] as List<dynamic>)
            .map((e) => CalloutData.fromJson(e as Map<String, dynamic>))
            .toList(),
        recommendationTitle: json['recommendationTitle'] as String,
        recommendationIntro: json['recommendationIntro'] as String? ?? '',
        recommendations: (json['recommendations'] as List<dynamic>).cast<String>(),
        riskSectionTitle: json['riskSectionTitle'] as String,
        strengths: (json['strengths'] as List<dynamic>? ?? const [])
            .map((e) => MetricChip.fromJson(e as Map<String, dynamic>))
            .toList(),
        weaknesses: (json['weaknesses'] as List<dynamic>? ?? const [])
            .map((e) => MetricChip.fromJson(e as Map<String, dynamic>))
            .toList(),
        riskMetrics: (json['riskMetrics'] as List<dynamic>? ?? const [])
            .map((e) => RiskMetric.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

class RangeBand {
  const RangeBand({required this.label, required this.range, required this.colorHex});

  final String label;
  final String range;
  final String colorHex;

  factory RangeBand.fromJson(Map<String, dynamic> json) => RangeBand(
        label: json['label'] as String,
        range: json['range'] as String,
        colorHex: json['colorHex'] as String,
      );
}

class ImpactParam {
  const ImpactParam({required this.title, required this.description});

  final String title;
  final String description;

  factory ImpactParam.fromJson(Map<String, dynamic> json) => ImpactParam(
        title: json['title'] as String,
        description: json['description'] as String,
      );
}

class MetricDetail {
  const MetricDetail({
    required this.id,
    required this.title,
    required this.value,
    required this.unit,
    required this.statusLabel,
    required this.badgeLabel,
    required this.needlePercent,
    required this.ranges,
    required this.impactsLabel,
    required this.impacts,
    required this.aboutTitle,
    required this.about,
  });

  final String id;
  final String title;
  final String value;
  final String unit;
  final String statusLabel;
  final String badgeLabel;
  final double needlePercent;
  final List<RangeBand> ranges;
  final String impactsLabel;
  final List<ImpactParam> impacts;
  final String aboutTitle;
  final String about;

  factory MetricDetail.fromJson(Map<String, dynamic> json) => MetricDetail(
        id: json['id'] as String,
        title: json['title'] as String,
        value: json['value'].toString(),
        unit: json['unit'] as String? ?? '',
        statusLabel: json['statusLabel'] as String,
        badgeLabel: json['badgeLabel'] as String,
        needlePercent: (json['needlePercent'] as num).toDouble(),
        ranges: (json['ranges'] as List<dynamic>)
            .map((e) => RangeBand.fromJson(e as Map<String, dynamic>))
            .toList(),
        impactsLabel: json['impactsLabel'] as String,
        impacts: (json['impacts'] as List<dynamic>)
            .map((e) => ImpactParam.fromJson(e as Map<String, dynamic>))
            .toList(),
        aboutTitle: json['aboutTitle'] as String,
        about: json['about'] as String,
      );
}

class PhenotypeData {
  const PhenotypeData({
    required this.overviewTitle,
    required this.callouts,
    required this.dopaminePoints,
    required this.serotoninPoints,
    required this.chartTitleDopamine,
    required this.chartTitleSerotonin,
    required this.chartAxisLabel,
    required this.scoreCardTitle,
    required this.scoreCardSubtitle,
    required this.scoreValue,
    required this.scoreBasis,
    required this.aboutTitle,
    required this.aboutBody,
    required this.immuneHeading,
    required this.immuneScore,
    required this.immuneRecommendationTitle,
    required this.immuneIntro,
    required this.immuneBullets,
    required this.strengths,
    required this.weaknesses,
    required this.bloodMetrics,
    required this.organs,
    required this.metrics,
  });

  final String overviewTitle;
  final List<CalloutData> callouts;
  final List<ChartPoint> dopaminePoints;
  final List<ChartPoint> serotoninPoints;
  final String chartTitleDopamine;
  final String chartTitleSerotonin;
  final String chartAxisLabel;
  final String scoreCardTitle;
  final String scoreCardSubtitle;
  final double scoreValue;
  final String scoreBasis;
  final String aboutTitle;
  final String aboutBody;
  final String immuneHeading;
  final double immuneScore;
  final String immuneRecommendationTitle;
  final String immuneIntro;
  final List<String> immuneBullets;
  final List<MetricChip> strengths;
  final List<MetricChip> weaknesses;
  final List<RiskMetric> bloodMetrics;
  final List<OrganSummary> organs;
  final List<MetricDetail> metrics;

  factory PhenotypeData.fromJson(Map<String, dynamic> json) => PhenotypeData(
        overviewTitle: json['overviewTitle'] as String,
        callouts: (json['callouts'] as List<dynamic>)
            .map((e) => CalloutData.fromJson(e as Map<String, dynamic>))
            .toList(),
        dopaminePoints: (json['dopaminePoints'] as List<dynamic>)
            .map((e) => ChartPoint.fromJson(e as Map<String, dynamic>))
            .toList(),
        serotoninPoints: (json['serotoninPoints'] as List<dynamic>)
            .map((e) => ChartPoint.fromJson(e as Map<String, dynamic>))
            .toList(),
        chartTitleDopamine: json['chartTitleDopamine'] as String,
        chartTitleSerotonin: json['chartTitleSerotonin'] as String,
        chartAxisLabel: json['chartAxisLabel'] as String,
        scoreCardTitle: json['scoreCardTitle'] as String,
        scoreCardSubtitle: json['scoreCardSubtitle'] as String,
        scoreValue: (json['scoreValue'] as num).toDouble(),
        scoreBasis: json['scoreBasis'] as String,
        aboutTitle: json['aboutTitle'] as String,
        aboutBody: json['aboutBody'] as String,
        immuneHeading: json['immuneHeading'] as String,
        immuneScore: (json['immuneScore'] as num).toDouble(),
        immuneRecommendationTitle: json['immuneRecommendationTitle'] as String,
        immuneIntro: json['immuneIntro'] as String,
        immuneBullets: (json['immuneBullets'] as List<dynamic>).cast<String>(),
        strengths: (json['strengths'] as List<dynamic>)
            .map((e) => MetricChip.fromJson(e as Map<String, dynamic>))
            .toList(),
        weaknesses: (json['weaknesses'] as List<dynamic>)
            .map((e) => MetricChip.fromJson(e as Map<String, dynamic>))
            .toList(),
        bloodMetrics: (json['bloodMetrics'] as List<dynamic>)
            .map((e) => RiskMetric.fromJson(e as Map<String, dynamic>))
            .toList(),
        organs: (json['organs'] as List<dynamic>)
            .map((e) => OrganSummary.fromJson(e as Map<String, dynamic>))
            .toList(),
        metrics: (json['metrics'] as List<dynamic>)
            .map((e) => MetricDetail.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  OrganSummary? organById(String id) {
    for (final organ in organs) {
      if (organ.id == id) return organ;
    }
    return null;
  }

  MetricDetail? metricById(String id) {
    for (final metric in metrics) {
      if (metric.id == id) return metric;
    }
    return null;
  }
}
