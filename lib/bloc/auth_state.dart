abstract class AuthState {}

class LoggedOutState extends AuthState {}

class LoggedInState extends AuthState {
  final String loggedUser;
  LoggedInState(this.loggedUser);
}

class LoginFailureState extends AuthState {
  final String message;
  LoginFailureState(this.message);
}

class LoadingState extends AuthState {
  // Optional: Add any additional properties if needed
  LoadingState();
}
