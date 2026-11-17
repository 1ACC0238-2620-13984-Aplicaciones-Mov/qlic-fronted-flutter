class AlertDto {
  const AlertDto({
    required this.id,
    required this.accountId,
    required this.waterPointId,
    required this.state,
    required this.urgency,
    required this.detectedAt,
    required this.estimatedVolumeLiters,
    required this.estimatedCostSoles,
    required this.recommendedAction,
  });

  final String id;
  final String accountId;
  final String? waterPointId;
  final String state; 
  final String urgency;
  final String detectedAt;
  final double estimatedVolumeLiters;
  final double estimatedCostSoles;
  final String recommendedAction;

  factory AlertDto.fromJson(Map<String, dynamic> json) => AlertDto(
    id: json['id'] as String,
    accountId: json['accountId'] as String,
    waterPointId: json['waterPointId'] as String?,
    state: json['state'] as String,
    urgency: json['urgency'] as String,
    detectedAt: json['detectedAt'] as String,
    estimatedVolumeLiters: (json['estimatedVolumeLiters'] as num).toDouble(),
    estimatedCostSoles: (json['estimatedCostSoles'] as num).toDouble(),
    recommendedAction: (json['recommendedAction'] as String?) ?? '',
  );
}