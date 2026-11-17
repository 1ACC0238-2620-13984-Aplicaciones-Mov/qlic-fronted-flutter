class DeviceDto {
  const DeviceDto({
    required this.id,
    required this.serialNumber,
    required this.model,
    required this.accountId,
    required this.waterPointId,
    required this.status,
    required this.batteryPercentage,
    required this.lastSyncAt,
  });

  final String id;
  final String serialNumber;
  final String model;
  final String accountId;
  final String? waterPointId;
  final String status;
  final int batteryPercentage;
  final String lastSyncAt;

  factory DeviceDto.fromJson(Map<String, dynamic> json) => DeviceDto(
    id: json['id'] as String,
    serialNumber: json['serialNumber'] as String,
    model: json['model'] as String,
    accountId: json['accountId'] as String,
    waterPointId: json['waterPointId'] as String?,
    status: json['status'] as String,
    batteryPercentage: (json['batteryPercentage'] as num).toInt(),
    lastSyncAt: json['lastSyncAt'] as String,
  );
}