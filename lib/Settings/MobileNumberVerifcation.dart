import 'package:flutter/material.dart';
import 'package:mobile_number/mobile_number.dart';

class CarriersPage extends StatefulWidget {
  @override
  _CarriersPageState createState() => _CarriersPageState();
}

class _CarriersPageState extends State<CarriersPage> {
  List<SimCard> _simCards = [];

  @override
  void initState() {
    super.initState();
    _loadSimCards();
  }

  Future<void> _loadSimCards() async {
    if (!await MobileNumber.hasPhonePermission) {
      await MobileNumber.requestPhonePermission;
      return;
    }
    _simCards = (await MobileNumber.getSimCards)!;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Choose Operator',
              style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.blue,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: Padding(
            padding: EdgeInsets.all(16),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.white,
              child: _buildBody(),
            )));
  }

  Widget _buildBody() {
    if (_simCards.isEmpty) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _simCards.length,
        itemBuilder: (context, index) {
          SimCard simCard = _simCards[index];
          return Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: GestureDetector(
                onTap: () => _onSimCardTap(simCard),
                child: Hero(
                  tag: 'simCard$index',
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.sim_card_outlined,
                        color: Colors.blue,
                        size: 150,
                      ),
                      Text('SIM ${index + 1}',
                          style: TextStyle(color: Colors.red)),
                      Text(
                        '${simCard.carrierName}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      SizedBox(height: 4),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    }
  }

  void _onSimCardTap(SimCard simCard) {
    // Simulate loading screen
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Verifying phone number...'),
            ],
          ),
        );
      },
    );

    // Simulate successful verification
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pop(context); // Close the loading screen
      _navigateToDemoPage(simCard);
    });
  }

  void _navigateToDemoPage(SimCard simCard) {
    //  Navigator.push(
    //  context,
    //   MaterialPageRoute(
    //     builder: (context) => ConfirmationPage(simCard: simCard),
    //    ),
    //  );
  }
}
