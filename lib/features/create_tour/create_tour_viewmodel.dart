class CreateTourViewmodel {
  Map<String, dynamic>? _tourData;

  void setTourData(Map<String, dynamic> data) {
    _tourData = data;
  }

  Map<String, dynamic>? getTourData() {
    return _tourData;
  }
}
