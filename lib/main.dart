import 'package:flutter/material.dart';
import 'package:agro_audit_rj/data/local_db.dart'; // Import do Banco
import 'package:agro_audit_rj/features/home/home_screen.dart'; // Import da Tela Home

void main() async {
  // Garante que o Flutter está pronto
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializa o Banco de Dados antes do app abrir
  await LocalDB.init();
  
  runApp(const AgroAuditApp());
}

class AgroAuditApp extends StatelessWidget {
  const AgroAuditApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agro Audit RJ',
      debugShowCheckedModeBanner: false, // Remove a faixa "Debug"
      theme: ThemeData(
        // Define o Verde como cor padrão do App
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2E7D32)),
        useMaterial3: true,
        
        // Estilo padrão dos cartões e botões
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2E7D32),
          foregroundColor: Colors.white,
        ),
      ),
      // AQUI ESTÁ O PULO DO GATO:
      // Trocamos o Scaffold provisório pela tela real
      home: const HomeScreen(), 
    );
  }
}