class Credentials {
  final String applicationId;
  final String masterKey;
  String sessionId;

  Credentials(this.applicationId, [this.masterKey]);

  @override
  String toString() => "${applicationId}";
}