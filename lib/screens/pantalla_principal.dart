import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pantalla_inicio_sesion.dart';

class PantallaPrincipal extends StatefulWidget {
  const PantallaPrincipal({super.key});

  @override
  State<PantallaPrincipal> createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> {
  int _indiceSeleccionado = 0;
  String? _usuario;
  String? _email;

  @override
  void initState() {
    super.initState();
    _cargarDatosUsuario();
  }

  Future<void> _cargarDatosUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _usuario = prefs.getString('usuario');
      _email = prefs.getString('email');
    });
  }

  Future<void> _cerrarSesion() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const PantallaInicioSesion()),
      (route) => false,
    );
  }

  // 🔹 Contenido de cada pantalla
  static final List<Widget> _opcionesWidget = <Widget>[
    const Center(
      child: Text(
        'Aquí se mostrarán los Horarios.',
        style: TextStyle(fontSize: 24, color: Colors.blue),
      ),
    ),
    const Center(
      child: Text(
        'Aquí se gestionarán las Notas.',
        style: TextStyle(fontSize: 24, color: Colors.blue),
      ),
    ),
    const Center(
      child: Text(
        'Aquí vendrán las Sugerencias de la IA.',
        style: TextStyle(fontSize: 24, color: Colors.blue),
      ),
    ),
    const Center(
      child: Text(
        'Aplicación creada por el equipo OrganiTecnm.',
        style: TextStyle(fontSize: 18, color: Colors.grey),
      ),
    ),
  ];

  // 🔹 Títulos de cada sección
  static final List<String> _titulosPagina = <String>[
    'Horarios',
    'Notas',
    'IA Sugerencias',
    'Acerca de',
  ];

  // 🔹 Cambiar entre secciones
  void _alSeleccionarItem(int indice) {
    setState(() {
      _indiceSeleccionado = indice;
    });
    Navigator.pop(context);
  }

  // 🔹 Construcción de ítems del Drawer
  Widget _construirItemDrawer(IconData icono, String titulo, int indice) {
    return ListTile(
      leading: Icon(icono, color: Colors.blue.shade800),
      title: Text(titulo, style: const TextStyle(fontSize: 16)),
      selected: _indiceSeleccionado == indice,
      selectedTileColor: Colors.blue.shade50,
      onTap: () => _alSeleccionarItem(indice),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color colorPrimario = Colors.blue.shade800;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'OrganiTecnm - ${_titulosPagina[_indiceSeleccionado]}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: colorPrimario,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: 'Cerrar sesión',
            onPressed: _cerrarSesion, // ✅ Llama correctamente al método
          ),
        ],
      ),

      // ✅ Drawer (menú lateral)
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: colorPrimario),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.school, color: Colors.white, size: 48),
                  const SizedBox(height: 8),
                  Text(
                    _usuario != null ? 'Bienvenida/o $_usuario' : 'Cargando...',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _email ?? '',
                    style: TextStyle(color: Colors.blue.shade200, fontSize: 14),
                  ),
                ],
              ),
            ),

            // Opciones del menú
            _construirItemDrawer(Icons.calendar_today, 'Horarios', 0),
            _construirItemDrawer(Icons.note_alt, 'Notas', 1),
            _construirItemDrawer(Icons.lightbulb, 'IA Sugerencias', 2),
            const Divider(),
            _construirItemDrawer(Icons.info_outline, 'Acerca de', 3),

            const Divider(),

            // 🔹 Cerrar sesión (desde el menú)
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Cerrar Sesión'),
              onTap: () async {
                Navigator.pop(context); // Cierra el Drawer
                await _cerrarSesion();
              },
            ),
          ],
        ),
      ),

      body: _opcionesWidget[_indiceSeleccionado],
    );
  }
}
