import 'package:equatable/equatable.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

/// YouTube Player States
abstract class YouTubePlayerState extends Equatable {
  const YouTubePlayerState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class YouTubePlayerInitial extends YouTubePlayerState {
  const YouTubePlayerInitial();
}

/// Player initialized state
class YouTubePlayerControllerReady extends YouTubePlayerState {
  final YoutubePlayerController controller;
  final bool isReady;

  const YouTubePlayerControllerReady({
    required this.controller,
    this.isReady = false,
  });

  YouTubePlayerControllerReady copyWith({
    YoutubePlayerController? controller,
    bool? isReady,
  }) {
    return YouTubePlayerControllerReady(
      controller: controller ?? this.controller,
      isReady: isReady ?? this.isReady,
    );
  }

  @override
  List<Object?> get props => [controller, isReady];
}

/// Error state
class YouTubePlayerErrorState extends YouTubePlayerState {
  final String message;

  const YouTubePlayerErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

