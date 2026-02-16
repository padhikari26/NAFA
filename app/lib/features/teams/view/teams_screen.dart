import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:nafausa/app/utils/helper.dart';
import 'package:nafausa/app/utils/size_config.dart';
import 'package:nafausa/features/gallery/view/gallery_detail_screen.dart';
import 'package:nafausa/features/teams/controller/bloc/teams_bloc.dart';
import 'package:nafausa/features/teams/model/teams_model.dart';
import 'package:nafausa/shared/widgets/custom_cached_network_image.dart';
import 'package:nafausa/shared/widgets/html_viewer.dart';
import 'package:nafausa/shared/widgets/loading.dart';
import '../../../app/utils/app_colors.dart';
import '../../../env.dart';
import '../../../shared/widgets/common_pop.dart';

class TeamsScreen extends StatefulWidget {
  const TeamsScreen({super.key});

  @override
  State<TeamsScreen> createState() => _TeamsScreenState();
}

class _TeamsScreenState extends State<TeamsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late TeamsBloc _teamsBloc;

  @override
  void initState() {
    super.initState();
    _teamsBloc = BlocProvider.of<TeamsBloc>(context);
    _teamsBloc.add(FetchTeamsEvent());
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        slivers: [
          /// Sliver AppBar like ContactUsScreen
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
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Our Teams",
                          style: TextStyle(
                            fontSize: 24.fs,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Meet the Executive, Advisory, and Past Teams",
                          style: TextStyle(
                            fontSize: 12.fs,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
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

          /// Body content with SliverToBoxAdapter
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(20),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.nepalBlue, AppColors.nepalRed],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.grey.shade600,
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.fs,
                      ),
                      unselectedLabelStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 13.fs,
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.transparent,
                      tabs: const [
                        Tab(text: 'Executive'),
                        Tab(text: 'Advisory'),
                        Tab(text: 'Past Teams'),
                      ],
                    ),
                  ),

                  SizedBox(height: 2.hs),

                  /// TabBarView inside Bloc
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.75,
                    child: BlocBuilder<TeamsBloc, TeamsState>(
                      builder: (context, state) {
                        return Processing(
                          loading:
                              state.isLoading && (state.teams?.isEmpty ?? true),
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              _buildTeamContent(
                                  state.executive, "Executive Teams"),
                              _buildTeamContent(
                                  state.advisory, "Advisory Teams"),
                              _buildTeamContent(
                                  state.pastTeams, "Past Executive Teams"),
                            ],
                          ),
                        );
                      },
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

  Widget _buildTeamContent(TeamsData team, String title) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header Box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.nepalBlue.withAlpha(20),
                  AppColors.nepalRed.withAlpha(20),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 21.fs,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 2.hs),

          /// Media Section
          Visibility(
            visible: team.media?.isNotEmpty ?? false,
            child: SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: team.media?.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Get.to(() => FullScreenMediaViewer(
                          medias: team.media ?? [],
                          initialIndex: index,
                          galleryTitle: title));
                    },
                    child: Container(
                      width: 280,
                      margin: const EdgeInsets.only(right: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(20),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CustomCachedImageNetwork(
                          fit: BoxFit.contain,
                          imageUrl:
                              "${AppEnviro.imageUrl}/${team.media?[index].path ?? ""}",
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          /// Content Section
          Visibility(
            visible: team.content?.isNotNullOrEmpty ?? false,
            child: Column(
              children: [
                SizedBox(height: 2.hs),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(10),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: HtmlViewerWidget(data: team.content),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
