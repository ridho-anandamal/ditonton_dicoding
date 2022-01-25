// ignore_for_file: constant_identifier_names

import 'package:core/core.dart';
import 'package:feature_tv/presentation/blocs/search_tv_bloc.dart';
import 'package:feature_tv/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchTVPage extends StatelessWidget {
  static const ROUTE_NAME = '/search-tv';

  const SearchTVPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search TV Shows'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: (query) {
                context.read<SearchTVBloc>().add(OnQueryChanged(query: query));
              },
              decoration: const InputDecoration(
                hintText: 'Search TV title',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
            ),
            const SizedBox(height: 16),
            Text(
              'Search Result',
              style: kHeading6,
            ),
            BlocBuilder<SearchTVBloc, SearchTVState>(
              builder: (context, state) {
                if (state is SearchTVLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is SearchTVHasDataState) {
                  final result = state.result;
                  return Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemBuilder: (context, index) {
                        final tvResult = state.result[index];
                        return TVCard(tv: tvResult);
                      },
                      itemCount: result.length,
                    ),
                  );
                } else if (state is SearchTVErrorState) {
                  return Expanded(
                    child: Center(
                      key: const Key('error_message'),
                      child: Text(state.message),
                    ),
                  );
                } else {
                  return Expanded(
                    child: Container(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
