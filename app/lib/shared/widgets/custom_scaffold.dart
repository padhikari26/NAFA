//custom scaffold

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nafausa/shared/widgets/common_pop.dart';

import 'loading.dart';

class CustomScaffold extends StatelessWidget {
  final Widget body;
  final String title;
  final bool showBackButton;
  final bool showAppBar;
  final Color? backgroundColor;
  final Widget? floatingActionButton;
  final bool isLoading;
  final PreferredSizeWidget? appBar;
  final Function()? onAppBarBack;
  final double titleSize;
  final double? appBarHeight;
  final Widget? bottomNavigationBar;
  final Widget? actions;
  final Widget? drawer;
  final GlobalKey<ScaffoldState>? scaffoldKey;

  const CustomScaffold({
    super.key,
    required this.body,
    this.title = '',
    this.showBackButton = false,
    this.showAppBar = true,
    this.backgroundColor,
    this.floatingActionButton,
    this.isLoading = false,
    this.appBar,
    this.onAppBarBack,
    this.titleSize = 20,
    this.appBarHeight,
    this.bottomNavigationBar,
    this.actions,
    this.drawer,
    this.scaffoldKey,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: backgroundColor ?? Colors.white,
        drawer: drawer,
        appBar: showAppBar
            ? appBar ??
                CupertinoNavigationBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: backgroundColor ?? Colors.white,
                  middle: Text(
                    title,
                  ),
                  trailing: actions,
                  leading: showBackButton
                      ? const CommonPop(
                          hasContainer: false,
                        )
                      : null,
                )
            : null,
        body: Processing(givePadding: false, loading: isLoading, child: body),
        floatingActionButton: floatingActionButton,
        bottomNavigationBar: bottomNavigationBar,
      ),
    );
  }
}
