import 'package:imaginecup/core/data/remote/place_detail_card_dto.dart';
import 'package:imaginecup/core/locator.dart';
import 'package:imaginecup/core/services/azure_service.dart';
import 'package:imaginecup/core/services/place_image_service.dart';
import 'package:imaginecup/core/services/trip_db_service.dart';
import 'package:imaginecup/models/trip.dart';

class TourViewModel {
  Trip? _trip;
  List<Map<String, dynamic>> _culturalInfo = [];

  set trip(Trip trip) {
    _trip = trip;
  }

  set culturalInfo(List<Map<String, dynamic>> culturalInfo) {
    _culturalInfo = culturalInfo;
  }

  List<Map<String, dynamic>> get culturalInfo => _culturalInfo;

  Trip get trip => _trip!;

  String? _focusedPlace;

  set focusedPlace(String place) {
    _focusedPlace = place;
  }

  get getFocusedPlace => _focusedPlace;

  Future<List<PlaceDetailCardDto>> getDetails() async {
    final tripDbService = getIt<TripDbService>();

    //check firestore first
    final detailsFirestore =
        await tripDbService.getPlaceDetailsFirestore(trip.id);
    if (detailsFirestore != null) {
      return detailsFirestore;
    }

    // if firestore has no details, get details from azure
    // get details and urls
    final details = await getIt<AzureService>()
        .getPlaceDetails(trip.getPlaces(), trip.toWhere);
    final urls = await PlaceImageService().getUrlsFromPlaceList(details
            ?.map(
              (e) => e["header"]!,
            )
            .toList() ??
        []);

    List<PlaceDetailCardDto> detailsList = [];
    for (var urlMap in urls) {
      final placeName = urlMap["placeName"]!;
      final detail = details?.singleWhere(
        (element) => element["header"] == placeName,
      );
      final url = urlMap["imageUrl"];

      if (detail != null && url != null) {
        detailsList.add(PlaceDetailCardDto(
            title: detail["header"]!,
            description: detail["details"]!,
            imageUrl: url));
      }
    }
    // add details to firestore
    await tripDbService.addPlaceDetails(detailsList, trip.id);

    //finally, return the details
    return detailsList;
  }
}
