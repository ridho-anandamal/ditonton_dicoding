import 'package:core/common/http_ssl_pinning.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SSL Pinning Http ', () {
    test(
      'Should get response 200 when success connect',
      () async {
        final _client = await Shared.createLEClient(isTestMode: true);
        final response = await _client.get(Uri.parse(
            'https://api.themoviedb.org/3/tv/on_the_air?api_key=2174d146bb9c0eab47529b2e77d6b526'));
        expect(response.statusCode, 200);
        _client.close();
      },
    );
  });
}
