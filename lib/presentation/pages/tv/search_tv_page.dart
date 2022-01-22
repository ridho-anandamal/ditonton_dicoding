import 'package:ditonton/common/constants.dart';
import 'package:ditonton/presentation/bloc/tv/search_tv_bloc.dart';
import 'package:ditonton/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchTVPage extends StatelessWidget {
  static const ROUTE_NAME = '/search-tv';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search TV Shows'),
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
              decoration: InputDecoration(
                hintText: 'Search TV title',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
            ),
            SizedBox(height: 16),
            Text(
              'Search Result',
              style: kHeading6,
            ),
            BlocBuilder<SearchTVBloc, SearchTVState>(builder: (context, state) {
              if (state is SearchTVLoadingState) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is SearchTVHasDataState) {
                return Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemBuilder: (context, index) {
                      final tvResult = state.result[index];
                      return TVCard(tv: tvResult);
                    },
                    itemCount: state.result.length,
                  ),
                );
              } else {
                return Expanded(
                  child: Container(),
                );
              }
            })
          ],
        ),
      ),
    );
  }
}
