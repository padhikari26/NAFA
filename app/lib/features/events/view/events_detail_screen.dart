import 'dart:io';

import 'package:add_2_calendar_new/add_2_calendar_new.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nafausa/app/utils/constants.dart';
import 'package:nafausa/app/utils/helper.dart';
import 'package:nafausa/app/utils/size_config.dart';
import 'package:nafausa/env.dart';
import 'package:nafausa/features/events/controller/bloc/events_bloc.dart';
import 'package:nafausa/features/events/model/single_event_model.dart';
import 'package:nafausa/shared/widgets/custom_cached_network_image.dart';
import 'package:nafausa/shared/widgets/html_viewer.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../app/utils/app_colors.dart';
import '../../../shared/widgets/common_pop.dart';
import '../../gallery/view/gallery_detail_screen.dart';
import '../../gallery/view/view_document.dart';
import '../model/all_events_model.dart';

class EventDetailScreen extends StatefulWidget {
  final String eventId;
  final String thumbnail;
  final String title;

  const EventDetailScreen({
    super.key,
    required this.eventId,
    required this.thumbnail,
    required this.title,
  });

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen>
    with TickerProviderStateMixin {
  late EventsBloc _eventsBloc;

  @override
  void initState() {
    super.initState();
    _eventsBloc = BlocProvider.of<EventsBloc>(context);
    _eventsBloc.add(FetchEventByIdEvent(widget.eventId));
  }

  @override
  void dispose() {
    _eventsBloc.add(ClearEventDetail());
    super.dispose();
  }

  String _getEventStatus(DateTime eventDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final eventDay = DateTime(eventDate.year, eventDate.month, eventDate.day);

    if (eventDay.isAfter(today) || eventDay.isAtSameMomentAs(today)) {
      return 'upcoming';
    } else {
      return 'past';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: BlocBuilder<EventsBloc, EventsState>(
        builder: (context, state) {
          SingleEventModel event = state.eventDetail ?? SingleEventModel();
          final eventDate = Helper.dateToLocalDateTime(event.date ?? '');
          final status = _getEventStatus(eventDate);
          final isUpcoming = status == 'upcoming';
          return CustomScrollView(
            slivers: [
              // Hero Header
              SliverAppBar(
                expandedHeight: 320.fs,
                floating: false,
                pinned: true,
                backgroundColor: AppColors.appBarBackgroundColor,
                leading: const CommonPop(),
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          gradient: AppColors.primaryGradient,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withAlpha(52),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Get.to(() => FullScreenMediaViewer(
                                galleryTitle: event.title ?? '',
                                medias: [
                                  Media(
                                    sId: event.sId,
                                    path: event.media?.firstOrNull?.path ?? '',
                                    mimetype: 'image/jpeg',
                                    type: 'image',
                                    // Add other necessary fields
                                  )
                                ],
                                initialIndex: 0));
                          },
                          child: CustomCachedImageNetwork(
                            fit: BoxFit.cover,
                            isLoading: state.isEventDetailLoading,
                            imageUrl: () {
                              final mediaList = event.media ?? [];
                              if (mediaList.isEmpty) return '';
                              final firstMedia = mediaList.firstOrNull;
                              if (firstMedia == null) return '';
                              if (firstMedia.type == 'video') {
                                final imageMedia = mediaList.skip(1).firstWhere(
                                      (m) => m.type == 'image',
                                      orElse: () => Media(path: ''),
                                    );
                                if (imageMedia.path.isNotNullOrEmpty) {
                                  return '${AppEnviro.imageUrl}/${imageMedia.path}';
                                } else {
                                  return '';
                                }
                              } else {
                                return '${AppEnviro.imageUrl}/${firstMedia.path}';
                              }
                            }(),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withAlpha(180),
                              ],
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Status Badge
                                    Visibility(
                                      visible: state.eventDetail?.date
                                              .isNotNullOrEmpty ??
                                          false,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: isUpcoming
                                              ? const Color(0xFF10B981)
                                              : const Color(0xFF6B7280),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withAlpha(40),
                                              blurRadius: 8,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Text(
                                          status.toUpperCase(),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10.fs,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Flexible(
                                      child: Text(
                                        widget.title,
                                        style: TextStyle(
                                          fontSize: 21.fs,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white,
                                          shadows: const [
                                            Shadow(
                                              color: Colors.black54,
                                              offset: Offset(0, 2),
                                              blurRadius: 4,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Event Details Content
              Skeletonizer.sliver(
                enabled: state.isEventDetailLoading && event.sId.isNullOrEmpty,
                child: SliverToBoxAdapter(
                  child: Container(
                    width: double.maxFinite,
                    margin: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(10),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Date and Time Section
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: const BoxDecoration(
                            color: Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(24),
                            ),
                            border: Border(
                              bottom: BorderSide(
                                color: Color(0xFFE2E8F0),
                                width: 1,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              // Date Card
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  gradient: AppColors.secondaryGradient,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: AppColors.nepalBlueLight,
                                      blurRadius: 12,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      DateFormat('MMM')
                                          .format(eventDate)
                                          .toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 12.fs,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      eventDate.day.toString(),
                                      style: TextStyle(
                                        fontSize: 26.fs,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                        height: 1,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      eventDate.year.toString(),
                                      style: TextStyle(
                                        fontSize: 14.fs,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              Visibility(
                                visible:
                                    isUpcoming && event.sId.isNotNullOrEmpty,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Add to Calendar',
                                      style: TextStyle(
                                        fontSize: 10.fs,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    GestureDetector(
                                      onTap: () {
                                        addHaptics();
                                        final Event calendarEvent = Event(
                                          title: event.title ?? "",
                                          startDate: eventDate,
                                          endDate: eventDate
                                              .add(const Duration(hours: 4)),
                                          iosParams: IOSParams(
                                            reminder: const Duration(
                                              hours: 4,
                                            ),
                                            url: Platform.isIOS
                                                ? iosAppUrl
                                                : androidAppUrl,
                                          ),
                                          androidParams: const AndroidParams(),
                                        );
                                        Add2Calendar.addEvent2Cal(
                                            calendarEvent);
                                      },
                                      child: Icon(
                                        CupertinoIcons.calendar_badge_plus,
                                        size: 30.fs,
                                        color: AppColors.nepalBlueLight,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppColors.nepalBlueLight
                                          .withAlpha(20),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      Icons.description_rounded,
                                      size: 20.fs,
                                      color: AppColors.nepalBlueLight,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Event Details',
                                    style: TextStyle(
                                      fontSize: 18.fs,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF1F2937),
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 2.hs),

                              // HTML Content
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFAFAFA),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: const Color(0xFFE5E7EB),
                                    width: 1,
                                  ),
                                ),
                                child: HtmlViewerWidget(
                                  data: event.description ?? '',
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Media Section
                        if (event.media != null &&
                            (event.media?.isNotEmpty ?? false))
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: AppColors.nepalBlueLight
                                            .withAlpha(26),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        Icons.photo_library_rounded,
                                        size: 20.fs,
                                        color: AppColors.nepalBlueLight,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      'Media Gallery',
                                      style: TextStyle(
                                        fontSize: 18.fs,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF1F2937),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 1.hs),

                                // Media Grid
                                MediaQuery.removePadding(
                                  context: context,
                                  removeTop: true,
                                  child: GridView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 12,
                                      mainAxisSpacing: 12,
                                      childAspectRatio: 1.2,
                                    ),
                                    itemCount: event.media?.length,
                                    itemBuilder: (context, index) {
                                      final media = event.media?[index];
                                      final isVideo = media?.mimetype
                                              .toString()
                                              .startsWith('video/') ??
                                          false;

                                      return GestureDetector(
                                        onTap: () {
                                          // Handle media view
                                          Get.to(() => FullScreenMediaViewer(
                                              galleryTitle: event.title ?? '',
                                              medias: event.media ?? [],
                                              initialIndex: index));
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFF8FAFC),
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            border: Border.all(
                                              color: const Color(0xFFE2E8F0),
                                              width: 1,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color:
                                                    Colors.black.withAlpha(13),
                                                blurRadius: 8,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Stack(
                                            children: [
                                              // Media Preview
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                child: Container(
                                                  width: double.infinity,
                                                  height: double.infinity,
                                                  color:
                                                      const Color(0xFFE5E7EB),
                                                  child:
                                                      CustomCachedImageNetwork(
                                                    imageUrl:
                                                        '${AppEnviro.imageUrl}/${media?.path}',
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),

                                              // Play Button for Videos
                                              if (isVideo)
                                                Positioned.fill(
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.black
                                                          .withAlpha(76),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16),
                                                    ),
                                                    child: const Center(
                                                      child: Icon(
                                                        Icons
                                                            .play_circle_filled_rounded,
                                                        size: 48,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),

                                              // Media Type Badge
                                              Positioned(
                                                top: 8,
                                                right: 8,
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 8,
                                                      vertical: 4),
                                                  decoration: BoxDecoration(
                                                    color: Colors.black
                                                        .withAlpha(180),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  child: Text(
                                                    isVideo ? 'VIDEO' : 'IMAGE',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 9.fs,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      letterSpacing: 0.5,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),

                        // Documents Section
                        if (event.documents != null &&
                            (event.documents as List).isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: AppColors.nepalBlueLight
                                            .withAlpha(26),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(
                                        Icons.folder_rounded,
                                        size: 20,
                                        color: AppColors.nepalBlueLight,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      'Documents',
                                      style: TextStyle(
                                        fontSize: 18.fs,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF1F2937),
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 1.hs),
                                // Documents List
                                MediaQuery.removePadding(
                                  context: context,
                                  removeTop: true,
                                  child: ListView.separated(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: (event.documents as List).length,
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(height: 12),
                                    itemBuilder: (context, index) {
                                      final document = event.documents![index];
                                      final fileName = document.path
                                          .toString()
                                          .split('/')
                                          .last;
                                      final fileExtension = fileName
                                          .split('.')
                                          .last
                                          .toUpperCase();

                                      return GestureDetector(
                                        onTap: () {
                                          Get.to(() => ViewDocuments(
                                                file: document.path,
                                                name: fileName,
                                                title: 'View Document',
                                              ));
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFF8FAFC),
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            border: Border.all(
                                              color: const Color(0xFFE2E8F0),
                                              width: 1,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color:
                                                    Colors.black.withAlpha(13),
                                                blurRadius: 8,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Row(
                                            children: [
                                              // Document Icon
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(12),
                                                decoration: BoxDecoration(
                                                  color: AppColors
                                                      .nepalBlueLight
                                                      .withAlpha(26),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Icon(
                                                  _getDocumentIcon(
                                                      document.mimetype ?? ""),
                                                  size: 24,
                                                  color:
                                                      AppColors.nepalBlueLight,
                                                ),
                                              ),

                                              const SizedBox(width: 16),

                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      '$fileExtension Document ${index + 1}',
                                                      style: TextStyle(
                                                        fontSize: 12.fs,
                                                        color: const Color(
                                                            0xFF6B7280),
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              // Download Icon
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  color: AppColors
                                                      .nepalBlueLight
                                                      .withAlpha(26),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Icon(
                                                  Icons.download_rounded,
                                                  size: 20.fs,
                                                  color:
                                                      AppColors.nepalBlueLight,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),

                        // Action Buttons
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  IconData _getDocumentIcon(String mimetype) {
    if (mimetype.contains('pdf')) {
      return Icons.picture_as_pdf_rounded;
    } else if (mimetype.contains('word') || mimetype.contains('document')) {
      return Icons.description_rounded;
    } else if (mimetype.contains('excel') || mimetype.contains('spreadsheet')) {
      return Icons.table_chart_rounded;
    } else if (mimetype.contains('powerpoint') ||
        mimetype.contains('presentation')) {
      return Icons.slideshow_rounded;
    } else if (mimetype.contains('text')) {
      return Icons.text_snippet_rounded;
    } else {
      return Icons.insert_drive_file_rounded;
    }
  }
}
