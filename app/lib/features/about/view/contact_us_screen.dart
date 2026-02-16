import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nafausa/app/utils/size_config.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../app/utils/app_colors.dart';
import '../../../shared/widgets/common_pop.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            elevation: 0,
            centerTitle: true,
            systemOverlayStyle: SystemUiOverlayStyle.light,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: AppColors.appBarGradient,
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Contact Us',
                                    style: TextStyle(
                                      fontSize: 24.fs,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Get in touch with NAFA',
                                    style: TextStyle(
                                      fontSize: 12.fs,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            backgroundColor: AppColors.appBarBackgroundColor,
            leading: const CommonPop(),
          ),
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.nepalBlue.withAlpha(10),
                            AppColors.nepalRed.withAlpha(10),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: AppColors.nepalBlue.withAlpha(26),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.nepalBlue.withAlpha(10),
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
                              borderRadius: BorderRadius.circular(40),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.nepalBlue.withAlpha(76),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.mail_outline,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 2.hs),
                          Text(
                            'Email us to know more about NAFA',
                            style: TextStyle(
                              fontSize: 18.fs,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF1F2937),
                              letterSpacing: -0.3,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 1.hs),
                          GestureDetector(
                            onTap: () {
                              HapticFeedback.lightImpact();
                              _launchEmail('executives@nafausa.org');
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 14),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.nepalBlue,
                                    AppColors.nepalBlue.withAlpha(204)
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.nepalBlue.withAlpha(76),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.email_outlined,
                                    size: 20.fs,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    "executives@nafausa.org",
                                    style: TextStyle(
                                      fontSize: 13.fs,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 1.5.hs),
                          Text(
                            'We\'re here to help and answer any questions you might have. We look forward to hearing from you!',
                            style: TextStyle(
                              fontSize: 13.fs,
                              color: const Color(0xFF6B7280),
                              height: 1.6,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 2.hs),
                    // Row(
                    //   children: [
                    //     Container(
                    //       width: 4,
                    //       height: 24,
                    //       decoration: BoxDecoration(
                    //         gradient: AppColors.primaryGradient,
                    //         borderRadius: BorderRadius.circular(2),
                    //       ),
                    //     ),
                    //     const SizedBox(width: 12),
                    //     Text(
                    //       'Contact Information',
                    //       style: TextStyle(
                    //         fontSize: 18.fs,
                    //         fontWeight: FontWeight.bold,
                    //         color: const Color(0xFF1F2937),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // SizedBox(height: 2.hs),
                    // _buildContactCard(
                    //   icon: Icons.help_outline,
                    //   title: 'Questions & Feedback',
                    //   subtitle: 'General inquiries and feedback',
                    //   email: 'info@nafausa.org',
                    //   description:
                    //       'Have questions about NAFA or want to provide feedback? We\'d love to hear from you!',
                    //   primaryColor: AppColors.nepalBlue,
                    // ),
                    // const SizedBox(height: 20),
                    // _buildContactCard(
                    //   icon: Icons.business_center_outlined,
                    //   title: 'Executive Team',
                    //   subtitle: 'Leadership and governance',
                    //   email: 'executives@nafausa.org',
                    //   description:
                    //       'Connect directly with our executive team for official matters and partnerships.',
                    //   primaryColor: AppColors.nepalRed,
                    // ),
                    // SizedBox(height: 4.hs),
                    // Row(
                    //   children: [
                    //     Container(
                    //       width: 4,
                    //       height: 24,
                    //       decoration: BoxDecoration(
                    //         gradient: AppColors.primaryGradient,
                    //         borderRadius: BorderRadius.circular(2),
                    //       ),
                    //     ),
                    //     const SizedBox(width: 12),
                    //     Text(
                    //       'Follow Us',
                    //       style: TextStyle(
                    //         fontSize: 18.fs,
                    //         fontWeight: FontWeight.bold,
                    //         color: const Color(0xFF1F2937),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // SizedBox(height: 2.hs),
                    // Container(
                    //   width: double.infinity,
                    //   padding: const EdgeInsets.all(16),
                    //   decoration: BoxDecoration(
                    //     color: Colors.white,
                    //     borderRadius: BorderRadius.circular(24),
                    //     boxShadow: [
                    //       BoxShadow(
                    //         color: AppColors.nepalBlue.withAlpha(10),
                    //         blurRadius: 20,
                    //         offset: const Offset(0, 8),
                    //         spreadRadius: 0,
                    //       ),
                    //     ],
                    //     border: Border.all(
                    //       color: const Color(0xFFE5E7EB),
                    //       width: 1,
                    //     ),
                    //   ),
                    //   child: Column(
                    //     children: [
                    //       Container(
                    //         width: 70,
                    //         height: 70,
                    //         decoration: BoxDecoration(
                    //           gradient: LinearGradient(
                    //             colors: [
                    //               AppColors.nepalRed.withAlpha(26),
                    //               AppColors.nepalRed.withAlpha(13),
                    //             ],
                    //           ),
                    //           borderRadius: BorderRadius.circular(35),
                    //         ),
                    //         child: Icon(
                    //           Icons.share_outlined,
                    //           size: 32.fs,
                    //           color: AppColors.nepalRed,
                    //         ),
                    //       ),
                    //       SizedBox(height: 2.hs),
                    //       Text(
                    //         'NAFA is also in Social Media',
                    //         style: TextStyle(
                    //           fontSize: 18.fs,
                    //           fontWeight: FontWeight.bold,
                    //           color: const Color(0xFF1F2937),
                    //           letterSpacing: -0.3,
                    //         ),
                    //         textAlign: TextAlign.center,
                    //       ),
                    //       SizedBox(height: 1.hs),
                    //       Text(
                    //         'Do not forget to follow there to catch up with us',
                    //         style: TextStyle(
                    //           fontSize: 12.fs,
                    //           color: const Color(0xFF6B7280),
                    //           height: 1.5,
                    //         ),
                    //         textAlign: TextAlign.center,
                    //       ),
                    //       const SizedBox(height: 32),
                    //       Row(
                    //         children: [
                    //           Expanded(
                    //             child: _buildSocialButton(
                    //               icon: Icons.facebook,
                    //               label: 'Facebook',
                    //               color: const Color(0xFF1877F2),
                    //               onTap: () => _launchURL(
                    //                   'https://www.facebook.com/share/19MF6g1BHQ/?mibextid=wwXIfr'),
                    //             ),
                    //           ),
                    //           const SizedBox(width: 16),
                    //           Expanded(
                    //             child: _buildSocialButton(
                    //               icon: Icons.play_circle_filled,
                    //               label: 'YouTube',
                    //               color: const Color(0xFFFF0000),
                    //               onTap: () => _launchURL(
                    //                   'https://youtube.com/@nepalisandfriendsassociati1586?si=jSdz7iJJcNpTX3Ee'),
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // SizedBox(height: 4.hs),
                    // Container(
                    //   width: double.infinity,
                    //   padding: const EdgeInsets.all(16),
                    //   decoration: BoxDecoration(
                    //     gradient: const LinearGradient(
                    //       begin: Alignment.topLeft,
                    //       end: Alignment.bottomRight,
                    //       colors: [
                    //         Color(0xFFF8FAFC),
                    //         Color(0xFFF1F5F9),
                    //       ],
                    //     ),
                    //     borderRadius: BorderRadius.circular(24),
                    //     border: Border.all(
                    //       color: const Color(0xFFE2E8F0),
                    //       width: 1,
                    //     ),
                    //   ),
                    //   child: Column(
                    //     children: [
                    //       Container(
                    //         width: 70,
                    //         height: 70,
                    //         decoration: BoxDecoration(
                    //           gradient: AppColors.primaryGradient,
                    //           borderRadius: BorderRadius.circular(35),
                    //           boxShadow: [
                    //             BoxShadow(
                    //               color: AppColors.nepalBlue.withAlpha(76),
                    //               blurRadius: 12,
                    //               offset: const Offset(0, 4),
                    //             ),
                    //           ],
                    //         ),
                    //         child: Icon(
                    //           Icons.location_on_outlined,
                    //           size: 32.fs,
                    //           color: Colors.white,
                    //         ),
                    //       ),
                    //       const SizedBox(height: 20),
                    //       Text(
                    //         'NAFA - Arizona, USA',
                    //         style: TextStyle(
                    //           fontSize: 18.fs,
                    //           fontWeight: FontWeight.bold,
                    //           color: const Color(0xFF1F2937),
                    //           letterSpacing: -0.3,
                    //         ),
                    //         textAlign: TextAlign.center,
                    //       ),
                    //       SizedBox(height: 0.8.hs),
                    //       Text(
                    //         'Nepalis And Friends Association',
                    //         style: TextStyle(
                    //           fontSize: 12.fs,
                    //           color: const Color(0xFF6B7280),
                    //           fontWeight: FontWeight.w500,
                    //         ),
                    //         textAlign: TextAlign.center,
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // SizedBox(height: 3.hs),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String email,
    required String description,
    required Color primaryColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withAlpha(20),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
        ],
        border: Border.all(
          color: const Color(0xFFE5E7EB),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      primaryColor.withAlpha(26),
                      primaryColor.withAlpha(10),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: primaryColor.withAlpha(51),
                    width: 1,
                  ),
                ),
                child: Icon(
                  icon,
                  size: 28.fs,
                  color: primaryColor,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14.fs,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1F2937),
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12.fs,
                        color: const Color(0xFF6B7280),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            description,
            style: TextStyle(
              fontSize: 14.fs,
              color: const Color(0xFF4B5563),
              height: 1.6,
            ),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              _launchEmail(email);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryColor, primaryColor.withAlpha(204)],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withAlpha(76),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.email_outlined,
                    size: 20.fs,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    email,
                    style: TextStyle(
                      fontSize: 13.fs,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: color.withAlpha(51),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withAlpha(26),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    color.withAlpha(26),
                    color.withAlpha(13),
                  ],
                ),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Icon(
                icon,
                color: color,
                size: 28.fs,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.fs,
                fontWeight: FontWeight.bold,
                color: color,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _launchEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
