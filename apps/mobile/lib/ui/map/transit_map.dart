import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izmir_go/app/providers.dart';
import 'package:izmir_go/app/theme/tokens.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

/// A polyline in [lon, lat] order, as the API sends it.
class MapLine {
  const MapLine(this.points, {required this.color, this.dashed = false, this.width = 5});
  final List<List<double>> points;
  final Color color;
  final bool dashed;
  final double width;
}

class MapPoint {
  const MapPoint({
    required this.id,
    required this.lat,
    required this.lon,
    required this.color,
    this.radius = 6,
  });
  final String id;
  final double lat;
  final double lon;
  final Color color;
  final double radius;
}

String _hex(Color c) => '#${(c.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0')}';

/// Map that supports journey planning instead of competing with it: it fits the content,
/// draws lines and stop points, and reports taps. Geocoding and routing are separate services.
class TransitMap extends ConsumerStatefulWidget {
  const TransitMap({
    this.lines = const [],
    this.points = const [],
    this.center,
    this.zoom = 14,
    this.onPointTap,
    this.onMapTap,
    this.showMyLocation = false,
    this.semanticLabel = 'Harita',
    super.key,
  });

  final List<MapLine> lines;
  final List<MapPoint> points;
  final (double lat, double lon)? center;
  final double zoom;
  final ValueChanged<String>? onPointTap;
  final void Function(double lat, double lon)? onMapTap;
  final bool showMyLocation;
  final String semanticLabel;

  @override
  ConsumerState<TransitMap> createState() => _TransitMapState();
}

class _TransitMapState extends ConsumerState<TransitMap> {
  MapLibreMapController? _controller;
  final _circleIds = <String, String>{};

  (double, double) get _initialCenter {
    if (widget.center != null) {
      return widget.center!;
    }
    final pts = [
      for (final p in widget.points) (p.lat, p.lon),
      for (final l in widget.lines)
        for (final c in l.points) (c[1], c[0]),
    ];
    if (pts.isEmpty) {
      return (38.4237, 27.1428); // Konak
    }
    final lat = pts.map((p) => p.$1).reduce((a, b) => a + b) / pts.length;
    final lon = pts.map((p) => p.$2).reduce((a, b) => a + b) / pts.length;
    return (lat, lon);
  }

  Future<void> _draw() async {
    final c = _controller;
    if (c == null) {
      return;
    }
    await c.clearLines();
    await c.clearCircles();
    _circleIds.clear();
    for (final l in widget.lines.where((l) => l.points.length >= 2)) {
      await c.addLine(
        LineOptions(
          geometry: [for (final p in l.points) LatLng(p[1], p[0])],
          lineColor: _hex(l.color),
          lineWidth: l.width,
          lineOpacity: l.dashed ? 0.7 : 0.95,
          lineJoin: 'round',
        ),
      );
    }
    for (final p in widget.points) {
      final circle = await c.addCircle(
        CircleOptions(
          geometry: LatLng(p.lat, p.lon),
          circleRadius: p.radius,
          circleColor: _hex(p.color),
          circleStrokeColor: '#ffffff',
          circleStrokeWidth: 2,
        ),
      );
      _circleIds[circle.id] = p.id;
    }
    await _fit();
  }

  Future<void> _fit() async {
    final c = _controller;
    final coords = [
      for (final p in widget.points) LatLng(p.lat, p.lon),
      for (final l in widget.lines)
        for (final pt in l.points) LatLng(pt[1], pt[0]),
    ];
    if (c == null || coords.length < 2 || widget.center != null) {
      return;
    }
    final sw = LatLng(
      coords.map((e) => e.latitude).reduce(math.min),
      coords.map((e) => e.longitude).reduce(math.min),
    );
    final ne = LatLng(
      coords.map((e) => e.latitude).reduce(math.max),
      coords.map((e) => e.longitude).reduce(math.max),
    );
    await c.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(southwest: sw, northeast: ne),
        left: 40,
        right: 40,
        top: 40,
        bottom: 40,
      ),
      duration: IzMotion.of(context, IzMotion.normal),
    );
  }

  @override
  void didUpdateWidget(covariant TransitMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.lines != widget.lines || oldWidget.points != widget.points) {
      unawaited(_draw());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!ref.watch(mapsEnabledProvider)) {
      return Semantics(
        label: widget.semanticLabel,
        child: ColoredBox(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: Center(
            child: Icon(Icons.map_outlined, color: Theme.of(context).colorScheme.outline),
          ),
        ),
      );
    }
    final (lat, lon) = _initialCenter;
    return Semantics(
      label: widget.semanticLabel,
      child: MapLibreMap(
        styleString: ref.watch(appConfigProvider).mapStyleUrl,
        initialCameraPosition: CameraPosition(target: LatLng(lat, lon), zoom: widget.zoom),
        myLocationEnabled: widget.showMyLocation,
        compassEnabled: false,
        rotateGesturesEnabled: false,
        tiltGesturesEnabled: false,
        onMapCreated: (c) {
          _controller = c;
          c.onCircleTapped.add((circle) {
            final id = _circleIds[circle.id];
            if (id != null) {
              widget.onPointTap?.call(id);
            }
          });
        },
        onStyleLoadedCallback: _draw,
        onMapClick: widget.onMapTap == null
            ? null
            : (_, latLng) => widget.onMapTap!(latLng.latitude, latLng.longitude),
      ),
    );
  }
}
