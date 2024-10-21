import 'package:autologout_biometric/landing_page.dart';
import 'package:autologout_biometric/screens/loginpage.dart';
import 'package:autologout_biometric/theme/apptheme.dart';
import 'package:autologout_biometric/todo_app/bloc/image_picker/image_picker_bloc.dart';
import 'package:autologout_biometric/todo_app/bloc/note/note_bloc.dart';
import 'package:autologout_biometric/todo_app/bloc/note/note_event.dart';
import 'package:autologout_biometric/todo_app/bloc/todo_app/todo_app_bloc.dart';
import 'package:autologout_biometric/todo_app/database/dataase_helper.dart';
import 'package:autologout_biometric/todo_app/database/note_database.dart';
import 'package:autologout_biometric/todo_app/repository/todo_repository.dart';
import 'package:autologout_biometric/todo_app/ulitis/image_picker_itilis.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/auth_bloc.dart';
import 'bloc/auth_state.dart';
import 'fitness_tracker/bloc/workout_bloc.dart';
import 'fitness_tracker/bloc/workout_event.dart';
import 'fitness_tracker/repository/workout_repository.dart';
import 'inactivitytimer.dart';

void main() {
  final databaseHelper = TodoDatabaseHelper();
  final noteDatabaseProvider = DatabaseProvider();
  runApp(MyApp(databaseHelper, noteDatabaseProvider));
}
class MyApp extends StatelessWidget {
  final inactivityTimerNotifier = ValueNotifier<int>(120);
  final graceTimerNotifier = ValueNotifier<int>(60);
  final TodoDatabaseHelper databaseHelper;
  final DatabaseProvider noteDatabaseProvider;
   MyApp(this.databaseHelper, this.noteDatabaseProvider, {super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => WorkoutRepository(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => AuthBloc()),
          BlocProvider(
            create: (context) => WorkoutBloc(context.read<WorkoutRepository>())..add(LoadWorkouts()),
          ),
          BlocProvider(
            create: (_) => ToDoAppBloc(ToDoAppRepository(databaseHelper)),
          ),
          BlocProvider<NoteBloc>(
            create: (_) => NoteBloc(noteDatabaseProvider)..add(LoadNotes()),
          ),
          BlocProvider(
            create: (context) => ImagePickerBloc(ImagePickerUtils()),
          ),
        ],
        child: InactivityListener(
          inactivityTimerNotifier: inactivityTimerNotifier,
          graceTimerNotifier: graceTimerNotifier,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter RND',
            theme: AppTheme.lightTheme,
            home: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is LoggedInState) {
                  return Landing_Page(
                    inactivityTimerNotifier: inactivityTimerNotifier,
                    graceTimerNotifier: graceTimerNotifier,
                  );
                } else {
                  return LoginPage(
                    inactivityTimerNotifier: inactivityTimerNotifier,
                    graceTimerNotifier: graceTimerNotifier,
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
