# organizador_de_tareas

aplicacion FInal de futtler

## Getting Started

This project is a starting point for a Flutter application.

Estructura del Proyecto OrganiTecnm
La aplicación se puede dividir en cuatro secciones principales (pestañas), y cada una requiere un enfoque diferente en Flutter y sus dependencias.

1. 📅 Horarios (General y Diario)
   Este será el núcleo de la aplicación y la parte más sencilla de implementar inicialmente.

¿Cómo se ve? Lo más probable es que uses un widget como TabBar para tener pestañas para "Horario General" y "Horario Diario".

Gestión de Datos: Necesitarás una fuente de datos (puede ser una base de datos local como Hive o SQLite, o una base de datos en la nube como Firestore o Supabase si los datos se cargan desde un servidor).

Lógica de "Hoy": Para el horario diario, usarías la clase DateTime de Dart para obtener el día de la semana actual y filtrar la lista completa de horarios de ese profesor.

2. 📝 Notas y Recordatorios
   Esta es una sección de productividad clásica y se beneficia de una base de datos local para que el profesor pueda usarlas sin conexión.

Funcionalidad: Los profesores podrán agregar, editar, marcar como completadas y eliminar notas/recordatorios.

Base de Datos Recomendada: Hive es ideal para esto en Flutter. Es una base de datos NoSQL muy rápida y fácil de integrar para almacenar datos en el dispositivo.

Widgets Clave: Usarías ListView.builder para mostrar la lista de notas y widgets como TextField para crear nuevas notas.

3. 🧠 Sugerencias Impulsadas por IA (Tu Duda Principal)
   Esta es la parte más avanzada, pero la idea es muy interesante. Usar un modelo de IA para dar sugerencias basadas en el contexto de la aplicación.

El Enfoque de la IA:
Objetivo: La IA podría, por ejemplo, analizar el horario del profesor y ofrecer sugerencias como:

"Tienes 2 horas libres antes de tu próxima clase. ¿Quieres agregar una nota de recordatorio para calificar exámenes?"

"Mañana es un día pesado (5 clases). Te sugiero agregar una alarma 15 minutos antes de lo usual."

Integración Técnica:
Modelo de IA de Google: Puedes usar el SDK de Google AI (actualmente, el modelo Gemini) para interactuar directamente desde Flutter.

¿Cómo funciona? Envías un "prompt" (una pregunta o contexto) a la IA con los datos del profesor (ej. "Mi horario de mañana es [DATA]. Dame una sugerencia de productividad."). La IA te devuelve una respuesta de texto.

Protocolo MCP: Este no es un protocolo estándar para IA, pero si te refieres a un Modelo de Computación Personalizado o un Protocolo Cliente/Modelo, la arquitectura sería:

Flutter (Cliente) ➡️ SDK de Google AI ➡️ Modelo de Gemini (Servidor).

Recomendación: Enfócate en usar el SDK de Google AI para Dart para hacer las peticiones a los modelos de Gemini. Es la forma más directa y oficial de integrar la IA de Google en tu app Flutter.