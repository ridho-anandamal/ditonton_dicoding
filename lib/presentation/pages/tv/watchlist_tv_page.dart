import 'package:ditonton/common/constants.dart';
import 'package:flutter/material.dart';

class WatchListTVPage extends StatelessWidget {
  static const ROUTE_NAME = '/watchlist-tv';
  const WatchListTVPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Watchlist TV Shows'),
      ),
      body: Center(
        child: Text(
          'Under Development',
          style: kHeading5,
        ),
      ),
    );
  }
}
