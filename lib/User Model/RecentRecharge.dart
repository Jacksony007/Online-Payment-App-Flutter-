class RecentRecharge {
  final String name;
  final String phoneNumber;

  RecentRecharge({
    required this.name,
    required this.phoneNumber,
  });
}

List<RecentRecharge> recentRechargeList = [
  RecentRecharge(
    name: 'Ruthy William',
    phoneNumber: '123456789',
  ),
  RecentRecharge(
    name: 'John Smith',
    phoneNumber: '987654321',
  ),
  // Add more recent recharge models as needed
];

class Bundle {
  final String name;
  final String price;

  Bundle({
    required this.name,
    required this.price,
  });
}

List<Bundle> recentBundlesList = [
  Bundle(name: '1 GB', price: '10.00'),
  Bundle(name: '2 GB', price: '15.00'),
  Bundle(name: '5 GB', price: '25.00'),
];

List<Bundle> availableBundlesList = [
  Bundle(name: '3 GB', price: '20.00'),
  Bundle(name: '10 GB', price: '30.00'),
  Bundle(name: 'Unlimited', price: '50.00'),
];
