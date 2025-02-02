import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:imaginecup/models/trip.dart';

class RouteGmaps extends StatefulWidget {
  final Trip trip;
  final String? focusedPlace;
  const RouteGmaps({super.key, required this.trip, this.focusedPlace});

  @override
  State<RouteGmaps> createState() => _RouteGmapsState();
}

class _RouteGmapsState extends State<RouteGmaps> {
  late final CameraPosition initialCameraPosition;
  late GoogleMapController _mapController;
  Set<Polyline> _polylines = {};

  LatLng getInitialLatLng() {
    double lat = 0;
    double long = 0;
    for (var place in widget.trip.route) {
      lat += place["latlng"].latitude;
      long += place["latlng"].longitude;
    }
    lat = lat / widget.trip.route.length;
    long = long / widget.trip.route.length;
    return LatLng(lat, long);
  }

  void _createPolylines() {
    List<LatLng> polylineCoordinates = [];
    for (var place in widget.trip.route) {
      polylineCoordinates.add(place["latlng"]);
    }

    _polylines.add(
      Polyline(
        polylineId: const PolylineId('route'),
        points: polylineCoordinates,
        color: Colors.blue,
        width: 3,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    final focusedLatLng = widget.focusedPlace != null
        ? widget.trip.route.singleWhere(
            (element) => element["name"] == widget.focusedPlace)["latlng"]
        : null;
    initialCameraPosition = CameraPosition(
      target: focusedLatLng ?? getInitialLatLng(),
      zoom: 12,
    );
    _createPolylines();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: initialCameraPosition,
      markers: widget.trip.route.map((place) {
        final isFocused = place["name"] == widget.focusedPlace;
        return Marker(
          markerId: MarkerId(place["name"]),
          position: place["latlng"],
          infoWindow: InfoWindow(title: place["name"]),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            isFocused ? BitmapDescriptor.hueRed : BitmapDescriptor.hueAzure,
          ),
        );
      }).toSet(),
      polylines: _polylines,
      mapToolbarEnabled: false,
      zoomControlsEnabled: false,
      onMapCreated: (controller) {
        _mapController = controller;
        if (widget.focusedPlace != null) {
          final focusedLocation = widget.trip.route.singleWhere(
            (element) => element["name"] == widget.focusedPlace,
          )["latlng"];
          _mapController.animateCamera(
            CameraUpdate.newLatLngZoom(focusedLocation, 14),
          );
        }
      },
    );
  }
}
