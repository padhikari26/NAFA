// import 'package:flutter/material.dart';

// class StatsCard extends StatelessWidget {
//   final String number;
//   final String label;

//   const StatsCard({
//     super.key,
//     required this.number,
//     required this.label,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Text(
//             number,
//             style: TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//               color: _getColor(label),
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             label,
//             style: const TextStyle(
//               color: Colors.grey,
//               fontSize: 12,
//             ),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }

//   Color _getColor(String label) {
//     switch (label) {
//       case 'Members':
//         return Colors.blue;
//       case 'Events/Year':
//         return Colors.green;
//       case 'Years':
//         return Colors.purple;
//       default:
//         return Colors.blue;
//     }
//   }
// }
