import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import necessário
import 'package:agro_audit_rj/data/local_db.dart';
import 'package:agro_audit_rj/features/home/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializa o banco de dados
  await LocalDB.init();
  
  runApp(
    // O ProviderScope armazena o estado de todos os providers
    const ProviderScope(
      child: AgroAuditApp(),
    ),
  );
}

class AgroAuditApp extends StatelessWidget {
  const AgroAuditApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agro Audit RJ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2E7D32)),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2E7D32),
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
      ),
      // TROQUE AQUI: Para habilitar o menu inferior
      home: const MainScreen(), 
    );
  }
}