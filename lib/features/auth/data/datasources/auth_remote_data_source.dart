import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../config/app_config.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/login/login_request.dart';
import '../models/login/login_response.dart';
import '../models/register/register_request.dart';
import '../models/register/register_response.dart';

part 'auth_remote_data_source.g.dart';

@RestApi(baseUrl: AppConfig.apiPrefix)
abstract class AuthRemoteDataSource {
  factory AuthRemoteDataSource(Dio dio, {String baseUrl}) =
      _AuthRemoteDataSource;

  @POST(ApiEndpoints.signup)
  Future<RegisterResponse> register(@Body() RegisterRequest body);

  @POST(ApiEndpoints.login)
  Future<LoginResponse> login(@Body() LoginRequest body);
}
