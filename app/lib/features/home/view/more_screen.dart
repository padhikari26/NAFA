import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:nafausa/app/utils/helper.dart';
import 'package:nafausa/app/utils/size_config.dart';
import 'package:nafausa/core/controller/bloc/global/global_bloc.dart';
import 'package:nafausa/features/auth/view/auth_screen.dart';
import 'package:nafausa/shared/widgets/button/custom_button.dart';
import '../../../app/utils/app_colors.dart';
import '../../../shared/widgets/common_pop.dart';
import '../../about/view/privacy_screen.dart';
import '../../about/view/terms_screen.dart';
import 'settings_screen.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: BlocBuilder<GlobalBloc, GlobalState>(
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: false,
                pinned: true,
                elevation: 0,
                backgroundColor: Colors.transparent,
                leading: const CommonPop(),
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: AppColors.appBarGradient,
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "More",
                              style: TextStyle(
                                fontSize: 19.fs,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    SizedBox(height: 2.hs),
                    globalBloc.state.isLoggedIn
                        ? _buildProfileSection(context)
                        : _buildAuthSection(context),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildMenuGroup([]),
                          _buildSectionHeader('Legal & Support'),
                          SizedBox(height: 1.hs),
                          _buildMenuGroup([
                            _MenuItemData(
                              icon: Icons.privacy_tip_outlined,
                              title: 'Privacy Policy',
                              subtitle: 'How we protect your data',
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const PrivacyPolicyScreen()),
                              ),
                            ),
                            _MenuItemData(
                              icon: Icons.description_outlined,
                              title: 'Terms & Conditions',
                              subtitle: 'Our terms of service',
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const TermsConditionsScreen()),
                              ),
                            ),
                            // _MenuItemData(
                            //   icon: Icons.contact_support_outlined,
                            //   title: 'Contact Us',
                            //   subtitle: 'Get in touch with us',
                            //   onTap: () {
                            //     ScaffoldMessenger.of(context).showSnackBar(
                            //       const SnackBar(
                            //         content:
                            //             Text('Contact Us feature coming soon!'),
                            //         behavior: SnackBarBehavior.floating,
                            //       ),
                            //     );
                            //   },
                            // ),
                            // _MenuItemData(
                            //   icon: Icons.info_outline,
                            //   title: 'About App',
                            //   subtitle: 'Version info and credits',
                            //   onTap: () {
                            //     Get.to(() => const UnderConstructionPage());
                            //   },
                            // ),
                          ]),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context) {
    return BlocBuilder<GlobalBloc, GlobalState>(
      builder: (context, state) {
        final user = globalBloc.state.user;
        return Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.grey[50]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(13),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.nepalBlue.withAlpha(71),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      user?.name?.isNotNullOrEmpty ?? false
                          ? user!.name![0].toUpperCase()
                          : 'NA',
                      style: TextStyle(
                        fontSize: 24.fs,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.name?.capitalize ?? 'User',
                        style: TextStyle(
                          fontSize: 18.fs,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        user?.phone ?? 'No phone number',
                        style: TextStyle(
                          fontSize: 13.fs,
                          color: const Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAuthSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.grey[50]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(13),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.person_outline,
                size: 40,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Join Our Community',
              style: TextStyle(
                fontSize: 16.fs,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Connect with fellow Nepalis and friends around the world',
              style: TextStyle(
                fontSize: 12.fs,
                color: const Color(0xFF6B7280),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.hs),
            CustomButton(
              width: double.maxFinite,
              onPressed: () {
                Get.to(() => const AuthScreen());
              },
              borderColor: AppColors.nepalRed,
              icon: Icons.person_add,
              iconColor: AppColors.nepalRed,
              text: 'Login',
              textColor: AppColors.nepalRed,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16.fs,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF1F2937),
        ),
      ),
    );
  }

  Widget _buildMenuGroup(List<_MenuItemData> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isLast = index == items.length - 1;

          return Column(
            children: [
              _buildEnhancedMenuItem(item),
              if (!isLast)
                Divider(
                  height: 1,
                  indent: 72,
                  endIndent: 20,
                  color: Colors.grey[100],
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEnhancedMenuItem(_MenuItemData item) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: item.onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: item.isDestructive
                      ? LinearGradient(
                          colors: [Colors.red[100]!, Colors.red[50]!],
                        )
                      : LinearGradient(
                          colors: [
                            AppColors.nepalBlue.withAlpha(26),
                            AppColors.nepalBlue.withAlpha(5),
                          ],
                        ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  item.icon,
                  color: item.isDestructive
                      ? Colors.red[600]
                      : AppColors.nepalBlue,
                  size: 22.fs,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: TextStyle(
                        fontSize: 14.fs,
                        fontWeight: FontWeight.w600,
                        color: item.isDestructive
                            ? Colors.red[600]
                            : const Color(0xFF1F2937),
                      ),
                    ),
                    if (item.subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        item.subtitle!,
                        style: TextStyle(
                          fontSize: 12.fs,
                          color: const Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: Color(0xFF9CA3AF),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

//   Widget _buildSettingsButton(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 4),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [
//             Colors.grey.shade200.withAlpha(100),
//             Colors.grey.shade100.withAlpha(50)
//           ],
//         ),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(
//           color: Colors.grey.withAlpha(51),
//           width: 1,
//         ),
//       ),
//       child: _buildEnhancedMenuItem(
//         _MenuItemData(
//           icon: Icons.settings,
//           title: 'Settings',
//           subtitle: 'Manage your account settings',
//           isDestructive: false,
//           onTap: () {
//             Get.to(() => const SettingsScreen());
//           },
//         ),
//       ),
//     );
//   }
}

class _MenuItemData {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final bool isDestructive;

  _MenuItemData({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.isDestructive = false,
  });
}
