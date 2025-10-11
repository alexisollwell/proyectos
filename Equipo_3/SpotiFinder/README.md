# SpotiFinder

Proyecto Flutter + Node.js que busca canciones y muestra previews usando la API de Spotify.

## Requisitos

  - Flutter 3.0+  
  - Node.js 18+  
  - npm  
  - Cuenta de desarrollador Spotify para obtener CLIENT_ID y CLIENT_SECRET

## Configuración backend

1. Ir a la carpeta `backend`:

  - Abrir la terminal en la carpeta Backend o navegar hasta alli 

2. Instalar dependencias desde la terminal (ya estando en carpeta backend)
  - npm install

3. Deben crear un .env con sus credenciales, se obtienen en la pagina web oficial de Spotify y ponerlo en la carpeta backend
  - CLIENT_ID=tu_client_id_aqui
  - CLIENT_SECRET=tu_client_secret_aqui
  - PORT=3000

4. Ejecutar backend (Desde la misma terminal)
  - node server.js

## Configuración Flutter

1. Instalar dependencias (en la carpeta donde esta el archivo pubspec.ya, osea en spotifinder)
  - flutter pub get

2. Ejecutar app (si abren backend y spotifinder juntos en VSCode no funciona, asegurense de ejecutar comando desde una cmd abierta en spotifinder o en VSCode click derecho a carpeta spotifinder y darle a la opcion "abrir en terminal integrada")
- flutter run 
