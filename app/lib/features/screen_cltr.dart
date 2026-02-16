import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nafausa/features/auth/view/auth_screen.dart';
import 'package:nafausa/features/main_navigation.dart';
import '../core/controller/bloc/global/global_bloc.dart';
import '../shared/services/notification_service.dart';

class ScreenCltr extends StatefulWidget {
  static const String routeName = '/screen-cltr';
  const ScreenCltr({super.key});

  @override
  State<ScreenCltr> createState() => _ScreenCltrState();
}

class _ScreenCltrState extends State<ScreenCltr> {
  NotificationService notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    notificationService.setupInteractMessage(context);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: BlocBuilder<GlobalBloc, GlobalState>(
        buildWhen: (previous, current) =>
            previous.authState != current.authState,
        builder: (context, state) {
          return _buildMainContent(state.authState);
        },
      ),
    );
  }

  Widget _buildMainContent(LoginState? authState) {
    switch (authState) {
      case LoginState.unauthenticate:
        return const AuthScreen();
      case LoginState.initial:
        return const AuthScreen();
      case LoginState.authenticate:
        return const MainNavigation();
      default:
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
  }
}
