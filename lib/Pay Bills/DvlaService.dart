class DvlaService {
  final int id;
  final String name;

  // final String imagePath;

  DvlaService({required this.id, required this.name});
}

class DvlaServiceList {
  static List<DvlaService> getServices() {
    return [
      DvlaService(
        id: 1,
        name: 'Vehicle Registration',
      ),
      DvlaService(id: 2, name: 'Driver Licensing'),
      DvlaService(id: 3, name: 'Change of Ownership'),
      DvlaService(id: 4, name: 'Foreign Licence Conversion'),
      DvlaService(id: 5, name: 'International License'),
      DvlaService(id: 6, name: 'Replacement of License'),
    ];
  }
}
