// import 'dart:convert';

// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/date_symbol_data_local.dart';
// import 'package:intl/intl.dart';
// import 'package:schedule_generator/models/task.dart';

// class GeminiService {
//   // adalah gerbang awal antara client dan server
//   //client --> kode project / app yg udh dideploy
//   //server --> Gemini API
//   static const String _baseUrl =
//       "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent"; //static best practis nya pake underscore (_)

//   // KALO MAU BIKIN APP YANG ADA AI NYA, WAJIB ADA MODEL DAN SERVICES.

//   final String apiKey;
//   //Adalah sebuah ternary operator utk memastikan nilai dari API Key ada atau kosong
//   GeminiService() : apiKey = dotenv.env["GEMINI_API_KEY"] ?? "" {
//     if (apiKey.isEmpty) {
//       throw ArgumentError("Please input your API Key");
//     }
//   }

//   // logika untuk generate result dari input/prompt yg diberikan yg akan otomisasi oleh AI API
//   Future<String> generateSchedule(List<Task> tasks) async {
//     _validateTask(tasks);
//     //variabel yg digunakan utk menampung prompt yg akan dieksekusi AI
//     final prompt = _buildPrompt(tasks);

//     // blok try adalah untuk percobaan pengiriman request ke AI
//     try {
//       print("Prompt : \n$prompt");
//       // variable yg digunakan buat nampung respon dari request ke API AI
//       final response = await http.post(
//         // adalah starting point utk menggunakan endpoint dari API
//         // cara panggil base url + api key(endpoint) itu pake URI.parse
//         Uri.parse("$_baseUrl?key=$apiKey"),
//         headers: {"Content-Type": "application/json"},
//         // Encode ngacak(ga rapi), decode dibenerin
//         body: jsonEncode({
//           "contents": [
//             {
//               // role maksudnya seseorang yg ngasih instruksi pada AI lewat prompt
//               "role": "user",
//               "parts": [
//                 {"text": prompt},
//               ],
//             },
//           ],
//         }),
//       );

//       return _handleResponse(response);
//     } catch (e) {
//       throw ArgumentError("Failed to generate schedule. $e");
//     }
//   }

//   String _handleResponse(http.Response response) {
//     final data = jsonDecode(response.body);
//     //switch adalah satu cabang perkondisian yg isinya statement general yg bisa dieksekusi sama semua action tanpa haru bergantung
//     // sama single-statement yg dimiliki oleh setiap action yg ada di parameter case
//     switch (response.statusCode) {
//       // case nya action yg akan dilakukan
//       case 200:
//         return data["Candidate"][0]["content"]["parts"][0]["text"];
//       case 404:
//         throw ArgumentError("Server Not Found");
//       case 500:
//         throw ArgumentError("Internal Server Error");
//       default:
//         throw ArgumentError("Unknown Error: ${response.statusCode}");
//     }
//   }

//   String _buildPrompt(List<Task> tasks) {
//     // berfungsi untuk nyetting format tanggal dan waktu
//     initializeDateFormatting;
//     final dateFormatter = DateFormat("dd mm yyyy 'pukul' hh:mm, 'id_ID'");
//     final taskList = tasks.map((task) {
//       final formatDeadline = dateFormatter.format(task.deadline);
//       return "- ${task.name} (Duration: ${task.duration} minutes, Deadline: $formatDeadline)";
//     });

//     // menggunakan framework R-T-A (Roles-Task_Action) utk prompting
//     return '''
//     Saya adalah seorang siswa, dan saya memiliki daftar sebagai berikut:
//     $taskList

//     Tolong susun jadwal yang optimal dan efisien berdasarkan daftar tugas berikut!
//     Tolong tentukan prioritasnya berdasarkan *deadline yang paling dekat* dan *durasi tugas*
//     Tolong Buat Jadwal yang sistemtis dari pagi hari, sampai malam hari. Pastikan semua tugas dapat selesai
//     sebelum deadline.
//     Tolong buatkan output jadwal dalam format list per jam, misalnya :
//     - 07:00 - 08:00 : Melaksanakan piket kamar

