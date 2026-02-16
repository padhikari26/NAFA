import 'dart:io';
import 'package:flutter/material.dart';
import 'package:nafausa/app/theme/theme.dart';
import 'package:nafausa/app/utils/helper.dart';
import 'package:nafausa/app/utils/size_config.dart';
import '../../../../app/utils/app_colors.dart';
import '../../../../shared/widgets/custom_cached_network_image.dart';

class ProfilePictureSelector extends StatelessWidget {
  final File? imageFile;
  final String? imageUrl;
  final String? userName;
  final VoidCallback onImagePickRequested;

  const ProfilePictureSelector({
    super.key,
    this.imageFile,
    this.imageUrl,
    required this.onImagePickRequested,
    this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(35),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(25),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: imageFile != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(35),
                  child: Image.file(
                    imageFile!,
                    fit: BoxFit.cover,
                    width: 120,
                    height: 120,
                  ),
                )
              : imageUrl != null && imageUrl!.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(35),
                      child: CustomCachedNetwork(
                        imageUrl: imageUrl!,
                        borderRadius: 35,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Center(
                      child: Text(
                        userName?.isNotNullOrEmpty ?? false
                            ? userName![0].toUpperCase()
                            : 'NA',
                        style: context.titleLarge?.copyWith(
                          fontSize: 22.fs,
                          fontWeight: FontWeight.bold,
                          color: AppColors.nepalRed,
                        ),
                      ),
                    ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: GestureDetector(
            onTap: onImagePickRequested,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Icon(
                Icons.camera_alt,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
