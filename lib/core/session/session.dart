class Session {
  const Session({
    required this.token,
    required this.tokenType,
    required this.expiresAt,
    required this.accountId,
    required this.subscriberId,
    required this.email,
    required this.fullName,
  });

  final String token;
  final String tokenType;
  final DateTime expiresAt;
  final String accountId;
  final String subscriberId;
  final String email;
  final String fullName;

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  factory Session.fromJson(Map<String, dynamic> json) => Session(
    token: json['token'] as String,
    tokenType: json['tokenType'] as String,
    expiresAt: DateTime.parse(json['expiresAt'] as String),
    accountId: json['accountId'] as String,
    subscriberId: json['subscriberId'] as String,
    email: json['email'] as String,
    fullName: json['fullName'] as String,
  );

  Map<String, dynamic> toJson() => {
    'token': token,
    'tokenType': tokenType,
    'expiresAt': expiresAt.toIso8601String(),
    'accountId': accountId,
    'subscriberId': subscriberId,
    'email': email,
    'fullName': fullName,
  };
}