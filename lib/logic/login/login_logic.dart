import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/auth_bloc.dart';
import '../../bloc/auth_event.dart';


void loginUser(BuildContext context, String username, String password) async {
  if (username.isNotEmpty && password.isNotEmpty) {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await prefs.setString('password', password);

    BlocProvider.of<AuthBloc>(context).add(LoginEvent(username, password));
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please fill in both fields')),
    );
  }
}
