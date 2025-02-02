import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:imaginecup/core/data/remote/place_detail_card_dto.dart';
import 'package:imaginecup/core/locator.dart';
import 'package:imaginecup/core/services/azure_service.dart';
import 'package:imaginecup/core/services/geocoding_service.dart';
import 'package:imaginecup/core/services/place_image_service.dart';
import 'package:imaginecup/core/services/trip_db_service.dart';
import 'package:imaginecup/models/trip.dart';
import 'package:imaginecup/utils/snackbar.dart';

class CreateTripScreen extends StatefulWidget {
  const CreateTripScreen({super.key});

  @override
  State<CreateTripScreen> createState() => _CreateTripScreenState();
}

class _CreateTripScreenState extends State<CreateTripScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _fromController = TextEditingController();
  final _toController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _peopleCountController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;

  // Ana tema renkleri
  final Color primaryColor = const Color(0xFFFF9800);
  final Color secondaryColor = const Color(0xFFFFB74D);
  final Color accentColor = const Color(0xFFFFD54F);

  @override
  void dispose() {
    _nameController.dispose();
    _fromController.dispose();
    _toController.dispose();
    _descriptionController.dispose();
    _peopleCountController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2026),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: primaryColor),
      prefixIcon: Icon(icon, color: primaryColor),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: primaryColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: primaryColor.withOpacity(0.5)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: primaryColor, width: 2),
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.4),
      body: Center(
        child: Container(
          width: MediaQuery.sizeOf(context).width * 0.9,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withOpacity(0.2),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.flight_takeoff,
                    size: 48,
                    color: primaryColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Create Your Journey",
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _nameController,
                    decoration: _buildInputDecoration('Trip Name', Icons.tour),
                    validator: (value) => value?.isEmpty ?? true
                        ? 'Please enter a trip name'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _fromController,
                    decoration: _buildInputDecoration(
                        'From Where', Icons.flight_takeoff),
                    validator: (value) => value?.isEmpty ?? true
                        ? 'Please enter starting point'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _toController,
                    decoration:
                        _buildInputDecoration('To Where', Icons.flight_land),
                    validator: (value) => value?.isEmpty ?? true
                        ? 'Please enter destination'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: primaryColor.withOpacity(0.5)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: ListTile(
                            leading:
                                Icon(Icons.calendar_today, color: primaryColor),
                            title: Text('Start Date',
                                style: TextStyle(color: primaryColor)),
                            subtitle: Text(
                              _startDate?.toString().split(' ')[0] ??
                                  'Select date',
                              style: TextStyle(
                                color: _startDate != null
                                    ? Colors.black87
                                    : Colors.grey,
                              ),
                            ),
                            onTap: () => _selectDate(context, true),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            leading:
                                Icon(Icons.calendar_month, color: primaryColor),
                            title: Text('End Date',
                                style: TextStyle(color: primaryColor)),
                            subtitle: Text(
                              _endDate?.toString().split(' ')[0] ??
                                  'Select date',
                              style: TextStyle(
                                color: _endDate != null
                                    ? Colors.black87
                                    : Colors.grey,
                              ),
                            ),
                            onTap: () => _selectDate(context, false),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _peopleCountController,
                    decoration:
                        _buildInputDecoration('Number of People', Icons.group),
                    keyboardType: TextInputType.number,
                    validator: (value) => value?.isEmpty ?? true
                        ? 'Please enter number of people'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    decoration:
                        _buildInputDecoration('Description', Icons.description),
                    maxLines: 3,
                    validator: (value) => value?.isEmpty ?? true
                        ? 'Please enter a description'
                        : null,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            _onCreateTrip();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 2,
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add, size: 20),
                            SizedBox(width: 8),
                            Text('Create Trip'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onCreateTrip() async {
    int days = _endDate!.difference(_startDate!).inDays;
    final tripDoc = await getIt<AzureService>()
        .createAITrip(_toController.text.trim(), days);
    if (tripDoc == null) {
      showCustomSnackBar(context, "Try again later", Colors.white,
          Colors.redAccent, Icon(Icons.error));
      return;
    }
    List<Map<String, dynamic>> latLngs = [];
    try {
      for (int i = 1; i < days + 1; i++) {
        //day1, day2, day3, ...
        Map<String, dynamic>? tripOfDay = tripDoc["day$i"];
        if (tripOfDay == null) {
          break;
        }
        final geoService = GeocodingService();
        final latLngResults = await Future.wait([
          for (Map<String, dynamic> place in tripOfDay["places"])
            geoService.getLatLongFromAddress(place["name"], _toController.text)
        ]);

        for (Map<String, dynamic>? latlng in latLngResults) {
          if (latlng != null) {
            latLngs.add({
              "name": latlng["name"],
              "latlng": LatLng(latlng["latitude"]!, latlng["longitude"]!)
            });
          }
        }
      }
      if (latLngs.isEmpty) {
        Navigator.pop(context);
        return;
      }
      final trip = Trip(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: _nameController.text.trim(),
          description: _descriptionController.text,
          route: latLngs,
          ownerId: FirebaseAuth.instance.currentUser!.uid,
          fromWhere: _fromController.text,
          toWhere: _toController.text,
          startDate: Timestamp.fromDate(_startDate!),
          endDate: Timestamp.fromDate(_endDate!),
          peopleCount: int.parse(_peopleCountController.text),
          generatedTour: tripDoc);
      await getIt<TripDbService>().addTrip(trip);

      Navigator.pop(context);
    } catch (e) {
      Navigator.pop(context);
      print(e);
      showCustomSnackBar(context, "An error occured!", Colors.white,
          Colors.redAccent, Icon(Icons.error));
    }
  }
}
