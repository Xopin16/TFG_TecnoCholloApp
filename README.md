# TECNOCHOLLOAPP

Bienvenido al repositorio de Chollos de Segunda Mano, una aplicación que te permite encontrar y comprar productos de segunda mano a precios reducidos. Esta aplicación consta de una API desarrollada en Spring con Java y un frontend desarrollado en Flutter (para la versión móvil) y Angular (para la versión web).

## Funcionalidades

- Registro de usuarios: Los usuarios deben crear una cuenta para acceder a las funcionalidades de la aplicación.
- Búsqueda y filtrado de chollos: Los usuarios pueden buscar productos de segunda mano y aplicar filtros por categoría y nombre.
- Detalles de los chollos: Los usuarios pueden ver información detallada de cada chollo, incluyendo descripción, foto y precio.
- Gestión de favoritos: Los usuarios pueden marcar chollos como favoritos para guardarlos y acceder fácilmente más tarde.
- Proceso de compra: Los usuarios pueden realizar compras directamente desde la aplicación.

## Tecnologías utilizadas

- Backend:
  - Java
  - Spring Framework
  - Base de datos (PostgreSQL)
- Frontend:
  - Flutter (versión móvil)
  - Angular (versión web)

## Estructura del repositorio

El repositorio está organizado de la siguiente manera:

- `/tecnocholloapp`: Contiene el código fuente y la configuración de la API en Spring con Java.
- `/flutter_tecnocholloapp`: Contiene el código fuente de la aplicación móvil desarrollada en Flutter.
- `/angular_tecnocholloapp`: Contiene el código fuente de la aplicación web desarrollada en Angular.

## Requisitos de instalación

Antes de ejecutar la aplicación, asegúrate de tener instaladas las siguientes herramientas y dependencias:

- Backend:
  - Java JDK 8 o superior
  - Maven
  - Base de datos (PostgreSQL) y sus credenciales de acceso
  - Docker

- Frontend:
  - Flutter SDK y dependencias según las instrucciones de Flutter (https://flutter.dev/docs/get-started/install)
  - Node.js y npm (https://nodejs.org/en/download/)

## Configuración y ejecución

Sigue estos pasos para configurar y ejecutar la aplicación:

1. Clona este repositorio en tu máquina local: `git clone https://github.com/Xopin16/TFG_TecnoCholloApp.git`
2. Configuración del backend:
   - Abre el proyecto backend en tu IDE preferido (por ejemplo, IntelliJ, Eclipse).
   - Actualiza la configuración de la base de datos en el archivo `backend/src/main/resources/application.properties` con tus propias credenciales.
   - Abre el terminal, ve al directorio `/tecnocholloapp` y ejecuta docker compose up -d
   - Compila y ejecuta la aplicación backend.
3. Configuración del frontend:
   - Para la aplicación móvil Flutter, ve al directorio `/flutter_tecnocholloapp` y ejecuta `flutter pub get` para obtener las dependencias necesarias.
   - Para la aplicación web Angular, ve al directorio `/angular_tecnocholloapp` y ejecuta `npm install` para obtener las dependencias necesarias.
   - Inicia la aplicación frontend según las instrucciones específicas de cada tecnología.

## Contacto

Si tienes alguna pregunta, sugerencia o problema, no dudes en contactarme a través de email:

- Email: rivas.fujos20@triana.salesianos.edu

¡Gracias por tu interés en TecnocholloApp!
