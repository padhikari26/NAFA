import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nafausa/app/utils/helper.dart';
import 'package:nafausa/app/utils/size_config.dart';
import 'package:nafausa/features/events/model/all_events_model.dart';
import 'package:nafausa/features/gallery/controller/bloc/gallery_bloc.dart';
import 'package:nafausa/features/gallery/model/gallery_detail_model.dart';
import 'package:nafausa/shared/widgets/custom_cached_network_image.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../app/utils/app_colors.dart';
import '../../../env.dart';
import '../../../shared/widgets/common_pop.dart';
import 'view_video.dart';

class GalleryDetailScreen extends StatefulWidget {
  final String title;
  final String galleryId;
  final String thumbnail;

  const GalleryDetailScreen(
      {Key? key,
      required this.title,
      required this.galleryId,
      required this.thumbnail})
      : super(key: key);

  @override
  State<GalleryDetailScreen> createState() => _GalleryDetailScreenState();
}

class _GalleryDetailScreenState extends State<GalleryDetailScreen>
    with TickerProviderStateMixin {
  late GalleryBloc _galleryBloc;

  @override
  void initState() {
    super.initState();
    _galleryBloc = BlocProvider.of<GalleryBloc>(context);
    _galleryBloc.add(FetchGalleryDetailEvent(widget.galleryId));
  }

  @override
  void dispose() {
    _galleryBloc.add(ClearGalleryDetailEvent());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: BlocBuilder<GalleryBloc, GalleryState>(
        builder: (context, state) {
          final galleryDetail = state.galleryDetail;
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 200.0,
                floating: false,
                pinned: true,
                elevation: 0,
                backgroundColor: AppColors.appBarBackgroundColor,
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const SizedBox(height: 20),
                            Text(
                              widget.title,
                              style: TextStyle(
                                fontSize: 21.fs,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Skeletonizer(
                              enabled: state.isGalleryDetailLoading,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white
                                      .withAlpha((0.2 * 255).toInt()),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.white
                                        .withAlpha((0.3 * 255).toInt()),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.photo_library_outlined,
                                      size: 18.0.fs,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 8.0),
                                    Text(
                                      '${galleryDetail?.medias?.length ?? 0} ${galleryDetail?.medias?.length == 1 ? 'photo' : 'photos'}',
                                      style: TextStyle(
                                        fontSize: 13.fs,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    const Icon(
                                      Icons.calendar_today_outlined,
                                      size: 16.0,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 6.0),
                                    Text(
                                      Helper.dateToLocalTime(
                                        galleryDetail?.createdAt ?? '',
                                      ),
                                      style: TextStyle(
                                        fontSize: 12.fs,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                leading: const CommonPop(),
              ),
              Skeletonizer.sliver(
                enabled: state.isGalleryDetailLoading &&
                    (galleryDetail?.medias?.isEmpty ?? true),
                child: SliverToBoxAdapter(
                  child: galleryDetail?.medias?.isEmpty ?? true
                      ? _buildEmptyState()
                      : _buildMediaContent(
                          galleryDetail: galleryDetail ?? GalleryDetailModel()),
                ),
              ),
            ],
          );
        },
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
                Icons.photo_outlined,
                size: 60,
                color: Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'No media in this gallery',
              style: TextStyle(
                fontSize: 18.fs,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Photos and videos will appear here\nonce they are uploaded',
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

  Widget _buildMediaContent({
    required GalleryDetailModel galleryDetail,
  }) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
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
                'Media Gallery',
                style: TextStyle(
                  fontSize: 18.fs,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1F2937),
                ),
              ),
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
                childAspectRatio: 1.0,
              ),
              itemCount: galleryDetail.medias?.length ?? 0,
              itemBuilder: (context, index) {
                return _buildMediaItem(galleryDetail.medias?[index] ?? Media(),
                    index, galleryDetail);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaItem(
      Media media, int index, GalleryDetailModel galleryDetail) {
    final isVideo = media.type == 'video' ||
        (media.mimetype?.startsWith('video/') ?? false);

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        _openFullScreenView(index, galleryDetail);
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300 + (index * 50)),
        curve: Curves.easeOutBack,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                color: AppColors.nepalBlue.withAlpha(23),
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
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient.scale(0.3),
                  ),
                  child: isVideo
                      ? _buildVideoThumbnail(media)
                      : _buildImageThumbnail(media),
                ),
                if (isVideo)
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withAlpha(76),
                          Colors.black.withAlpha(128),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.play_arrow,
                          size: 30,
                          color: Color(0xFF1565C0),
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  top: 12.0,
                  right: 12.0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 6.0,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withAlpha(200),
                          Colors.black.withAlpha(150),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isVideo ? Icons.videocam : Icons.photo_camera,
                          size: 14.0.fs,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 4.0),
                        Text(
                          isVideo ? 'VIDEO' : 'PHOTO',
                          style: TextStyle(
                            fontSize: 10.fs,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.5,
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
      ),
    );
  }

  Widget _buildImageThumbnail(Media media) {
    return Image.network(
      '${AppEnviro.imageUrl}/${media.path}',
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient.scale(0.3),
          ),
          child: const Center(
            child: Icon(
              Icons.broken_image_outlined,
              size: 40,
              color: Colors.white,
            ),
          ),
        );
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient.scale(0.1),
          ),
          child: Center(
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(AppColors.nepalBlue),
                strokeWidth: 3,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildVideoThumbnail(Media media) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient.scale(0.5),
      ),
      child: const Center(
        child: Icon(
          Icons.video_library_outlined,
          size: 50,
          color: Colors.white,
        ),
      ),
    );
  }

  void _openFullScreenView(int initialIndex, GalleryDetailModel galleryDetail) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenMediaViewer(
          medias: galleryDetail.medias ?? [],
          initialIndex: initialIndex,
          galleryTitle: widget.title,
        ),
      ),
    );
  }
}

class FullScreenMediaViewer extends StatefulWidget {
  final List<Media> medias;
  final int initialIndex;
  final String galleryTitle;

  const FullScreenMediaViewer({
    Key? key,
    required this.medias,
    required this.initialIndex,
    required this.galleryTitle,
  }) : super(key: key);

  @override
  State<FullScreenMediaViewer> createState() => _FullScreenMediaViewerState();
}

class _FullScreenMediaViewerState extends State<FullScreenMediaViewer> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(23),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: const Icon(Icons.close, color: Colors.white, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.galleryTitle,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.fs,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${_currentIndex + 1} of ${widget.medias.length}',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12.fs,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.medias.length,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        itemBuilder: (context, index) {
          final media = widget.medias[index];
          final isVideo =
              media.type == 'video' || media.mimetype!.startsWith('video/');

          return isVideo
              ? _buildVideoPlayer(media)
              : _buildFullScreenImage(media);
        },
      ),
    );
  }

  Widget _buildFullScreenImage(Media media) {
    return InteractiveViewer(
      minScale: 0.5,
      maxScale: 3.0,
      child: CustomCachedImageNetwork(
        height: double.maxFinite,
        width: double.maxFinite,
        imageUrl: "${AppEnviro.imageUrl}/${media.path}",
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildVideoPlayer(Media media) {
    return ViewVideoPage(
      videoUrl: "${AppEnviro.imageUrl}/${media.path}",
    );
  }
}
