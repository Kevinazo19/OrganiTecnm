import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/pantalla_inicio_sesion.dart';
import 'screens/pantalla_principal.dart';

void main() {
  runApp(const AppOrganiTecnm());
}

class AppOrganiTecnm extends StatelessWidget {
  const AppOrganiTecnm({super.key});

  @override
  Widget build(BuildContext context) {
    final MaterialColor colorPrimario = Colors.blue;

    return MaterialApp(
      title: 'OrganiTecnm',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: colorPrimario,
        colorScheme: ColorScheme.fromSwatch(primarySwatch: colorPrimario),
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      home: const VerificarSesion(),
    );
  }
}

class VerificarSesion extends StatefulWidget {
  const VerificarSesion({super.key});

  @override
  State<VerificarSesion> createState() => _VerificarSesionState();
}

class _VerificarSesionState extends State<VerificarSesion> {
  bool _cargando = true;
  bool _sesionIniciada = false;

  @override
  void initState() {
    super.initState();
    _verificarSesion();
  }

  Future<void> _verificarSesion() async {
    final prefs = await SharedPreferences.getInstance();
    final sesion = prefs.getBool('sesion_iniciada') ?? false;

    setState(() {
      _sesionIniciada = sesion;
      _cargando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_cargando) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Si ya inició sesión, lo mandamos directo a la pantalla principal
    if (_sesionIniciada) {
      return const PantallaPrincipal();
    }

    // Si no ha iniciado sesión, mostramos el registro o login
    return const PantallaInicioSesion();
  }
}
