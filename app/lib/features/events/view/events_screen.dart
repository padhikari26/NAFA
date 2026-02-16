import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nafausa/app/utils/app_colors.dart';
import 'package:nafausa/app/utils/helper.dart';
import 'package:nafausa/app/utils/size_config.dart';
import 'package:nafausa/features/events/controller/bloc/events_bloc.dart';
import 'package:nafausa/shared/widgets/common_pop.dart';
import 'package:nafausa/shared/widgets/custom_cached_network_image.dart';
import 'package:nafausa/shared/widgets/loading.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../app/utils/pagination_helper.dart';
import '../../../env.dart';
import '../model/all_events_model.dart';
import 'events_detail_screen.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();

  late EventsBloc eventsBloc;

  @override
  void initState() {
    super.initState();
    eventsBloc = BlocProvider.of<EventsBloc>(context);
    eventsBloc.add(FetchEventsEvent(
        page: eventsBloc.state.currentPage,
        isInitial: eventsBloc.state.allEventModel?.data.isNullOrEmpty ?? true));
  }

  final _refreshController = RefreshController(initialRefresh: false);

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _getEventStatus(DateTime eventDate) {
    final now = DateTime.now();
    if (eventDate.isAfter(now) || eventDate.isAtSameMomentAs(now)) {
      return 'upcoming';
    } else {
      return 'past';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF1F5F9),
        body: BlocListener<EventsBloc, EventsState>(
          listener: (context, state) {
            if (state.paginationStatus == PaginationStatus.success) {
              _refreshController.refreshCompleted();
              _refreshController.loadComplete();
            } else if (state.paginationStatus == PaginationStatus.failure) {
              _refreshController.refreshFailed();
              _refreshController.loadFailed();
            }
          },
          child: BlocBuilder<EventsBloc, EventsState>(
            builder: (context, state) {
              final eventsList = state.allEventModel?.data ?? [];
              return Processing(
                loading: state.isEventLoading && eventsList.isEmpty,
                child: SmartRefresher(
                  controller: _refreshController,
                  enablePullDown: true,
                  enablePullUp: !state.hasReachedEnd,
                  onRefresh: () {
                    eventsBloc.add(RefreshEventsEvent());
                  },
                  onLoading: () {
                    eventsBloc
                        .add(FetchEventsEvent(page: (state.currentPage) + 1));
                  },
                  child: CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        expandedHeight: 120,
                        floating: false,
                        pinned: true,
                        backgroundColor: AppColors.appBarBackgroundColor,
                        leading: const CommonPop(),
                        flexibleSpace: FlexibleSpaceBar(
                          title: Text(
                            'Explore Community Events',
                            style: TextStyle(
                              fontSize: 15.fs,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: -0.5,
                            ),
                          ),
                          background: Container(
                            decoration: const BoxDecoration(
                              gradient: AppColors.appBarGradient,
                            ),
                          ),
                        ),
                      ),

                      SliverToBoxAdapter(
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
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
                              // Search Bar
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF8FAFC),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                      color: const Color(0xFFE2E8F0)),
                                ),
                                child: TextFormField(
                                  controller: state.searchController,
                                  onChanged: (value) {
                                    Helper.debouncedSearch(
                                      fn: (searchTerm) async {
                                        eventsBloc.add(const FetchEventsEvent(
                                            page: 1, isInitial: true));
                                      },
                                      value: value,
                                      key: 'event_search',
                                    );
                                  },
                                  style: TextStyle(
                                    fontSize: 14.fs,
                                    color: const Color(0xFF1F2937),
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Search events...',
                                    hintStyle: TextStyle(
                                      color: const Color(0xFF6B7280),
                                      fontSize: 14.fs,
                                    ),
                                    prefixIcon: const Icon(
                                      Icons.search_rounded,
                                      size: 24,
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 18),
                                  ),
                                ),
                              ),

                              SizedBox(height: 2.hs),

                              // Filter Section
                              Row(
                                children: [
                                  Text(
                                    'Filter by:',
                                    style: TextStyle(
                                      fontSize: 13.fs,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF374151),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: SizedBox(
                                      height: 44,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: state.filters.length,
                                        itemBuilder: (context, index) {
                                          final title = state.filters[index]
                                              .toString()
                                              .split('.')
                                              .last
                                              .capitalizeFirst;
                                          return Padding(
                                            padding: EdgeInsets.only(
                                                right: index <
                                                        state.filters.length - 1
                                                    ? 6
                                                    : 0),
                                            child: AnimatedContainer(
                                              duration: const Duration(
                                                  milliseconds: 200),
                                              child: Material(
                                                color: Colors.transparent,
                                                child: InkWell(
                                                  onTap: () {
                                                    eventsBloc.add(
                                                        ChangeFilterTypeEvent(
                                                      state.filters[index],
                                                    ));
                                                  },
                                                  borderRadius:
                                                      BorderRadius.circular(22),
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 20,
                                                        vertical: 10),
                                                    decoration: BoxDecoration(
                                                      color: state.filters[
                                                                  index] ==
                                                              state
                                                                  .currentFilter
                                                          ? AppColors.nepalRed
                                                          : Colors.transparent,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              22),
                                                      border: Border.all(
                                                        color: state.filters[
                                                                    index] ==
                                                                state
                                                                    .currentFilter
                                                            ? AppColors.nepalRed
                                                            : const Color(
                                                                0xFFE2E8F0),
                                                        width: 2,
                                                      ),
                                                    ),
                                                    child: Text(
                                                      title ?? "",
                                                      style: TextStyle(
                                                        color: state.filters[
                                                                    index] ==
                                                                state
                                                                    .currentFilter
                                                            ? Colors.white
                                                            : const Color(
                                                                0xFF6B7280),
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 12.fs,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Events List
                      SliverPadding(
                          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final event = eventsList[index];
                                return eventsList.isEmpty &&
                                        !state.isEventLoading
                                    ? SliverFillRemaining(
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(24),
                                                decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xFFF3F4F6),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: const Icon(
                                                  Icons.event_busy_rounded,
                                                  size: 64,
                                                  color: Color(0xFF9CA3AF),
                                                ),
                                              ),
                                              const SizedBox(height: 24),
                                              Text(
                                                'No events found',
                                                style: TextStyle(
                                                  fontSize: 18.fs,
                                                  fontWeight: FontWeight.w700,
                                                  color:
                                                      const Color(0xFF374151),
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                'Check back later!',
                                                style: TextStyle(
                                                  fontSize: 15.fs,
                                                  color:
                                                      const Color(0xFF6B7280),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : _buildEventCard(event, index);
                              },
                              childCount: eventsList.length,
                            ),
                          ))
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildEventCard(AllEventData event, int index) {
    final eventDate = DateTime.parse(event.date ?? "");
    final status = _getEventStatus(eventDate);
    final isUpcoming = status == 'upcoming';

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EventDetailScreen(
                    title: event.title ?? "",
                    eventId: event.sId!,
                    thumbnail: event.media?.path ?? ''),
              ),
            );
          },
          borderRadius: BorderRadius.circular(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event Header with Image
              Container(
                height: 200.fs,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  gradient: AppColors.primaryGradient,
                ),
                child: Stack(
                  children: [
                    // Background Pattern
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(24)),
                          color: Colors.black.withAlpha(20),
                        ),
                        child: CustomCachedImageNetwork(
                          fit: BoxFit.cover,
                          imageUrl:
                              "${AppEnviro.imageUrl}/${event.media?.path}",
                        ),
                      ),
                    ),

                    // Status Badge
                    Positioned(
                      top: 20,
                      right: 20,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isUpcoming
                              ? const Color(0xFF10B981)
                              : const Color(0xFF6B7280),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(51),
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

                    Positioned(
                      top: 20,
                      left: 20,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(25),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              DateFormat('MMM').format(eventDate).toUpperCase(),
                              style: TextStyle(
                                fontSize: 10.fs,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              eventDate.day.toString(),
                              style: TextStyle(
                                fontSize: 16.fs,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF1F2937),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title ?? "",
                      style: TextStyle(
                        fontSize: 17.fs,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1F2937),
                      ),
                    ),
                    SizedBox(height: 2.hs),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: 20.fs,
                            color: AppColors.nepalBlue,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            DateFormat('EEE, MMM dd, yyyy').format(eventDate),
                            style: TextStyle(
                              fontSize: 12.fs,
                              color: const Color(0xFF374151),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
