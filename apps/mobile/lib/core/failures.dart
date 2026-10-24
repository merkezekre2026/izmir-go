import 'package:dio/dio.dart';

/// Every error a repository can surface to the UI. Views map these to Turkish messages.
sealed class AppFailure implements Exception {
  const AppFailure([this.detail]);
  final String? detail;
}

/// No connection, DNS failure or timeout: the device could not reach the API.
final class NetworkFailure extends AppFailure {
  const NetworkFailure([super.detail]);
}

/// The API answered with an RFC 9457 problem document.
final class ApiProblem extends AppFailure {
  const ApiProblem(this.code, this.status, [super.detail]);
  final String code;
  final int status;

  bool get isRoutingUnavailable => code == 'ROUTING_UNAVAILABLE';
  bool get isUpstreamUnavailable => code == 'UPSTREAM_UNAVAILABLE';
  bool get isNotFound => code == 'NOT_FOUND';
  bool get isOutsideCoverage => code == 'OUTSIDE_COVERAGE_AREA';
  bool get isRateLimited => code == 'RATE_LIMITED';
  bool get isNoDataset => code == 'NO_ACTIVE_DATASET';
}

final class LocationFailure extends AppFailure {
  const LocationFailure(this.reason, [super.detail]);
  final LocationFailureReason reason;
}

enum LocationFailureReason { serviceDisabled, denied, deniedForever }

final class UnexpectedFailure extends AppFailure {
  const UnexpectedFailure([super.detail]);
}

AppFailure failureFromDio(DioException e) {
  final response = e.response;
  if (response == null) {
    return NetworkFailure(e.message);
  }
  final data = response.data;
  if (data is Map<String, dynamic> && data['code'] is String) {
    return ApiProblem(data['code'] as String, response.statusCode ?? 0, data['detail'] as String?);
  }
  return ApiProblem('HTTP_${response.statusCode}', response.statusCode ?? 0);
}
