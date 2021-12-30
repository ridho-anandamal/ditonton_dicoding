import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/domain/entities/tv/tv_detail.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_show_detail.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_shows_recommendation.dart';
import 'package:flutter/cupertino.dart';

class TVDetailNotifier extends ChangeNotifier {
  final GetTVShowDetail getTVShowDetail;
  final GetTVShowsRecommendation getTVShowsRecommendation;

  TVDetailNotifier({
    required this.getTVShowDetail,
    required this.getTVShowsRecommendation,
  });

  late TVDetail _tvDetail;
  TVDetail get tvDetail => _tvDetail;

  RequestState _tvState = RequestState.Empty;
  RequestState get tvState => _tvState;

  List<TV> _tvRecommendation = [];
  List<TV> get tvRecommendation => _tvRecommendation;

  RequestState _recommendationState = RequestState.Empty;
  RequestState get recommendationState => _recommendationState;

  String _message = '';
  String get message => _message;

  Future<void> fetchTVShowDetail(int id) async {
    _tvState = RequestState.Loading;
    notifyListeners();

    final detailResult = await getTVShowDetail.execute(id);
    final recommendationResult = await getTVShowsRecommendation.execute(id);

    detailResult.fold((failure) {
      _tvState = RequestState.Error;
      _message = failure.message;
      notifyListeners();
    }, (tvDetailData) {
      _tvState = RequestState.Loading;
      _tvDetail = tvDetailData;
      notifyListeners();
      recommendationResult.fold((failure) {
        _recommendationState = RequestState.Error;
        _message = failure.message;
      }, (tvShows) {
        _recommendationState = RequestState.Loaded;
        _tvRecommendation = tvShows;
      });

      _tvState = RequestState.Loaded;
      notifyListeners();
    });
  }
}
