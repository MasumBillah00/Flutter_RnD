import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/auth_bloc.dart';
import 'bloc/auth_event.dart';

class InactivityListener extends StatefulWidget {
  final Widget child;
  final Duration timeoutDuration;
  final Duration gracePeriodDuration;
  final ValueNotifier<int> inactivityTimerNotifier;
  final ValueNotifier<int> graceTimerNotifier;

  const InactivityListener({
    super.key,
    required this.child,
    required this.inactivityTimerNotifier,
    required this.graceTimerNotifier,
    this.timeoutDuration = const Duration(seconds: 180),
    this.gracePeriodDuration = const Duration(seconds: 60),
  });

  @override
  _InactivityListenerState createState() => _InactivityListenerState();
}

class _InactivityListenerState extends State<InactivityListener> {
  Timer? _inactivityTimer;
  Timer? _gracePeriodTimer;
  int _remainingInactivitySeconds = 0;
  int _remainingGraceSeconds = 0;
  bool _isGracePeriodActive = false;

  @override
  void initState() {
    super.initState();
    _startInactivityTimer();
  }

  @override
  void dispose() {
    _inactivityTimer?.cancel();
    _gracePeriodTimer?.cancel();
    super.dispose();
  }

  void _startInactivityTimer() {
    _cancelInactivityTimer();
    //print('set new time');
    _remainingInactivitySeconds = widget.timeoutDuration.inSeconds;
    _inactivityTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingInactivitySeconds > 0) {
        _remainingInactivitySeconds--;
        widget.inactivityTimerNotifier.value = _remainingInactivitySeconds;
      } else {
        timer.cancel();
        _handleInactivity();
      }
    });
  }

  void _handleInactivity() {
    _startGracePeriod();
  }

  void _startGracePeriod() {
    setState(() {
      _isGracePeriodActive = true;
    });
    //print('start grace timer');

    _remainingGraceSeconds = widget.gracePeriodDuration.inSeconds;
    widget.graceTimerNotifier.value = _remainingGraceSeconds;

    _gracePeriodTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingGraceSeconds > 0) {
        _remainingGraceSeconds--;
        widget.graceTimerNotifier.value = _remainingGraceSeconds;
      } else {
        timer.cancel();
        _performLogout();
      }
    });
  }

  void _performLogout() {
    BlocProvider.of<AuthBloc>(context).add(AutoLogoutEvent());
  }

  void _resetInactivityTimer() {
    _startInactivityTimer();
    if (_isGracePeriodActive) {
      _cancelGracePeriodTimer();
    }
  }

  void _cancelInactivityTimer() {
    _inactivityTimer?.cancel();
  }

  void _cancelGracePeriodTimer() {
    _gracePeriodTimer?.cancel();
    setState(() {
      _isGracePeriodActive = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: _resetInactivityTimer,
      onPanDown: (_) => _resetInactivityTimer(),
      child: widget.child,
    );
  }
}

class TimerDisplay extends StatelessWidget {
  final ValueNotifier<int> inactivityTimerNotifier;
  final ValueNotifier<int> graceTimerNotifier;

  const TimerDisplay({
    super.key,
    required this.inactivityTimerNotifier,
    required this.graceTimerNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      height: 60,
      padding: const EdgeInsets.all(1.0),
      child: Card(

        color:Colors.blueGrey.shade900,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ValueListenableBuilder<int>(
              valueListenable: inactivityTimerNotifier,
              builder: (context, value, child) {
                return Text(
                  'Inactivity: $value s',
                  style: const TextStyle(color: Colors.white),
                );
              },
            ),
            ValueListenableBuilder<int>(
              valueListenable: graceTimerNotifier,
              builder: (context, value, child) {
                return Text(
                  'Grace: $value s',
                  style: const TextStyle(color: Colors.white),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
