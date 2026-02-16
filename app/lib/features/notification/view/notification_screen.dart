import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:nafausa/app/utils/size_config.dart';
import 'package:nafausa/features/notification/controller/bloc/notification_bloc.dart';
import 'package:nafausa/features/notification/model/notification_model.dart';
import 'package:nafausa/shared/widgets/loading.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../app/utils/app_colors.dart';
import '../../../app/utils/pagination_helper.dart';
import '../../../shared/widgets/common_pop.dart';
import '../../events/view/events_detail_screen.dart';
import '../../gallery/view/gallery_detail_screen.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with TickerProviderStateMixin {
  late NotificationBloc _notificationBloc;
  final _refreshController = RefreshController();

  @override
  void initState() {
    super.initState();
    _notificationBloc = BlocProvider.of<NotificationBloc>(context);
    _notificationBloc.add(
        FetchAllNotificationEvent(page: _notificationBloc.state.currentPage));
  }

  String _getTimeAgo(String dateString) {
    final DateTime date = DateTime.parse(dateString);
    final DateTime now = DateTime.now();
    final Duration difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'event':
        return Icons.event;
      case 'announcement':
        return Icons.campaign;
      case 'reminder':
        return Icons.notifications;
      default:
        return Icons.notifications;
    }
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'event':
        return AppColors.nepalBlue;
      case 'announcement':
        return AppColors.nepalRed;
      case 'reminder':
        return Colors.orange;
      default:
        return AppColors.nepalBlue;
    }
  }

  void _onNotificationTap(NotificationData notification) {
    // Navigate based on notification type
    final String type = notification.data?.type ?? 'general';
    final String id = notification.data?.id ?? '';

    if (type == 'event') {
      Get.to(() => EventDetailScreen(
          title: notification.data?.title ?? '',
          eventId: id,
          thumbnail: notification.data?.thumbnail ?? ''));
    } else if (type == 'gallery') {
      Get.to(() => GalleryDetailScreen(
          title: notification.data?.title ?? '',
          galleryId: id,
          thumbnail: notification.data?.thumbnail ?? ''));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          final notifications = state.notifications;
          if (state.paginationStatus == PaginationStatus.success) {
            _refreshController.refreshCompleted();
            _refreshController.loadComplete();
          } else if (state.paginationStatus == PaginationStatus.failure) {
            _refreshController.refreshFailed();
            _refreshController.loadFailed();
          }
          return Processing(
            loading: state.isLoading && notifications.isEmpty,
            child: SmartRefresher(
              controller: _refreshController,
              enablePullDown: true,
              enablePullUp: !state.hasReachedEnd,
              onRefresh: () {
                _notificationBloc.add(const RefreshNotificationEvent());
              },
              onLoading: () {
                _notificationBloc.add(FetchAllNotificationEvent(
                    page: _notificationBloc.state.currentPage + 1));
              },
              child: CustomScrollView(
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 24.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Notifications',
                                            style: TextStyle(
                                              fontSize: 24.fs,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              letterSpacing: -0.5,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Stay updated with NAFA',
                                            style: TextStyle(
                                              fontSize: 13.fs,
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
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: notifications.isEmpty && !state.isLoading
                          ? _buildEmptyState()
                          : _buildNotificationsList(
                              notifications: notifications),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
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
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                BoxShadow(
                  color: AppColors.nepalBlue.withAlpha(76),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              Icons.notifications_none,
              size: 45.fs,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No Notifications',
            style: TextStyle(
              fontSize: 18.fs,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1F2937),
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'You\'re all caught up! Check back later for updates from NAFA community.',
            style: TextStyle(
              fontSize: 14.fs,
              color: const Color(0xFF6B7280),
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList({
    required List<NotificationData> notifications,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 24,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Recent Notifications',
              style: TextStyle(
                fontSize: 18.fs,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1F2937),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        ...notifications
            .map((notification) => _buildNotificationCard(notification))
            .toList(),
      ],
    );
  }

  Widget _buildNotificationCard(NotificationData notification) {
    final String type = notification.data?.type ?? 'general';
    final Color typeColor = _getNotificationColor(type);

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: typeColor.withAlpha(20),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
        ],
        border: Border.all(
          color: typeColor.withAlpha(51),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            _onNotificationTap(notification);
          },
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            typeColor.withAlpha(26),
                            typeColor.withAlpha(10),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: typeColor.withAlpha(51),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        _getNotificationIcon(type),
                        size: 24.fs,
                        color: typeColor,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  notification.title?.capitalizeFirst ?? "",
                                  style: TextStyle(
                                    fontSize: 16.fs,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF1F2937),
                                    letterSpacing: -0.3,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.access_time,
                                size: 16,
                                color: Color(0xFF6B7280),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                _getTimeAgo(notification.createdAt ?? ""),
                                style: TextStyle(
                                  fontSize: 12.fs,
                                  color: const Color(0xFF6B7280),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      typeColor.withAlpha(26),
                                      typeColor.withAlpha(13),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  type.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 12.fs,
                                    fontWeight: FontWeight.bold,
                                    color: typeColor,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  notification.body ?? "",
                  style: TextStyle(
                    fontSize: 14.fs,
                    color: const Color(0xFF4B5563),
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
