
import 'dart:async';
import 'package:autologout_biometric/service/deviceid/deviceid_imei.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(LoggedOutState()) {
    on<LoginEvent>(_onLogin);
    on<LogoutEvent>(_onLogout);
    on<AutoLogoutEvent>(_onAutoLogout);
    on<BiometricLoginEvent>(_onBiometricLogin);
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(LoadingState()); // Show loading indicator while login process happens
    final url = Uri.parse('https://mycitywebapi.randomaccess.ca/mycityapi/LoginWebAPI');
    final response = await http.post(url,
        body: jsonEncode({
          "token": "ABCD1",
          "imei": await getDeviceId(),
          "userName": event.username,
          "password": event.password
        }),
        headers: {"Content-Type": "application/json"});

    final data = json.decode(response.body);
    if (response.statusCode == 200 && data['isSuccess']) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('lid', data['lid']);
      await prefs.setString('loggedUser', data['loggedUser']);
      await prefs.setString('validUserId', data['validUserId']);

      print('Login successful. lid=${data['lid']}');

      emit(LoggedInState(data['loggedUser']));
    } else {
      emit(LoginFailureState(data['message'] ?? 'Login failed'));
    }
  }

  Future<void> _onBiometricLogin(BiometricLoginEvent event, Emitter<AuthState> emit) async {
    emit(LoadingState()); // Show loading indicator during biometric login
    final url = Uri.parse('https://mycitywebapi.randomaccess.ca/mycityapi/AutoLoginByBiometric');

    try {
      final response = await http.post(url,
          body: jsonEncode({
            "userid": event.userId,
            "deviceid": event.deviceId,
            "biotoken": event.biotoken,
            "token": event.token,
            "imei": event.imei
          }),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${event.token}"
          });

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['isSuccess']) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('lid', data['lid']);
        await prefs.setString('loggedUser', data['loggedUser']);
        await prefs.setString('validUserId', data['validUserId']);

        print('Biometric login successful. lid=${data['lid']}');

        emit(LoggedInState(data['loggedUser']));
      } else {
        emit(LoginFailureState(data['message'] ?? 'Biometric login failed'));
      }
    } catch (e) {
      emit(LoginFailureState('An error occurred: ${e.toString()}'));
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(LoadingState()); // Show loading indicator during logout
    final prefs = await SharedPreferences.getInstance();

    // Preserve biometric info
    final userId = prefs.getString('userid');
    final deviceId = prefs.getString('deviceid');
    final bioToken = prefs.getString('biotoken');
    final biometricEnabled = prefs.getBool('biometricEnabled') ?? false;
    final biometricPrompted = prefs.getBool('biometricPrompted') ?? false;
    final lid = prefs.getString('lid') ?? '';

    final url = Uri.parse('https://mycitywebapi.randomaccess.ca/mycityapi/LogOffWebAPI');
    await http.post(
      url,
      body: jsonEncode({
        "token": "ABCD1", // Replace with actual token if needed
        "imei": await getDeviceId(), // Replace with actual IMEI
        "lid": lid,
      }),
      headers: {"Content-Type": "application/json"},
    );

    // Clear all preferences but restore biometric info
    await prefs.clear();

    if (userId != null && deviceId != null && bioToken != null) {
      await prefs.setString('userid', userId);
      await prefs.setString('deviceid', deviceId);
      await prefs.setString('biotoken', bioToken);
    }

    await prefs.setBool('biometricEnabled', biometricEnabled);
    await prefs.setBool('biometricPrompted', biometricPrompted);

    emit(LoggedOutState());
  }

  Future<void> _onAutoLogout(AutoLogoutEvent event, Emitter<AuthState> emit) async {
    await _onLogout(LogoutEvent(), emit);
  }
}

