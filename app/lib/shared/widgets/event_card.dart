// import 'package:flutter/material.dart';
// import '../../app/utils/app_colors.dart';
// import '../../models/event_model.dart';

// class EventCard extends StatelessWidget {
//   final EventModel event;

//   const EventCard({super.key, required this.event});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
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
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Event Image
//           ClipRRect(
//             borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
//             child: Stack(
//               children: [
//                 Container(
//                   width: double.infinity,
//                   height: 160,
//                   color: Colors.grey.shade200,
//                   child: const Icon(
//                     Icons.image,
//                     size: 40,
//                     color: Colors.grey,
//                   ),
//                 ),
//                 Positioned(
//                   top: 12,
//                   right: 12,
//                   child: Container(
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                     decoration: BoxDecoration(
//                       color: event.status == 'upcoming'
//                           ? AppColors.primary
//                           : Colors.grey,
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Text(
//                       event.status,
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 12,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // Event Details
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   event.title,
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   event.description,
//                   style: const TextStyle(
//                     color: Colors.grey,
//                     fontSize: 14,
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 Row(
//                   children: [
//                     const Icon(Icons.calendar_today,
//                         size: 16, color: Colors.grey),
//                     const SizedBox(width: 8),
//                     Text(
//                       '${_formatDate(event.date)} at ${event.time}',
//                       style: const TextStyle(
//                         color: Colors.grey,
//                         fontSize: 14,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 8),
//                 Row(
//                   children: [
//                     const Icon(Icons.location_on, size: 16, color: Colors.grey),
//                     const SizedBox(width: 8),
//                     Expanded(
//                       child: Text(
//                         event.location,
//                         style: const TextStyle(
//                           color: Colors.grey,
//                           fontSize: 14,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 16),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: ElevatedButton(
//                         onPressed: event.isRegistrationOpen ? () {} : null,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: AppColors.primary,
//                           foregroundColor: Colors.white,
//                         ),
//                         child: Text(event.isRegistrationOpen
//                             ? 'Register'
//                             : 'View Details'),
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     IconButton(
//                       onPressed: () {},
//                       icon: const Icon(Icons.favorite_border),
//                       style: IconButton.styleFrom(
//                         side: BorderSide(color: Colors.grey.shade300),
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

//   String _formatDate(DateTime date) {
//     const months = [
//       'Jan',
//       'Feb',
//       'Mar',
//       'Apr',
//       'May',
//       'Jun',
//       'Jul',
//       'Aug',
//       'Sep',
//       'Oct',
//       'Nov',
//       'Dec'
//     ];
//     return '${months[date.month - 1]} ${date.day}, ${date.year}';
//   }
// }
