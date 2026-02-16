import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:nafausa/app/utils/size_config.dart';
import 'package:nafausa/features/events/controller/bloc/events_bloc.dart';
import 'package:nafausa/features/gallery/controller/bloc/gallery_bloc.dart';
import 'package:nafausa/features/home/controller/bloc/home_bloc.dart';
import 'package:nafausa/features/teams/controller/bloc/teams_bloc.dart';

import '../../features/auth/controllers/bloc/auth_bloc.dart';
import '../../features/notification/controller/bloc/notification_bloc.dart';
import 'bloc/connectivity/connectivity_bloc.dart';
import 'bloc/global/global_bloc.dart';

class MultiBlocPro extends StatelessWidget {
  final Widget child;
  const MultiBlocPro({super.key, required this.child});

  static void reset(BuildContext context) {
    context.read<GlobalBloc>().add(const GlobalAuthGetEvent());
    context.read<AuthBloc>().add(const LoginInitialEvent());
    context.read<HomeBloc>().add(HomeInitialEvent());
    context.read<EventsBloc>().add(EventsInitialEvent());
    context.read<GalleryBloc>().add(GalleryInitialEvent());
    context.read<TeamsBloc>().add(TeamsInitialEvent());
    context.read<NotificationBloc>().add(NotificationInitialEvent());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              ConnectivityBloc()..add(const CheckConnectivity()),
        ),
        BlocProvider(
          create: (context) => GlobalBloc()..add(const GlobalAuthGetEvent()),
        ),
        BlocProvider(
            create: (context) => AuthBloc()..add(const LoginInitialEvent())),
        BlocProvider(create: (context) => HomeBloc()..add(HomeInitialEvent())),
        BlocProvider(
            create: (context) => EventsBloc()..add(EventsInitialEvent())),
        BlocProvider(
            create: (context) => GalleryBloc()..add(GalleryInitialEvent())),
        BlocProvider(
            create: (context) => TeamsBloc()..add(TeamsInitialEvent())),
        BlocProvider(
            create: (context) =>
                NotificationBloc()..add(NotificationInitialEvent())),
      ],
      child: BlocBuilder<GlobalBloc, GlobalState>(
        builder: (context, state) {
          return BlocListener<ConnectivityBloc, ConnectivityState>(
            listener: (context, state) {
              Get.closeAllSnackbars();
              if (state is ConnectivityConnected) {
                Get.closeAllSnackbars();
              } else if (state is ConnectivityDisconnected) {
                Get.closeAllSnackbars();
                Get.showSnackbar(
                  GetSnackBar(
                    animationDuration: Duration.zero,
                    messageText: Text(
                      'Offline - No internet connection',
                      style: TextStyle(color: Colors.white, fontSize: 14.fs),
                    ),
                    icon: Icon(
                      CupertinoIcons.wifi_slash,
                      color: Colors.white,
                      size: 25.fs,
                    ),
                    duration: const Duration(seconds: 3),
                    backgroundColor: Colors.black,
                    dismissDirection: DismissDirection.up,
                    snackPosition: SnackPosition.TOP,
                    margin: const EdgeInsets.all(16),
                    borderRadius: 10,
                    padding: const EdgeInsets.all(24),
                    onTap: (value) {
                      Get.closeCurrentSnackbar();
                      Get.closeAllSnackbars();
                    },
                  ),
                );
              }
            },
            child: child,
          );
        },
      ),
    );
  }
}
