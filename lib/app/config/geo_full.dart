import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parental_control/common_widgets/show_logger.dart';
import 'package:parental_control/services/api_path.dart';
import 'package:parental_control/services/auth.dart';
import 'package:parental_control/services/database.dart';
import 'package:parental_control/services/geo_locator_service.dart';
import 'package:parental_control/utils/constants.dart';
import 'package:provider/provider.dart';

class GeoFull extends StatefulWidget {
  final Position initialPosition;
  final Database database;
  final AuthBase auth;
  final GeoLocatorService geo;

  GeoFull(this.initialPosition, this.database, this.auth, this.geo);

  static Widget create(
    BuildContext context, {
    required Position position,
    required Database database,
    required AuthBase auth,
  }) {
    final geoService = Provider.of<GeoLocatorService>(
      context,
      listen: false,
    );

    return GeoFull(
      position,
      database,
      auth,
      geoService,
    );
  }

  @override
  State<StatefulWidget> createState() => _GeoFullState();
}

class _GeoFullState extends State<GeoFull> {
  final Completer<GoogleMapController> _controller = Completer();

  late List<Marker> allMarkers = [];
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  late User _currentUser;
  var imageData;

  @override
  void initState() {
    _currentUser = widget.auth.currentUser!;
    widget.geo.getCurrentLocation.listen((position) {
      _centerScreen(position);
    });
    _getAllChildLocations();
    super.initState();
  }

  Future<Uint8List> _getChildMarkerImage(String data) async {
    var bytes = (await NetworkAssetBundle(Uri.parse(data)).load(data))
        .buffer
        .asUint8List();

    return bytes;
  }

  void _getAllChildLocations() async {
    await FirebaseFirestore.instance
        .collection(APIPath.children(_currentUser.uid))
        .get()
        .then((document) async {
      if (document.docs.isNotEmpty) {
        for (var element in document.docs) {
          await _initMarker(element.data());
        }
      }
    });
  }

  Future<List<Marker>> _initMarker(Map<String, dynamic> data) async {
    if (data['position'] == null) {
      allMarkers.clear();
      return [];
    }

    allMarkers.add(
      Marker(
        infoWindow: InfoWindow(
          title: data['id'],
          snippet: data['name'],
        ),
        markerId: MarkerId(data['id']),
        icon: BitmapDescriptor.fromBytes(
          await _getChildMarkerImage(data['image']),
        ),
        draggable: false,
        position: LatLng(
          data['position'].latitude,
          data['position'].longitude,
        ),
      ),
    );
    if (allMarkers.isEmpty) return [];
    if (!mounted) return [];
    setState(() {
      markers[MarkerId(
        allMarkers.first.markerId.value,
      )] = allMarkers.first;
    });
    JHLogger.$.d(allMarkers.length);

    return allMarkers;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      child: Center(
        child: GoogleMap(
          key: Keys.googleMapKeys,
          initialCameraPosition: CameraPosition(
            target: LatLng(
              widget.initialPosition.latitude,
              widget.initialPosition.longitude,
            ),
            zoom: 15,
          ),
          mapType: MapType.terrain,
          myLocationEnabled: true,
          markers: Set<Marker>.of(allMarkers),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
            if (allMarkers.isEmpty) return;
            setState(() {
              final markerId = MarkerId(allMarkers.first.markerId.value);
              markers[markerId] = allMarkers.first;
            });
          },
        ),
      ),
    );
  }

  Future<void> _centerScreen(Position position) async {
    final controller = await _controller.future;
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 16.0,
        ),
      ),
    );
  }
}
