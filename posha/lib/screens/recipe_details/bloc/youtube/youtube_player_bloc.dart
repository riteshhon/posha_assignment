import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:posha/screens/recipe_details/bloc/youtube/youtube_player_event.dart';
import 'package:posha/screens/recipe_details/bloc/youtube/youtube_player_state.dart';

/// YouTube Player BLoC
class YouTubePlayerBloc extends Bloc<YouTubePlayerEvent, YouTubePlayerState> {
  YouTubePlayerBloc() : super(const YouTubePlayerInitial()) {
    on<YouTubePlayerInitialized>(_onInitialized);
    on<YouTubePlayerReady>(_onReady);
    on<YouTubePlayerError>(_onError);
    on<YouTubePlayerDisposed>(_onDisposed);
  }

  void _onInitialized(
    YouTubePlayerInitialized event,
    Emitter<YouTubePlayerState> emit,
  ) {
    try {
      final videoId = YoutubePlayer.convertUrlToId(event.videoUrl);
      if (videoId != null && videoId.isNotEmpty) {
        final controller = YoutubePlayerController(
          initialVideoId: videoId,
          flags: const YoutubePlayerFlags(
            autoPlay: false,
            mute: false,
            enableCaption: true,
          ),
        );

        emit(YouTubePlayerControllerReady(controller: controller));
      } else {
        emit(const YouTubePlayerErrorState('Invalid video URL'));
      }
    } catch (e) {
      emit(YouTubePlayerErrorState(e.toString()));
    }
  }

  void _onReady(YouTubePlayerReady event, Emitter<YouTubePlayerState> emit) {
    if (state is YouTubePlayerControllerReady) {
      final currentState = state as YouTubePlayerControllerReady;
      emit(currentState.copyWith(isReady: true));
    }
  }

  void _onError(YouTubePlayerError event, Emitter<YouTubePlayerState> emit) {
    emit(YouTubePlayerErrorState(event.message ?? 'Unknown error'));
  }

  void _onDisposed(
    YouTubePlayerDisposed event,
    Emitter<YouTubePlayerState> emit,
  ) {
    if (state is YouTubePlayerControllerReady) {
      final currentState = state as YouTubePlayerControllerReady;
      currentState.controller.dispose();
    }
    emit(const YouTubePlayerInitial());
  }

  @override
  Future<void> close() {
    if (state is YouTubePlayerControllerReady) {
      final currentState = state as YouTubePlayerControllerReady;
      currentState.controller.dispose();
    }
    return super.close();
  }
}
