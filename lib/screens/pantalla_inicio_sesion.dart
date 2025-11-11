// lib/screens/pantalla_inicio_sesion.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/register_screen.dart';
import '../services/turso_service.dart';
import 'pantalla_principal.dart';

class PantallaInicioSesion extends StatefulWidget {
  const PantallaInicioSesion({super.key});

  @override
  State<PantallaInicioSesion> createState() => _EstadoPantallaInicioSesion();
}

class _EstadoPantallaInicioSesion extends State<PantallaInicioSesion> {
  final _claveFormulario = GlobalKey<FormState>();
  final TextEditingController _controladorUsuario = TextEditingController();
  final TextEditingController _controladorContrasena = TextEditingController();
  bool _estaCargando = false;
  bool _contrasenaOculta = true;

  @override
  void dispose() {
    _controladorUsuario.dispose();
    _controladorContrasena.dispose();
    super.dispose();
  }

  Future<void> _manejarInicioSesion() async {
    if (!_claveFormulario.currentState!.validate()) return;

    final usuario = _controladorUsuario.text.trim();
    final contrasena = _controladorContrasena.text;

    setState(() => _estaCargando = true);

    final exito = await ServicioTurso().iniciarSesion(
      usuario: usuario,
      contrasena: contrasena,
    );

    setState(() => _estaCargando = false);

    if (exito) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('sesion_iniciada', true);
      await prefs.setString('usuario', usuario);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PantallaPrincipal()),
      );
    } else {
      _mostrarSnackBar('Usuario o contraseña incorrectos', Colors.red);
    }
  }

  void _mostrarSnackBar(String mensaje, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: color,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _navegarARegistro() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const PantallaRegistro()),
    );
  }

  void _alternarVisibilidad() {
    setState(() => _contrasenaOculta = !_contrasenaOculta);
  }

  @override
  Widget build(BuildContext context) {
    final Color colorPrimario = Colors.blue.shade800;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Form(
            key: _claveFormulario,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(Icons.lock_open, size: 80, color: colorPrimario),
                const SizedBox(height: 16),
                Text(
                  'OrganiTecnm',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: colorPrimario,
                  ),
                ),
                const SizedBox(height: 40),
                TextFormField(
                  controller: _controladorUsuario,
                  decoration: InputDecoration(
                    labelText: 'Usuario',
                    prefixIcon: Icon(Icons.person, color: colorPrimario),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (v) => v == null || v.isEmpty
                      ? 'El usuario es obligatorio'
                      : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _controladorContrasena,
                  obscureText: _contrasenaOculta,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    prefixIcon: Icon(Icons.lock, color: colorPrimario),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _contrasenaOculta
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: colorPrimario,
                      ),
                      onPressed: _alternarVisibilidad,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (v) => v == null || v.isEmpty
                      ? 'La contraseña es obligatoria'
                      : null,
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _estaCargando ? null : _manejarInicioSesion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorPrimario,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _estaCargando
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Iniciar Sesión',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
                TextButton(
                  onPressed: _navegarARegistro,
                  child: Text(
                    '¿No tienes cuenta? Regístrate aquí',
                    style: TextStyle(
                      color: colorPrimario,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
