// import 'dart:async';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'process_list_event.dart';
// import 'process_list_state.dart';
//
// class ProcessListBloc extends Bloc<ProcessListEvent, ProcessListState> {
//   ProcessListBloc() : super(ProcessListInitialState()) {
//     on<FetchProcessListEvent>(_onFetchProcessList);
//   }
//
//   Future<void> _onFetchProcessList(
//       FetchProcessListEvent event, Emitter<ProcessListState> emit) async {
//     emit(ProcessListLoadingState());
//
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final lid = prefs.getString('lid') ?? '';
//
//       final url = Uri.parse(
//           'https://mycitywebapi.randomaccess.ca/mycityapi/GetProcessListByLid_t');
//
//       final response = await http.post(url,
//           body: jsonEncode({
//             "token": "ABCD1",
//             "imei": "D237DBC1-D0A6-4FB8-8E45-21C0785BB63E", // Replace with the actual IMEI
//             "lid": lid,          // Use the stored lid
//             "openOrClose": "O",
//             "daysFrom": 0
//           }),
//           headers: {"Content-Type": "application/json"});
//
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         if (data['isSuccess']) {
//           emit(ProcessListLoadedState(data['processList']));
//         } else {
//           emit(ProcessListErrorState(data['message'] ?? 'Failed to fetch data'));
//         }
//       } else {
//         emit(ProcessListErrorState('Failed to fetch data. Status code: ${response.statusCode}'));
//       }
//     } catch (e) {
//       emit(ProcessListErrorState('Error: $e'));
//     }
//   }
// }
