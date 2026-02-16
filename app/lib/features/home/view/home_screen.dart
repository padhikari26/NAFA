import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:nafausa/app/utils/size_config.dart';
import 'package:nafausa/features/events/view/events_detail_screen.dart';
import 'package:nafausa/features/home/controller/bloc/home_bloc.dart';
import 'package:nafausa/shared/widgets/button/custom_button.dart';
import 'package:nafausa/shared/widgets/custom_cached_network_image.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../app/utils/app_colors.dart';
import '../../../app/utils/helper.dart';
import '../../../env.dart';
import '../../about/view/contact_us_screen.dart';
import '../../events/view/events_screen.dart';
import '../../gallery/view/gallery_screen.dart';
import '../../notification/view/notification_screen.dart';
import '../../teams/view/teams_screen.dart';
import 'more_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late ScrollController _scrollController;
  Color _nafaTextColor = Colors.white;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final double scrollOffset = _scrollController.offset;
    final Color newColor = scrollOffset > 20.hs ? Colors.black : Colors.white;

    if (_nafaTextColor != newColor) {
      setState(() {
        _nafaTextColor = newColor;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.primaryGradient,
        ),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              expandedHeight: 260,
              floating: false,
              pinned: true,
              backgroundColor: Colors.white,
              elevation: 0,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.to(() => const MoreScreen());
                    },
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: const BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              'N',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.fs,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'NAFA',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _nafaTextColor,
                            fontSize: 18.fs,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => const NotificationScreen());
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.textWhite.withAlpha(180),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.notifications_outlined,
                          color: AppColors.nepalBlue,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: _buildHeroSection(),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 3.hs),
                    _buildQuickMenu(),
                    SizedBox(height: 1.hs),
                    _buildFeaturedEvent(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 1.hs),
              Text(
                'Welcome to NAFA',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.fs,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 0.5.hs),
              Text(
                'Nepalis And Friends Association, Arizona',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13.fs,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                '(NAFA) is a tax-exempt organization under section 501(c)(3) of the Internal Revenue Service (IRS) code.',
                style: TextStyle(
                  color: Colors.white.withAlpha(220),
                  fontSize: 12.fs,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickMenu() {
    final quickMenuItems = [
      _QuickMenuItem(Icons.event, 'Events', const Color(0xFF3B82F6), onTap: () {
        Get.to(() => const EventsScreen());
      }),
      _QuickMenuItem(Icons.photo_library, 'Gallery', const Color(0xFF8B5CF6),
          onTap: () {
        Get.to(() => const GalleryScreen());
      }),
      _QuickMenuItem(Icons.groups, 'Teams', const Color(0xFFF97316), onTap: () {
        Get.to(() => const TeamsScreen());
      }),
      _QuickMenuItem(Icons.person_add, 'Membership', const Color(0xFFEF4444),
          onTap: () {
        Helper.openUrl('https://www.nafausa.org/membership');
      }),
      _QuickMenuItem(Icons.favorite, 'Donate', const Color(0xFFEC4899),
          onTap: () {
        Helper.openUrl('https://www.nafausa.org/donate');
      }),
      _QuickMenuItem(Icons.location_on, 'Contact', const Color(0xFF14B8A6),
          onTap: () {
        Get.to(() => const ContactUsScreen());
      }),
      _QuickMenuItem(
          FontAwesomeIcons.facebook, 'Facebook', const Color(0xFF14B8A6),
          onTap: () {
        Helper.openUrl(
            'https://www.facebook.com/share/19MF6g1BHQ/?mibextid=wwXIfr');
      }),
      _QuickMenuItem(
          FontAwesomeIcons.youtube, 'Youtube', const Color(0xFFEF4444),
          onTap: () {
        Helper.openUrl(
            'https://youtube.com/@nepalisandfriendsassociati1586?si=jSdz7iJJcNpTX3Ee');
      }),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Access',
            style: TextStyle(
              fontSize: 22.fs,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF1F2937),
              letterSpacing: -0.8,
            ),
          ),
          SizedBox(height: 1.hs),
          Text(
            'Navigate to key sections of our community',
            style: TextStyle(
              fontSize: 13.fs,
              color: const Color(0xFF6B7280),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 2.hs),
          MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.95.fs,
              ),
              itemCount: quickMenuItems.length,
              itemBuilder: (context, index) {
                final item = quickMenuItems[index];
                return _buildProfessionalQuickMenuItem(item, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfessionalQuickMenuItem(_QuickMenuItem item, int index) {
    final gradients = [
      [AppColors.nepalBlue.withAlpha(180), AppColors.nepalBlue.withAlpha(220)],
      [AppColors.nepalRed.withAlpha(180), AppColors.nepalRed.withAlpha(220)],
      [
        const Color(0xFF8B5CF6).withAlpha(180),
        const Color(0xFF7C3AED).withAlpha(220)
      ],
      [
        const Color(0xFF059669).withAlpha(180),
        const Color(0xFF047857).withAlpha(220)
      ],
    ];
    final gradientIndex = index % gradients.length;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          item.onTap?.call();
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradients[gradientIndex],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 40.fs,
                  height: 40.fs,
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(40),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    item.icon,
                    color: Colors.white,
                    size: 24.fs,
                  ),
                ),
                SizedBox(height: 0.8.hs),
                FittedBox(
                  child: Text(
                    item.label,
                    style: TextStyle(
                      fontSize: 11.fs,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedEvent() {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final event = state.featuredEventModel?.data;
        final hasEvent = event?.sId.isNotNullOrEmpty ?? false;

        return Skeletonizer(
          enabled: state.isLoading,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1F2937).withAlpha(10),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Featured Event',
                        style: TextStyle(
                          fontSize: 22.fs,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF1F2937),
                          letterSpacing: -0.5,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              hasEvent
                                  ? AppColors.nepalRed
                                  : const Color(0xFF6B7280),
                              hasEvent
                                  ? AppColors.nepalRed
                                      .withAlpha((0.8 * 255).toInt())
                                  : const Color(0xFF9CA3AF),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          hasEvent ? 'Upcoming' : 'Coming Soon',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.fs,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.5.hs),
                  if (!state.isLoading && hasEvent)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Container(
                                width: double.infinity,
                                height: 160.fs,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      AppColors.nepalBlue
                                          .withAlpha((0.1 * 255).toInt()),
                                      AppColors.nepalRed
                                          .withAlpha((0.1 * 255).toInt()),
                                    ],
                                  ),
                                ),
                                child: CustomCachedImageNetwork(
                                    fit: BoxFit.cover,
                                    imageUrl:
                                        "${AppEnviro.imageUrl}/${event?.media?.firstOrNull?.path ?? ""}")),
                            Positioned(
                              top: 12,
                              right: 12,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withAlpha(25),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  // DateFormatter.formatStringDate(event?.date ?? ""),
                                  Helper.dateToLocalTime(
                                    event?.date ?? "",
                                  ),
                                  style: TextStyle(
                                    fontSize: 11.fs,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF1F2937),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 1.hs),
                        Text(
                          event?.title ?? "",
                          style: TextStyle(
                            fontSize: 18.fs,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF1F2937),
                            letterSpacing: -0.3,
                          ),
                        ),
                        SizedBox(height: 1.hs),
                        CustomButton.filled(
                            width: double.maxFinite,
                            text: "View Details",
                            onPressed: () {
                              Get.to(() => EventDetailScreen(
                                  eventId: event?.sId ?? "",
                                  title: event?.title ?? "",
                                  thumbnail:
                                      event?.media?.firstOrNull?.path ?? ""));
                            }),
                      ],
                    )
                  else if (!state.isLoading && !hasEvent)
                    Column(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 160.fs,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFFF3F4F6),
                                Color(0xFFE5E7EB),
                              ],
                            ),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.event_note,
                                  size: 48.fs,
                                  color: const Color(0xFF9CA3AF),
                                ),
                                SizedBox(height: 1.hs),
                                Text(
                                  'No Featured Event',
                                  style: TextStyle(
                                    fontSize: 16.fs,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF6B7280),
                                  ),
                                ),
                                Text(
                                  'Check back soon for updates',
                                  style: TextStyle(
                                    fontSize: 12.fs,
                                    color: const Color(0xFF9CA3AF),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 1.hs),
                        CustomButton.filled(
                            width: double.maxFinite,
                            text: "View All Events",
                            onPressed: () {
                              Get.to(() => const EventsScreen());
                            }),
                      ],
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _QuickMenuItem {
  final IconData icon;
  final String label;
  final Color color;
  final Function()? onTap;

  _QuickMenuItem(this.icon, this.label, this.color, {this.onTap});
}
