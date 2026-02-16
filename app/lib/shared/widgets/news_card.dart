// import 'package:flutter/material.dart';

// class NewsCard extends StatelessWidget {
//   final String title;
//   final String date;
//   final String preview;
//   final Color color;

//   const NewsCard({
//     super.key,
//     required this.title,
//     required this.date,
//     required this.preview,
//     required this.color,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(8),
//         border: Border(
//           left: BorderSide(color: color, width: 4),
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             title,
//             style: const TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 14,
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             date,
//             style: const TextStyle(
//               color: Colors.grey,
//               fontSize: 12,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             preview,
//             style: const TextStyle(
//               color: Colors.grey,
//               fontSize: 12,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
