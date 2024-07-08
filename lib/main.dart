import 'package:flutter/material.dart';
import 'package:input_mahasiswa/login.dart';
import 'package:path/path.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://gbbydbhhzwzvwxcutbek.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdiYnlkYmhoend6dnd4Y3V0YmVrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTk4MzgyMDEsImV4cCI6MjAzNTQxNDIwMX0.7q0NxluEYRJiMoawxqtr5OrZrYrq34u8JRezo_vGSxo',
  );

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Login(),
    );
  }
}
