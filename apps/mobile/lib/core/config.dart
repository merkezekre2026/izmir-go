/// Build-time configuration passed with `--dart-define-from-file=config/<flavor>.json`.
/// Nothing here is secret: the app talks only to the İzmir Go API and the map style host.
class AppConfig {
  const AppConfig({required this.flavor, required this.apiBaseUrl, required this.mapStyleUrl});

  factory AppConfig.fromEnvironment() => const AppConfig(
    flavor: String.fromEnvironment('FLAVOR', defaultValue: 'dev'),
    apiBaseUrl: String.fromEnvironment('API_BASE_URL', defaultValue: 'http://10.0.2.2:8000/api/v1'),
    mapStyleUrl: String.fromEnvironment(
      'MAP_STYLE_URL',
      defaultValue: 'https://tiles.openfreemap.org/styles/liberty',
    ),
  );

  final String flavor;
  final String apiBaseUrl;
  final String mapStyleUrl;

  bool get isProd => flavor == 'prod';
}
