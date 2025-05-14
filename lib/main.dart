import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:schedule_generator/ui/home_screen.dart';

Future<void> main() async {
  //main function = Fungsi utama. Flutter bakal nyari fungsi ini pertama kali waktu app dijalankan.
  await dotenv.load(fileName: ".env");
  await initializeDateFormatting('id_ID', null);
  runApp(ScheduleGeneratorApp());
}

class ScheduleGeneratorApp extends StatelessWidget {
  const ScheduleGeneratorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Schedule Generator App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
      ),
      home: HomeScreen(),
    );
  }
}
