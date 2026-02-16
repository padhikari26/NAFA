import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nafausa/app/utils/size_config.dart';

import '../shared/widgets/common_pop.dart';
import '../shared/widgets/custom_page_scaffold.dart';

class UnderConstructionPage extends StatelessWidget {
  final String? title;
  final String? description;
  final double? descriptionFontSize;
  final bool showBackButton;
  const UnderConstructionPage({
    super.key,
    this.title,
    this.description,
    this.descriptionFontSize,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPageScaffold(
      backgroundColor: Colors.white,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: Colors.white,
        leading: showBackButton
            ? const CommonPop(
                hasContainer: false,
              )
            : null,
        middle: Text(title ?? "Under Construction"),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated construction illustration (using Lottie)
              Lottie.asset(
                'assets/animations/construction.json',
                width: 200,
                height: 200,
                fit: BoxFit.fill,
              ),
              const SizedBox(height: 20),
              // Title
              if (description == null)
                Text(
                  "Under Construction",
                  style: TextStyle(
                    fontSize: 24.fs,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[800],
                  ),
                ),
              if (description != null && description!.split('\n').isNotEmpty)
                Text(
                  description!.split('\n')[0],
                  style: TextStyle(
                    fontSize: description != null
                        ? (descriptionFontSize ?? 13).fs
                        : 24.fs,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[800],
                  ),
                ),
              if (description != null && description!.split('\n').length > 1)
                Text(
                  description!.split('\n')[1],
                  style: TextStyle(
                    fontSize: description != null
                        ? (descriptionFontSize ?? 13).fs
                        : 24.fs,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[800],
                  ),
                ),
              if (description != null && description!.split('\n').length > 2)
                Text(
                  description!.split('\n')[2],
                  style: TextStyle(
                    fontSize: description != null
                        ? (descriptionFontSize ?? 13).fs
                        : 24.fs,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[800],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
