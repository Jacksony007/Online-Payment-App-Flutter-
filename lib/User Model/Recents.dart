class RecentModel {
  final String name;
  final String picture;
  final String upiId;

  RecentModel({
    required this.name,
    required this.picture,
    required this.upiId,
  });
}

List<RecentModel> recentList = [

  RecentModel(
    name: 'Ruty Korkor',
    picture: 'images/banking/Ruthy.jpg',
    upiId: 'john.doe@upi',
  ),
  RecentModel(
    name: 'John Smith',
    picture: 'images/banking/Banking_ic_user1.jpeg',
    upiId: 'jane.smith@upi',
  ),
  // Add more recent models as needed
];
