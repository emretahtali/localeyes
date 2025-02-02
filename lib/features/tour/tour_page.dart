import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imaginecup/core/data/remote/place_detail_card_dto.dart';
import 'package:imaginecup/core/locator.dart';
import 'package:imaginecup/features/tour/tour_viewmodel.dart';
import 'package:imaginecup/widgets/carousel_place_card.dart';
import 'package:imaginecup/widgets/route_gmaps.dart';
import 'package:intl/intl.dart';

class TourPage extends StatefulWidget {
  const TourPage({super.key});

  @override
  State<TourPage> createState() => _TourPageState();
}

class _TourPageState extends State<TourPage> {
  List<PlaceDetailCardDto>? placeDetails;
  int _currentCarouselIndex = 0;
  final double _minSheetSize = 0.3; // Minimum yükseklik oranı
  final double _maxSheetSize = 0.7; // Maksimum yükseklik oranı

  String _formatTimestamp(Timestamp timestamp) {
    final date = timestamp.toDate();
    return DateFormat('MMM dd, yyyy').format(date);
  }

  Future<void> getPlaceDetails() async {
    final data = await getIt<TourViewModel>().getDetails();
    setState(() {
      placeDetails = data;
    });
  }

  @override
  void initState() {
    super.initState();
    getPlaceDetails();
  }

  @override
  Widget build(BuildContext context) {
    final TourViewModel tourViewModel = getIt<TourViewModel>();
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Header Section
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tourViewModel.trip.name,
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: theme.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: theme.primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.flight_takeoff,
                                    size: 18,
                                    color: theme.primaryColor,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "${tourViewModel.trip.fromWhere} → ${tourViewModel.trip.toWhere}",
                                    style: GoogleFonts.inter(
                                      color: theme.primaryColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.orange.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_month,
                                    size: 18,
                                    color: Colors.orange,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${_formatTimestamp(tourViewModel.trip.startDate)} - ${_formatTimestamp(tourViewModel.trip.endDate)}',
                                    style: GoogleFonts.inter(
                                      color: Colors.orange,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Map Section - Expanded ile değil, Stack içinde
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: RouteGmaps(
                        trip: tourViewModel.trip,
                        focusedPlace: tourViewModel
                            .trip.route[_currentCarouselIndex]["name"],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Draggable Carousel Section
            DraggableScrollableSheet(
              initialChildSize: _minSheetSize,
              minChildSize: _minSheetSize,
              maxChildSize: _maxSheetSize,
              builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(28),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      children: [
                        // Drag Handle
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Container(
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),

                        // Places Carousel
                        SizedBox(
                            height: size.height * 0.6,
                            child: placeDetails == null
                                ? Center(child: CircularProgressIndicator())
                                : CarouselSlider(
                                    items: placeDetails!
                                        .map((detail) => CarouselPlaceCard(
                                            title: detail.title,
                                            description: detail.description,
                                            imageUrl: detail.imageUrl))
                                        .toList(),
                                    options: CarouselOptions(
                                      height: size.height * 0.55,
                                      enlargeCenterPage: true,
                                    ),
                                  )),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
