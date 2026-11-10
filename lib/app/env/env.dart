import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env', obfuscate: false)
abstract class Env {
  @EnviedField(varName: 'API_BASE_URL')
  static final String apiBaseUrl = _Env.apiBaseUrl;
}
