// import 'package:flutter/material.dart';

// import '../app/utils/app_colors.dart';

// class ReportsScreen extends StatelessWidget {
//   const ReportsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final reports = [
//       {
//         'category': 'Financial Reports',
//         'items': [
//           {
//             'title': 'Annual Financial Report 2023',
//             'date': 'Jan 15, 2024',
//             'type': 'PDF',
//             'size': '2.3 MB'
//           },
//           {
//             'title': 'Q3 Financial Summary',
//             'date': 'Oct 1, 2024',
//             'type': 'PDF',
//             'size': '1.8 MB'
//           },
//           {
//             'title': 'Donation Report 2023',
//             'date': 'Dec 31, 2023',
//             'type': 'PDF',
//             'size': '1.2 MB'
//           },
//         ],
//       },
//       {
//         'category': 'Meetings',
//         'items': [
//           {
//             'title': 'Executive Committee Meeting',
//             'date': 'Oct 5, 2024',
//             'type': 'Meeting',
//             'description':
//                 'Monthly executive committee meeting to discuss upcoming events and budget allocation.',
//             'attendees': 12,
//             'duration': '2 hours',
//           },
//           {
//             'title': 'General Assembly Meeting',
//             'date': 'Sep 15, 2024',
//             'type': 'Meeting',
//             'description':
//                 'Quarterly general assembly meeting with all members to discuss community initiatives.',
//             'attendees': 45,
//             'duration': '3 hours',
//           },
//         ],
//       },
//       {
//         'category': 'Annual Reports',
//         'items': [
//           {
//             'title': 'NAFA Annual Report 2023',
//             'date': 'Jan 1, 2024',
//             'type': 'PDF',
//             'size': '5.2 MB'
//           },
//           {
//             'title': 'Community Impact Report',
//             'date': 'Dec 15, 2023',
//             'type': 'PDF',
//             'size': '3.1 MB'
//           },
//         ],
//       },
//     ];

//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         children: reports.map((category) {
//           return Padding(
//             padding: const EdgeInsets.only(bottom: 24),
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(12),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.1),
//                     blurRadius: 10,
//                     offset: const Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(16),
//                     child: Text(
//                       category['category'] as String,
//                       style: const TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   ...((category['items'] as List).map((item) {
//                     return InkWell(
//                       onTap: () {
//                         if (item['type'] == 'Meeting') {
//                           _showMeetingDetails(context, item);
//                         } else {
//                           // Handle PDF download
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(
//                                 content: Text('Downloading ${item['title']}')),
//                           );
//                         }
//                       },
//                       child: Container(
//                         padding: const EdgeInsets.all(16),
//                         margin: const EdgeInsets.symmetric(
//                             horizontal: 16, vertical: 4),
//                         decoration: BoxDecoration(
//                           color: Colors.grey.shade50,
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Row(
//                           children: [
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     item['title'] as String,
//                                     style: const TextStyle(
//                                       fontWeight: FontWeight.w500,
//                                       fontSize: 14,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 4),
//                                   Text(
//                                     item['date'] as String,
//                                     style: const TextStyle(
//                                       color: Colors.grey,
//                                       fontSize: 12,
//                                     ),
//                                   ),
//                                   if (item['size'] != null)
//                                     Text(
//                                       '${item['type']} • ${item['size']}',
//                                       style: const TextStyle(
//                                         color: Colors.grey,
//                                         fontSize: 12,
//                                       ),
//                                     ),
//                                 ],
//                               ),
//                             ),
//                             Icon(
//                               item['type'] == 'Meeting'
//                                   ? Icons.visibility
//                                   : Icons.download,
//                               color: item['type'] == 'Meeting'
//                                   ? AppColors.primary
//                                   : Colors.grey,
//                             ),
//                             const SizedBox(width: 8),
//                             const Icon(Icons.chevron_right, color: Colors.grey),
//                           ],
//                         ),
//                       ),
//                     );
//                   }).toList()),
//                   const SizedBox(height: 16),
//                 ],
//               ),
//             ),
//           );
//         }).toList(),
//       ),
//     );
//   }

//   void _showMeetingDetails(BuildContext context, Map<String, dynamic> meeting) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) => DraggableScrollableSheet(
//         initialChildSize: 0.7,
//         maxChildSize: 0.9,
//         minChildSize: 0.5,
//         expand: false,
//         builder: (context, scrollController) => SingleChildScrollView(
//           controller: scrollController,
//           padding: const EdgeInsets.all(24),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Center(
//                 child: Container(
//                   width: 40,
//                   height: 4,
//                   decoration: BoxDecoration(
//                     color: Colors.grey.shade300,
//                     borderRadius: BorderRadius.circular(2),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 24),
//               Text(
//                 meeting['title'] as String,
//                 style: const TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 meeting['date'] as String,
//                 style: const TextStyle(
//                   color: Colors.grey,
//                   fontSize: 16,
//                 ),
//               ),
//               const SizedBox(height: 24),
//               Text(
//                 meeting['description'] as String,
//                 style: const TextStyle(
//                   fontSize: 16,
//                   height: 1.5,
//                 ),
//               ),
//               const SizedBox(height: 24),
//               Row(
//                 children: [
//                   Expanded(
//                     child: Container(
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: Colors.blue.shade50,
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Column(
//                         children: [
//                           Text(
//                             '${meeting['attendees']}',
//                             style: const TextStyle(
//                               fontSize: 24,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.blue,
//                             ),
//                           ),
//                           const Text(
//                             'Attendees',
//                             style: TextStyle(
//                               color: Colors.grey,
//                               fontSize: 14,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: Container(
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: Colors.green.shade50,
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Column(
//                         children: [
//                           Text(
//                             meeting['duration'] as String,
//                             style: const TextStyle(
//                               fontSize: 24,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.green,
//                             ),
//                           ),
//                           const Text(
//                             'Duration',
//                             style: TextStyle(
//                               color: Colors.grey,
//                               fontSize: 14,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 24),
//               const Text(
//                 'Meeting Agenda:',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 12),
//               const Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text('• Review of previous meeting minutes'),
//                   SizedBox(height: 4),
//                   Text('• Budget discussion for upcoming events'),
//                   SizedBox(height: 4),
//                   Text('• Volunteer coordination'),
//                   SizedBox(height: 4),
//                   Text('• Community feedback and suggestions'),
//                 ],
//               ),
//               const SizedBox(height: 32),
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton.icon(
//                   onPressed: () {
//                     Navigator.pop(context);
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                           content: Text('Downloading meeting minutes...')),
//                     );
//                   },
//                   icon: const Icon(Icons.download),
//                   label: const Text('Download Meeting Minutes'),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColors.primary,
//                     foregroundColor: Colors.white,
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
