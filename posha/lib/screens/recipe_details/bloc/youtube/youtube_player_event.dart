import 'package:equatable/equatable.dart';

/// YouTube Player Events
abstract class YouTubePlayerEvent extends Equatable {
  const YouTubePlayerEvent();

  @override
  List<Object?> get props => [];
}

/// Initialize YouTube player
class YouTubePlayerInitialized extends YouTubePlayerEvent {
  final String videoUrl;

  const YouTubePlayerInitialized(this.videoUrl);

  @override
  List<Object?> get props => [videoUrl];
}

/// Player ready event
class YouTubePlayerReady extends YouTubePlayerEvent {
  const YouTubePlayerReady();
}

/// Player error event
class YouTubePlayerError extends YouTubePlayerEvent {
  final String? message;

  const YouTubePlayerError([this.message]);

  @override
  List<Object?> get props => [message];
}

/// Dispose player
class YouTubePlayerDisposed extends YouTubePlayerEvent {
  const YouTubePlayerDisposed();
}

