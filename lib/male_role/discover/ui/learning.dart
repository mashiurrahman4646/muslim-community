import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/app_config.dart';
import 'package:muslim_community/appcolore.dart';
import 'package:muslim_community/approut.dart';
import 'package:muslim_community/male_role/discover/controller/learningcontroller.dart';
import 'package:muslim_community/female_role/discover/model/learning_content_model.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class LearningUI extends StatelessWidget {
  const LearningUI({super.key});

  String _resolveMediaUrl(String url) {
    if (url.isEmpty) return '';
    
    String serverBase = AppConfig.baseUrl.replaceAll('/api/v1', '');
    String resolvedUrl = url.trim();
    
    if (resolvedUrl.startsWith('/')) {
      resolvedUrl = "$serverBase$resolvedUrl";
    } else if (resolvedUrl.startsWith('uploads/')) {
      resolvedUrl = "$serverBase/$resolvedUrl";
    }
    
    if (resolvedUrl.contains('localhost') || resolvedUrl.contains('127.0.0.1')) {
      try {
        final uri = Uri.parse(AppConfig.baseUrl);
        final actualHost = "${uri.scheme}://${uri.host}:${uri.port}";
        resolvedUrl = resolvedUrl
            .replaceAll(RegExp(r'https?://localhost:\d+'), actualHost)
            .replaceAll(RegExp(r'https?://127\.0\.0\.1:\d+'), actualHost)
            .replaceAll('localhost', uri.host)
            .replaceAll('127.0.0.1', uri.host);
      } catch (e) {
        debugPrint("Error parsing base URL for resolution: $e");
      }
    }
    
    return resolvedUrl;
  }

  String _extractYoutubeId(String url) {
    if (url.contains('youtu.be/')) {
      return url.split('youtu.be/').last.split('?').first;
    } else if (url.contains('v=')) {
      return url.split('v=').last.split('&').first;
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final MaleLearningController controller = Get.put(MaleLearningController());

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator(color: AppColors.maleColor));
      }

      if (controller.learningContents.isEmpty) {
        return Center(
          child: Text(
            "No learning contents found",
            style: GoogleFonts.inter(fontSize: 16.sp, color: Colors.grey),
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () => controller.fetchLearningContents(),
        color: AppColors.maleColor,
        child: ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          itemCount: controller.learningContents.length,
          itemBuilder: (context, index) {
            final content = controller.learningContents[index];
            return _buildLearningCard(
              context,
              content,
              AppRoutes.maleLearningDetails,
            );
          },
        ),
      );
    });
  }

  Widget _buildLearningCard(
    BuildContext context,
    LearningContentModel content,
    String route,
  ) {
    // Dynamic color based on category
    Color categoryColor = AppColors.maleColor;
    if (content.category.toLowerCase() == 'hadith') categoryColor = const Color(0xFFE57373);
    if (content.category.toLowerCase() == 'duas') categoryColor = const Color(0xFF81C784);

    return GestureDetector(
      onTap: () => Get.toNamed(route, arguments: {
        'id': content.id,
        'category': content.category,
        'title': content.title,
        'videoUrl': content.videoUrl,
        'description': content.description,
        'likesCount': content.likesCount,
        'isLiked': content.isLiked,
      }),
      child: Container(
        margin: EdgeInsets.only(bottom: 20.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Builder(
          builder: (context) {
            final String youtubeId = _extractYoutubeId(content.videoUrl);
            final String resolvedVideoUrl = _resolveMediaUrl(content.videoUrl);
            final String categoryLower = content.category.toLowerCase();
            String assetPath = 'assets/image/learningimage3.png';
            if (categoryLower.contains('hadith')) {
              assetPath = 'assets/image/learningimage1.png';
            } else if (categoryLower.contains('dua')) {
              assetPath = 'assets/image/learningimage2.png';
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25.r),
                        topRight: Radius.circular(25.r),
                      ),
                      child: Container(
                        width: double.infinity,
                        height: 180.h,
                        color: Colors.black,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            if (youtubeId.isNotEmpty)
                              Image.network(
                                "https://img.youtube.com/vi/$youtubeId/0.jpg",
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return const Center(child: CircularProgressIndicator(color: Colors.white));
                                },
                                errorBuilder: (context, error, stackTrace) => VideoThumbnailWidget(
                                  videoUrl: resolvedVideoUrl,
                                  fallbackAsset: assetPath,
                                ),
                              )
                            else
                              VideoThumbnailWidget(
                                videoUrl: resolvedVideoUrl,
                                fallbackAsset: assetPath,
                              ),
                            const Icon(Icons.play_circle_fill, size: 50, color: Colors.white70),
                          ],
                        ),
                      ),
                    ),
                Positioned(
                  top: 15.h,
                  left: 15.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: categoryColor,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Text(
                      content.category.toUpperCase(),
                      style: GoogleFonts.inter(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 15.h,
                  right: 15.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      content.durationText,
                      style: GoogleFonts.inter(
                        fontSize: 10.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(15.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    content.title,
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2D3436),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Icon(Icons.thumb_up_alt_outlined, size: 16.sp, color: Colors.grey),
                      SizedBox(width: 5.w),
                      Text(
                        content.likesCount.toString(),
                        style: GoogleFonts.inter(fontSize: 12.sp, color: Colors.grey),
                      ),
                      SizedBox(width: 20.w),
                      Icon(Icons.chat_bubble_outline, size: 16.sp, color: Colors.grey),
                      SizedBox(width: 5.w),
                      Text(
                        content.commentsCount.toString(),
                        style: GoogleFonts.inter(fontSize: 12.sp, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    ),
  ),
);
  }
}

class VideoThumbnailWidget extends StatefulWidget {
  final String videoUrl;
  final String fallbackAsset;

  const VideoThumbnailWidget({
    super.key,
    required this.videoUrl,
    required this.fallbackAsset,
  });

  @override
  State<VideoThumbnailWidget> createState() => _VideoThumbnailWidgetState();
}

class _VideoThumbnailWidgetState extends State<VideoThumbnailWidget> {
  Uint8List? _thumbnailData;
  bool _isLoading = true;
  bool _hasError = false;

  // Simple static in-memory cache to prevent redundant fetches when scrolling
  static final Map<String, Uint8List> _cache = {};

  @override
  void initState() {
    super.initState();
    _loadThumbnail();
  }

  @override
  void didUpdateWidget(covariant VideoThumbnailWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoUrl != widget.videoUrl) {
      _loadThumbnail();
    }
  }

  Future<void> _loadThumbnail() async {
    if (widget.videoUrl.isEmpty) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
      return;
    }

    if (_cache.containsKey(widget.videoUrl)) {
      if (mounted) {
        setState(() {
          _thumbnailData = _cache[widget.videoUrl];
          _isLoading = false;
          _hasError = false;
        });
      }
      return;
    }

    if (mounted) {
      setState(() {
        _isLoading = true;
        _hasError = false;
      });
    }

    try {
      final data = await VideoThumbnail.thumbnailData(
        video: widget.videoUrl,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 360,
        quality: 50,
      );

      if (data != null) {
        _cache[widget.videoUrl] = data;
        if (mounted) {
          setState(() {
            _thumbnailData = data;
            _isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _hasError = true;
          });
        }
      }
    } catch (e) {
      debugPrint("Error generating video thumbnail: $e");
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            widget.fallbackAsset,
            fit: BoxFit.cover,
          ),
          const Center(
            child: CircularProgressIndicator(color: Colors.white70),
          ),
        ],
      );
    }

    if (_hasError || _thumbnailData == null) {
      return Image.asset(
        widget.fallbackAsset,
        fit: BoxFit.cover,
      );
    }

    return Image.memory(
      _thumbnailData!,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
    );
  }
}
