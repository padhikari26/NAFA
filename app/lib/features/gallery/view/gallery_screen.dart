import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nafausa/app/utils/size_config.dart';
import 'package:nafausa/features/gallery/controller/bloc/gallery_bloc.dart';
import 'package:nafausa/features/gallery/model/all_gallery_model.dart';
import 'package:nafausa/shared/widgets/custom_cached_network_image.dart';
import 'package:nafausa/shared/widgets/loading.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../app/utils/app_colors.dart';
import '../../../app/utils/helper.dart';
import '../../../app/utils/pagination_helper.dart';
import '../../../env.dart';
import '../../../shared/widgets/common_pop.dart';
import 'gallery_detail_screen.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({Key? key}) : super(key: key);

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen>
    with TickerProviderStateMixin {
  bool isLoading = true;

  late GalleryBloc _galleryBloc;

  @override
  void initState() {
    super.initState();
    _galleryBloc = BlocProvider.of<GalleryBloc>(context);
    _galleryBloc.add(FetchAllGalleryEvent(
        page: _galleryBloc.state.currentPage,
        isInitial: _galleryBloc.state.galleries.isNullOrEmpty));
  }

  final _refreshController = RefreshController();

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        body: BlocBuilder<GalleryBloc, GalleryState>(
          builder: (context, state) {
            final galleries = state.galleries;
            if (state.paginationStatus == PaginationStatus.success) {
              _refreshController.refreshCompleted();
              _refreshController.loadComplete();
            } else if (state.paginationStatus == PaginationStatus.failure) {
              _refreshController.refreshFailed();
              _refreshController.loadFailed();
            }
            return Processing(
              loading: state.allGalleryLoading && galleries.isEmpty,
              child: SmartRefresher(
                controller: _refreshController,
                enablePullDown: true,
                enablePullUp: !state.hasReachedEnd,
                onRefresh: () {
                  _galleryBloc.add(RefreshGalleryEvent());
                },
                onLoading: () {
                  _galleryBloc
                      .add(FetchAllGalleryEvent(page: (state.currentPage) + 1));
                },
                child: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      expandedHeight: 120.0.fs,
                      floating: false,
                      pinned: true,
                      elevation: 0,
                      leading: const CommonPop(),
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
                                  const SizedBox(height: 20),
                                  Text(
                                    'Gallery',
                                    style: TextStyle(
                                      fontSize: 24.fs,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Explore our community moments',
                                    style: TextStyle(
                                      fontSize: 14.fs,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white
                                          .withAlpha((0.9 * 255).toInt()),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      backgroundColor: AppColors.appBarBackgroundColor,
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: TextFormField(
                            controller: state.searchController,
                            onChanged: (value) {
                              Helper.debouncedSearch(
                                fn: (searchTerm) async {
                                  _galleryBloc.add(const FetchAllGalleryEvent(
                                      page: 1, isInitial: true));
                                },
                                value: value,
                                key: 'gallery_search',
                              );
                            },
                            style: TextStyle(
                              fontSize: 14.fs,
                              color: const Color(0xFF1F2937),
                            ),
                            decoration: InputDecoration(
                              hintText: 'Search gallery...',
                              hintStyle: TextStyle(
                                color: const Color(0xFF6B7280),
                                fontSize: 14.fs,
                              ),
                              prefixIcon: Icon(
                                Icons.search_rounded,
                                size: 22.fs,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 18),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Color(0xFFF8FAFC),
                        ),
                        child: galleries.isEmpty && !state.allGalleryLoading
                            ? _buildEmptyState()
                            : _buildGalleryContent(
                                galleries: galleries, state: state),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient.scale(0.1),
                borderRadius: BorderRadius.circular(60),
              ),
              child: const Icon(
                Icons.photo_library_outlined,
                size: 60,
                color: Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'No galleries available',
              style: TextStyle(
                fontSize: 18.fs,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Check back later for new photo albums\nfrom our community events',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15.fs,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF6B7280),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGalleryContent({
    required List<AllGalleryData> galleries,
    required GalleryState state,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
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
                'Albums',
                style: TextStyle(
                  fontSize: 18.fs,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1F2937),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  Helper.openUrl(
                      'https://drive.google.com/drive/folders/1BTbklcOJODFQIoAfh8nJ-ISMEzTPIMQF?usp=sharing');
                },
                child: Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.googleDrive,
                      size: 16.fs,
                      color: const Color(0xFF4285F4), // Google Drive blue
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'View More',
                      style: TextStyle(
                        fontSize: 12.fs,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: 2.hs,
          ),
          MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 0.85,
              ),
              itemCount: galleries.length,
              itemBuilder: (context, index) {
                return _buildGalleryCard(galleries[index], index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGalleryCard(AllGalleryData gallery, int index) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GalleryDetailScreen(
              title: gallery.title ?? "",
              galleryId: gallery.sId ?? "",
              thumbnail: gallery.medias?.path ?? "",
            ),
          ),
        );
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300 + (index * 100)),
        curve: Curves.easeOutBack,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                color: AppColors.nepalBlue.withAlpha((0.1 * 255).toInt()),
                blurRadius: 20.0,
                offset: const Offset(0, 8.0),
                spreadRadius: 0,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Stack(
              children: [
                Container(
                    width: double.maxFinite,
                    height: double.maxFinite,
                    decoration: const BoxDecoration(
                      gradient: AppColors.primaryGradient,
                    ),
                    child: Stack(
                      children: [
                        gallery.medias?.type == 'video'
                            ? Container(
                                decoration: BoxDecoration(
                                  gradient:
                                      AppColors.primaryGradient.scale(0.5),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.video_library_outlined,
                                    size: 50,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            : CustomCachedImageNetwork(
                                height: double.maxFinite,
                                width: double.maxFinite,
                                fit: BoxFit.cover,
                                imageUrl:
                                    '${AppEnviro.imageUrl}/${gallery.medias?.path}'),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withAlpha((0.7 * 255).toInt()),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          gallery.title ?? "",
                          style: TextStyle(
                            fontSize: 14.fs,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: -0.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 16.0,
                  right: 16.0,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withAlpha((0.9 * 255).toInt()),
                          Colors.white.withAlpha((0.7 * 255).toInt()),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha((0.1 * 255).toInt()),
                          blurRadius: 8.0,
                          offset: const Offset(0, 2.0),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.arrow_forward_ios,
                      size: 18.0,
                      color: AppColors.nepalBlue,
                    ),
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
