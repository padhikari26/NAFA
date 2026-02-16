import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nafausa/app/utils/size_config.dart';
import 'package:nafausa/features/home/controller/bloc/home_bloc.dart';
import 'auth/controllers/bloc/auth_bloc.dart';
import 'home/view/home_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late AuthBloc _authBloc;
  late HomeBloc _homeBloc;
  @override
  void initState() {
    _authBloc = BlocProvider.of<AuthBloc>(context);
    _authBloc.add(const FetchProfileEvent());
    _homeBloc = BlocProvider.of<HomeBloc>(context);
    _homeBloc.add(FetchFeaturedEvent());
    _homeBloc.add(FetchPopUpEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: const HomeScreen(),
      bottomNavigationBar: SafeArea(
        bottom: true,
        child: Container(
          width: double.maxFinite,
          color: Colors.white,
          padding: EdgeInsets.only(top: 6, left: 10.ws, right: 10.ws),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'Initiated by 2025-2026 Executive Team',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.fs,
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget _buildDrawer() {
  //   return Drawer(
  //     child: Column(
  //       children: [
  //         Container(
  //           height: 200,
  //           decoration: const BoxDecoration(
  //             gradient: AppColors.primaryGradient,
  //           ),
  //           child: SafeArea(
  //             child: Padding(
  //               padding: const EdgeInsets.all(16.0),
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Row(
  //                     children: [
  //                       Container(
  //                         width: 40,
  //                         height: 40,
  //                         decoration: BoxDecoration(
  //                           color: Colors.white,
  //                           borderRadius: BorderRadius.circular(20),
  //                         ),
  //                         child: const Center(
  //                           child: Text(
  //                             'NAFA',
  //                             style: TextStyle(
  //                               fontWeight: FontWeight.bold,
  //                               fontSize: 12,
  //                               color: AppColors.nepalRed,
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                       const SizedBox(width: 12),
  //                       const Column(
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           Text(
  //                             'NAFA',
  //                             style: TextStyle(
  //                               color: Colors.white,
  //                               fontSize: 18,
  //                               fontWeight: FontWeight.bold,
  //                             ),
  //                           ),
  //                           Text(
  //                             'Arizona',
  //                             style: TextStyle(
  //                               color: Colors.white70,
  //                               fontSize: 12,
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ],
  //                   ),
  //                   const Spacer(),
  //                   if (_isLoggedIn)
  //                     Container(
  //                       padding: const EdgeInsets.all(12),
  //                       decoration: BoxDecoration(
  //                         color: Colors.white.withOpacity(0.2),
  //                         borderRadius: BorderRadius.circular(8),
  //                       ),
  //                       child: const Row(
  //                         children: [
  //                           CircleAvatar(
  //                             radius: 20,
  //                             child: Text('JD'),
  //                           ),
  //                           SizedBox(width: 12),
  //                           Column(
  //                             crossAxisAlignment: CrossAxisAlignment.start,
  //                             children: [
  //                               Text(
  //                                 'John Doe',
  //                                 style: TextStyle(
  //                                   color: Colors.white,
  //                                   fontWeight: FontWeight.bold,
  //                                 ),
  //                               ),
  //                               Text(
  //                                 'NAFA-2020-001',
  //                                 style: TextStyle(
  //                                   color: Colors.white70,
  //                                   fontSize: 12,
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //         Expanded(
  //           child: ListView(
  //             padding: EdgeInsets.zero,
  //             children: [
  //               _buildDrawerItem(
  //                   Icons.home, 'Home', () => _navigateToScreen(0)),
  //               _buildDrawerItem(
  //                   Icons.event, 'Events', () => _navigateToScreen(1)),
  //               _buildDrawerItem(
  //                   Icons.people, 'About', () => _navigateToScreen(2)),
  //               _buildDrawerItem(
  //                   Icons.description, 'Reports', () => _navigateToScreen(3)),
  //               _buildDrawerItem(Icons.favorite, 'Our Works', () {
  //                 Navigator.pop(context);
  //                 Navigator.push(
  //                   context,
  //                   MaterialPageRoute(
  //                       builder: (context) => const WorksScreen()),
  //                 );
  //               }),
  //               _buildDrawerItem(Icons.photo_library, 'Gallery', () {
  //                 Navigator.pop(context);
  //                 Navigator.push(
  //                   context,
  //                   MaterialPageRoute(
  //                       builder: (context) => const GalleryScreen()),
  //                 );
  //               }),
  //               _buildDrawerItem(Icons.card_membership, 'Membership', () {
  //                 Navigator.pop(context);
  //                 Navigator.push(
  //                   context,
  //                   MaterialPageRoute(
  //                       builder: (context) => const MembershipScreen()),
  //                 );
  //               }),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
