import 'package:flutter/material.dart';
import 'package:agro_audit_rj/features/home/home_screen.dart';
import 'package:agro_audit_rj/features/map/map_screen.dart'; // Import do Mapa Real

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // Lista das telas que o menu vai abrir
  final List<Widget> _screens = [
    const HomeScreen(),        // Índice 0: Projetos
    const MapScreen(),         // Índice 1: Mapa Geral (AGORA O REAL)
    const PlaceholderSettings(), // Índice 2: Configurações
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        indicatorColor: const Color(0xFF2E7D32).withOpacity(0.2),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.folder_open_outlined),
            selectedIcon: Icon(Icons.folder, color: Color(0xFF2E7D32)),
            label: 'Projetos',
          ),
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map, color: Color(0xFF2E7D32)),
            label: 'Mapa Geral',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings, color: Color(0xFF2E7D32)),
            label: 'Ajustes',
          ),
        ],
      ),
    );
  }
}

// --- Tela de Configurações (Ainda provisória, vamos fazer depois) ---
class PlaceholderSettings extends StatelessWidget {
  const PlaceholderSettings({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Configurações")),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Perfil do Perito"),
            subtitle: const Text("Usuário Local"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text("Versão do App"),
            subtitle: const Text("1.0.0 (Beta)"),
          ),
        ],
      ),
    );
  }
}