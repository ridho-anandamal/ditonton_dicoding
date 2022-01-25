// ignore_for_file: constant_identifier_names

import 'package:feature_movie/presentation/blocs/popular_movie_bloc.dart';
import 'package:feature_movie/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PopularMoviesPage extends StatefulWidget {
  static const ROUTE_NAME = '/popular-movie';

  const PopularMoviesPage({Key? key}) : super(key: key);

  @override
  _PopularMoviesPageState createState() => _PopularMoviesPageState();
}

class _PopularMoviesPageState extends State<PopularMoviesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => context.read<PopularMovieBloc>().add(FetchNowPopularMovies()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<PopularMovieBloc, PopularMovieState>(
            builder: (context, state) {
          if (state is PopularMovieLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is PopularMovieHasDataState) {
            return ListView.builder(
              itemBuilder: (context, index) {
                final movie = state.result[index];
                return MovieCard(movie);
              },
              itemCount: state.result.length,
            );
          } else if (state is PopularMovieEmptyState) {
            return const Text('Data Tidak Ditemukan');
          } else if (state is PopularMovieErrorState) {
            return Center(
              key: const Key('error_message'),
              child: Text(state.message),
            );
          } else {
            return const Text('Error Bloc');
          }
        }),
      ),
    );
  }
}