// ''';
//   }

//   void _validateTask(List<Task> tasks) {
//     // ini bentuk single statement dari if else condition
//     if (tasks.isEmpty)
//       throw ArgumentError("Please input your tasks before generating");
//   }
// }

import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:schedule_generator/models/task.dart';

class GeminiService {
  // untuk gerbang komunikasi awal antara client dan server
  // client --> kode project atau aplikasi yang telah dideploy
  // server --> Gemini API
  static const String _baseUrl =
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent";

  final String apiKey;

  /*
  ini adalah sebuah ternary operator untuk memastikan..
  apakah nilai dari API KEY tersedia atau kosong
  */
  GeminiService() : apiKey = dotenv.env["GEMINI_API_KEY"] ?? "" {
    if (apiKey.isEmpty) {
      throw ArgumentError("Please input your API KEY");
    }
  }

  // logika untuk generating result dari input/prompt yang diberikan
  // yang akan diotomasi oleh AI API
  Future<String> generateSchedule(List<Task> tasks) async {
    _validateTasks(tasks);
    // variable yang digunakkna untuk menampung prompt request yang akan dieksekusi oleh AI
    final prompt = _buildPrompt(tasks);

    // sebagai percobaan pengiriman request ke AI
    try {
      print("Prompt: \n$prompt");

      // variable yang digunakan untuk menampung respon dari request ke API AI
      final response = await http.post(
        // ini adalah starting point untuk penggunakan endpoint dari API
        Uri.parse("$_baseUrl?key=$apiKey"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "contents": [
            {
              // role disini maksudnya adalah seseorang yang memberikan instruksi kepada AI melalui prompt
              "role": "user",
              "parts": [
                {"text": prompt},
              ],
            },
          ],
        }),
      );

      return _handleResponse(response);
    } catch (e) {
      throw ArgumentError("Failed to generate schedule: $e");
    }
  }

  String _handleResponse(http.Response response) {
    final data = jsonDecode(response.body);
    /*
    switch adalah salah satu cabang dari perkondisian yang berisi statement general
    yang dapat dieksekusi oleh berbagai macam action (case), tanpa harus bergantung pada 
    single-statement yang dimiliki oleh setiap action yang ada pada parameter "case"
    */
    switch (response.statusCode) {
      case 200:
        return data["candidates"][0]["content"]["parts"][0]["text"];
      case 404:
        throw ArgumentError("Server Not Found");
      case 500:
        throw ArgumentError("Internal Server Error");
      default:
        throw ArgumentError("Unknown Error: ${response.statusCode}");
    }
  }

  String _buildPrompt(List<Task> tasks) {
    // berfungsi untuk menyetting format tanggal dan waktu lokal (indonesian)
    initializeDateFormatting();
    final dateFormatter = DateFormat("dd mm yyyy 'pukul' hh:mm, 'id_ID");

    final taskList = tasks.map((task) {
      final formatDeadline = dateFormatter.format(task.deadline);
      return "- ${task.name} (Duration: ${task.duration} minutes, Deadline: $formatDeadline)";
    });

    // menggunakan framework R-T-A (Roles-Task_Action) untuk prompting
    return '''
    Saya adalah seorang siswa, dan saya memiliki daftar sebagai berikut:

    $taskList

    Tolong susun jadwal yang optimal dan efisien berdasarkan daftar tugas tersebut.
    Tolong tentukan prioritasnya berdasarkan deadline yang paling dekat dan durasi tugas.
    Tolong buat jadwal yang sistematis dari pagi hari, sampai malam hari.
    Tolong pastikan semua tugas dapat selesai sebelum deadline.

    Tolong buatkan output jadwal dalam format list per jam, misalnya:
    - 07:00 - 08-00 : Melaksanakan piket kamar
    ''';
  }

  void _validateTasks(List<Task> tasks) {
    // ini merupaan bentuk dari single statement dari if-else condition
    if (tasks.isEmpty)
      throw ArgumentError("Please input your tasks before generating");
  }
}
