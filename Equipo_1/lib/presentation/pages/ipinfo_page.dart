// import 'package:flutter/material.dart';
// import 'package:proyectos/models/ipinfo_model.dart';
// import '../../services/ipinfo_service.dart';

// class IpInfoPage extends StatelessWidget {
//   const IpInfoPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Geolocalización (IPInfo)")),
//       body: FutureBuilder(
//         future: getIpInfo(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           final info = snapshot.data!;

//           return Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "IP: ${info.ip}\nCiudad: ${info.ciudad}\nRegión: ${info.estado}\nPaís: ${info.pais}\nUbicación: ${info.loc}",
//                   style: const TextStyle(fontSize: 16),
//                 ),
//                 const SizedBox(height: 20),
//                 _buildCoordenadasSection(info),
//                 const SizedBox(height: 20),
//                 _buildActionButtons(context),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildCoordenadasSection(IpInfo info) {
//     return Card(
//       elevation: 2,
//       child: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               "Coordenadas para API de Constelaciones:",
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             Text("Latitud: ${info.latitud ?? 'No disponible'}"),
//             Text("Longitud: ${info.longitud ?? 'No disponible'}"),
//             const SizedBox(height: 8),
//             if (info.tieneCoordenadasValidas)
//               Container(
//                 padding: const EdgeInsets.all(8),
//                 color: Colors.green[50],
//                 child: Text(
//                   "✓ Coordenadas válidas disponibles para usar en APIs",
//                   style: TextStyle(color: Colors.green[800]),
//                 ),
//               )
//             else
//               Container(
//                 padding: const EdgeInsets.all(8),
//                 color: Colors.orange[50],
//                 child: const Text(
//                   "⚠ No se pudieron obtener coordenadas válidas",
//                   style: TextStyle(color: Colors.orange),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildActionButtons(BuildContext context) {
//     return Row(
//       children: [
//         ElevatedButton(
//           onPressed: () {
//             final infoLocal = IpInfoService.ipInfoCache;
//             if (infoLocal != null) {
//               showDialog(
//                 context: context,
//                 builder: (context) => AlertDialog(
//                   title: const Text('Información Almacenada'),
//                   content: Text(
//                     'Coordenadas disponibles localmente:\n'
//                     'Latitud: ${infoLocal.latitud ?? "N/A"}\n'
//                     'Longitud: ${infoLocal.longitud ?? "N/A"}',
//                   ),
//                   actions: [
//                     TextButton(
//                       onPressed: () => Navigator.pop(context),
//                       child: const Text('OK'),
//                     ),
//                   ],
//                 ),
//               );
//             }
//           },
//           child: const Text('Ver Info Local'),
//         ),
//         const SizedBox(width: 10),
//         ElevatedButton(
//           onPressed: () {
//             _usarCoordenadasParaConstelaciones();
//           },
//           child: const Text('Usar para Constelaciones'),
//         ),
//       ],
//     );
//   }

//   void _usarCoordenadasParaConstelaciones() {
//     if (IpInfoService.tieneCoordenadasValidas) {
//       final lat = IpInfoService.latitudLocal;
//       final lon = IpInfoService.longitudLocal;
//       print('Usando coordenadas para constelaciones: $lat, $lon');
//     }
//   }
// }
