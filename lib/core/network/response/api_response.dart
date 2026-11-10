import 'package:json_annotation/json_annotation.dart';

part 'api_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class ApiResponse<T> {
  @JsonKey(name: 'Code')
  final int? code;
  @JsonKey(name: 'Message')
  final String? message;
  @JsonKey(name: 'Data')
  final T data;

  const ApiResponse({this.code, this.message, required this.data});

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$ApiResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$ApiResponseToJson(this, toJsonT);

  /// `{Code, Message, Data}` zarfını açıp sadece `Data`'yı döndürür.
  /// `CustomDioService`'in `parse` parametresiyle kullanılır:
  /// `parse: (d) => ApiResponse.parseData(d, User.fromJson)`
  static R parseData<R>(Object? json, R Function(Object? json) fromJsonT) =>
      ApiResponse<R>.fromJson(json as Map<String, dynamic>, fromJsonT).data;
}
