import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:posha/core/theme/app_colors.dart';
import 'package:posha/screens/recipe_details/bloc/youtube/youtube_player_bloc.dart';
import 'package:posha/screens/recipe_details/bloc/youtube/youtube_player_event.dart';
import 'package:posha/screens/recipe_details/bloc/youtube/youtube_player_state.dart';

/// YouTube Video Player Widget
class YouTubePlayerWidget extends StatelessWidget {
  final String videoUrl;

  const YouTubePlayerWidget({super.key, required this.videoUrl});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          YouTubePlayerBloc()..add(YouTubePlayerInitialized(videoUrl)),
      child: _YouTubePlayerContent(videoUrl: videoUrl),
    );
  }
}

class _YouTubePlayerContent extends StatelessWidget {
  final String videoUrl;

  const _YouTubePlayerContent({required this.videoUrl});

  Future<void> _openInBrowser() async {
    final uri = Uri.parse(videoUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<YouTubePlayerBloc, YouTubePlayerState>(
      builder: (context, state) {
        if (state is YouTubePlayerErrorState) {
          return _buildFallbackWidget();
        }

        if (state is YouTubePlayerControllerReady) {
          return Builder(
            builder: (context) {
              try {
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 16.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: Offset(0, 2.h),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: YoutubePlayer(
                      controller: state.controller,
                      showVideoProgressIndicator: true,
                      progressIndicatorColor: AppColors.primary,
                      progressColors: ProgressBarColors(
                        playedColor: AppColors.primary,
                        handleColor: AppColors.primary,
                        bufferedColor: AppColors.primaryLight,
                        backgroundColor: AppColors.surfaceVariant,
                      ),
                      onReady: () {
                        context.read<YouTubePlayerBloc>().add(
                          const YouTubePlayerReady(),
                        );
                      },
                    ),
                  ),
                );
              } catch (e) {
                return _buildFallbackWidget();
              }
            },
          );
        }

        // Loading state
        return Container(
          margin: EdgeInsets.symmetric(vertical: 16.h),
          height: 200.h,
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
        );
      },
    );
  }

  Widget _buildFallbackWidget() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16.h),
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        children: [
          Icon(
            Icons.play_circle_outline,
            size: 48.sp,
            color: AppColors.primary,
          ),
          SizedBox(height: 12.h),
          Text(
            'Watch on YouTube',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Tap to open video in browser',
            style: TextStyle(fontSize: 13.sp, color: AppColors.textSecondary),
          ),
          SizedBox(height: 16.h),
          ElevatedButton.icon(
            onPressed: _openInBrowser,
            icon: Icon(Icons.open_in_new, size: 18.sp),
            label: const Text('Open Video'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.textOnPrimary,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
            ),
          ),
        ],
      ),
    );
  }
}
