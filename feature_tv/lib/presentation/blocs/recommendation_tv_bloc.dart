import 'package:equatable/equatable.dart';
import 'package:feature_tv/domain/entities/tv.dart';
import 'package:feature_tv/domain/usecases/get_tv_shows_recommendation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecommendationTVBloc
    extends Bloc<RecommendationTVEvent, RecommendationTVState> {
  final GetTVShowsRecommendation getTVShowsRecommendation;

  RecommendationTVBloc({required this.getTVShowsRecommendation})
      : super(RecommendationTVEmptyState()) {
    on<FetchNowRecommendationTV>((event, emit) async {
      final id = event.id;
      emit(RecommendationTVLoadingState());

      final result = await getTVShowsRecommendation.execute(id);

      result.fold((failure) {
        emit(RecommendationTVErrorState(message: failure.message));
      }, (dataDetail) {
        emit(RecommendationTVHasDataState(result: dataDetail));
      });
    });
  }
}

abstract class RecommendationTVState extends Equatable {
  const RecommendationTVState();

  @override
  List<Object> get props => [];
}

class RecommendationTVEmptyState extends RecommendationTVState {}

class RecommendationTVLoadingState extends RecommendationTVState {}

class RecommendationTVErrorState extends RecommendationTVState {
  final String message;

  const RecommendationTVErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

class RecommendationTVHasDataState extends RecommendationTVState {
  final List<TV> result;

  const RecommendationTVHasDataState({required this.result});

  @override
  List<Object> get props => [result];
}

// Event
abstract class RecommendationTVEvent extends Equatable {
  const RecommendationTVEvent();

  @override
  List<Object> get props => [];
}

class FetchNowRecommendationTV extends RecommendationTVEvent {
  final int id;

  const FetchNowRecommendationTV({required this.id});

  @override
  List<Object> get props => [id];
}
