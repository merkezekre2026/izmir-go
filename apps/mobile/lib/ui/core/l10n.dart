import 'package:flutter/widgets.dart';
import 'package:izmir_go/core/failures.dart';
import 'package:izmir_go/domain/models/transit.dart';
import 'package:izmir_go/l10n/gen/app_localizations.dart';

extension L10nX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

String modeLabel(AppLocalizations l, TransitMode mode) => switch (mode) {
  TransitMode.bus => l.modeBus,
  TransitMode.metro => l.modeMetro,
  TransitMode.tram => l.modeTram,
  TransitMode.rail => l.modeRail,
  TransitMode.ferry => l.modeFerry,
  TransitMode.walk => l.modeWalk,
  TransitMode.other => l.modeBus,
};

String failureMessage(AppLocalizations l, Object error) => switch (error) {
  NetworkFailure() => l.errorNetwork,
  ApiProblem(isRoutingUnavailable: true) => l.errorRouting,
  ApiProblem(isRateLimited: true) => l.errorRateLimited,
  ApiProblem(isOutsideCoverage: true) => l.errorOutsideCoverage,
  ApiProblem(isNoDataset: true) => l.errorNoDataset,
  ApiProblem(isNotFound: true) => l.errorNotFound,
  LocationFailure(reason: LocationFailureReason.deniedForever) => l.locationDeniedForever,
  LocationFailure() => l.locationDenied,
  _ => l.errorGeneric,
};
