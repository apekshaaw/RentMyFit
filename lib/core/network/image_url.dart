import 'api_config.dart';

Future<String> buildImageUrl(String raw) async {
  if (raw.startsWith('http')) return raw;
  final base = await ApiConfig.baseUrl;    // e.g. http://192.168.1.74:5000/api
  final path = raw.startsWith('/') ? raw.substring(1) : raw;
  return '$base/$path';
}
