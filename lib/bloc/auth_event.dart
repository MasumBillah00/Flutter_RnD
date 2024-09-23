abstract class AuthEvent {}

class LoginEvent extends AuthEvent {
  final String username;
  final String password;
  LoginEvent(this.username, this.password);
}

class BiometricLoginEvent extends AuthEvent {
  final String userId;
  final String deviceId;
  final String biotoken;
  final String token; // Add this
  final String imei; // Add this

  BiometricLoginEvent(this.userId, this.deviceId, this.biotoken, this.token, this.imei);
}

class LogoutEvent extends AuthEvent {}

class AutoLogoutEvent extends AuthEvent {}

// class LoadingState extends AuthEvent {}