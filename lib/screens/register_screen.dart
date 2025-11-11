import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/turso_service.dart';
import 'pantalla_inicio_sesion.dart';
import 'pantalla_principal.dart';

class PantallaRegistro extends StatefulWidget {
  const PantallaRegistro({super.key});

  @override
  State<PantallaRegistro> createState() => _EstadoPantallaRegistro();
}

class _EstadoPantallaRegistro extends State<PantallaRegistro> {
  final _claveFormulario = GlobalKey<FormState>();
  final TextEditingController _controladorCorreo = TextEditingController();
  final TextEditingController _controladorUsuario = TextEditingController();
  final TextEditingController _controladorContrasena = TextEditingController();
  bool _estaCargando = false;

  @override
  void dispose() {
    _controladorCorreo.dispose();
    _controladorUsuario.dispose();
    _controladorContrasena.dispose();
    super.dispose();
  }

  Future<void> _manejarRegistro() async {
    if (!_claveFormulario.currentState!.validate()) {
      return;
    }

    final correo = _controladorCorreo.text.trim();
    final usuario = _controladorUsuario.text.trim();
    final contrasena = _controladorContrasena.text;

    setState(() {
      _estaCargando = true;
    });

    final exito = await ServicioTurso().registrarUsuario(
      email: correo,
      usuario: usuario,
      contrasena: contrasena,
    );

    setState(() {
      _estaCargando = false;
    });

    if (exito) {
      // ✅ Guardar sesión iniciada en SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('sesion_iniciada', true);
      await prefs.setString('usuario', usuario);
      await prefs.setString('email', correo);

      _mostrarSnackBar(
        '¡Registro Exitoso! Bienvenido/a a OrganiTecnm.',
        Colors.green,
      );

      // ✅ Ir directo a la pantalla principal
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PantallaPrincipal()),
      );
    } else {
      _mostrarSnackBar(
        'Fallo al registrar. El usuario o correo ya están en uso o verifica la conexión.',
        Colors.red,
      );
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

  void _navegarAInicioSesion() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const PantallaInicioSesion()),
    );
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
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Icon(Icons.school, size: 80, color: colorPrimario),
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
                Text(
                  'Crea tu cuenta de Profesor',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 40),

                // Usuario
                TextFormField(
                  controller: _controladorUsuario,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: 'ej. prof_juan',
                    labelText: 'Nombre de Usuario',
                    prefixIcon: Icon(Icons.person, color: colorPrimario),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: colorPrimario, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (valor) {
                    if (valor == null || valor.isEmpty) {
                      return 'El nombre de usuario es obligatorio';
                    }
                    if (valor.length < 4) {
                      return 'El usuario debe tener al menos 4 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Correo
                TextFormField(
                  controller: _controladorCorreo,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'ejemplo@tecnm.mx',
                    labelText: 'Correo Institucional',
                    prefixIcon: Icon(Icons.email, color: colorPrimario),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: colorPrimario, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (valor) {
                    if (valor == null || valor.isEmpty) {
                      return 'El correo es obligatorio';
                    }
                    if (!valor.contains('@') || !valor.contains('.')) {
                      return 'Ingresa un correo válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Contraseña
                TextFormField(
                  controller: _controladorContrasena,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Mínimo 6 caracteres',
                    labelText: 'Contraseña',
                    prefixIcon: Icon(Icons.lock, color: colorPrimario),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: colorPrimario, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (valor) {
                    if (valor == null || valor.length < 6) {
                      return 'La contraseña debe tener al menos 6 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 40),

                // Botón de registro
                ElevatedButton(
                  onPressed: _estaCargando ? null : _manejarRegistro,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorPrimario,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                  ),
                  child: _estaCargando
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        )
                      : const Text(
                          'Crear Cuenta',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
                const SizedBox(height: 20),

                // Texto: ir a iniciar sesión
                TextButton(
                  onPressed: _navegarAInicioSesion,
                  child: Text(
                    '¿Ya tienes cuenta? Inicia Sesión',
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
