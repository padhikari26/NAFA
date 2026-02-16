// import 'package:flutter/material.dart';
// import '../../models/team_member_model.dart';

// class TeamMemberCard extends StatelessWidget {
//   final TeamMemberModel member;

//   const TeamMemberCard({super.key, required this.member});

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
//       child: Row(
//         children: [
//           CircleAvatar(
//             radius: 32,
//             backgroundColor: Colors.blue.shade100,
//             child: member.image != null
//                 ? ClipOval(
//                     child: Image.network(
//                       member.image!,
//                       width: 64,
//                       height: 64,
//                       fit: BoxFit.cover,
//                     ),
//                   )
//                 : Text(
//                     member.initials,
//                     style: const TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.blue,
//                     ),
//                   ),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   member.name,
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Text(
//                   member.position,
//                   style: const TextStyle(
//                     color: Colors.blue,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Row(
//                   children: [
//                     const Icon(Icons.phone, size: 14, color: Colors.grey),
//                     const SizedBox(width: 4),
//                     Text(
//                       member.phone,
//                       style: const TextStyle(
//                         color: Colors.grey,
//                         fontSize: 12,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 4),
//                 Row(
//                   children: [
//                     const Icon(Icons.email, size: 14, color: Colors.grey),
//                     const SizedBox(width: 4),
//                     Expanded(
//                       child: Text(
//                         member.email,
//                         style: const TextStyle(
//                           color: Colors.grey,
//                           fontSize: 12,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
