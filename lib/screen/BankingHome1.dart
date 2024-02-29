import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:free_flutter_ui_kits/model/AdvertisementModel.dart';
import 'package:free_flutter_ui_kits/screen/AuthenticatedBankingShareScreen.dart';
import 'package:free_flutter_ui_kits/utils/BankingColors.dart';
import 'package:free_flutter_ui_kits/utils/BankingContants.dart';
import 'package:free_flutter_ui_kits/utils/BankingFeaturedItems.dart';
import 'package:free_flutter_ui_kits/utils/BankingImages.dart';
import 'package:nb_utils/nb_utils.dart';
import '../Controller/UserDetails.dart';
import '../Inner Screen/AdvertisementCarousel.dart';
import '../Mapping/FeaturePageMapping.dart';
import '../User Model/user_financial_model.dart';
import '../User Model/user_model.dart';

class BankingHome1 extends StatefulWidget {
  static String tag = '/BankingHome1';

  const BankingHome1({Key? key}) : super(key: key);

  @override
  BankingHome1State createState() => BankingHome1State();
}

class BankingHome1State extends State<BankingHome1> {
  @override
  void initState() {
    super.initState();
  }

  UserModel? userData;

  UserFinancialModel? financialData;
  FirebaseService firebaseService = FirebaseService();

  void _copyToClipboard(String? text) {
    Clipboard.setData(ClipboardData(text: text ?? ''));
    Fluttertoast.showToast(
      msg: 'Copied to clipboard',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.grey,
      textColor: Colors.white,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 240,
              floating: false,
              pinned: true,
              titleSpacing: 0,
              automaticallyImplyLeading: false,
              backgroundColor:
                  innerBoxIsScrolled ? Colors.blue : Banking_app_Background,
              actionsIconTheme: const IconThemeData(opacity: 0.0),
              title: Container(
                padding: const EdgeInsets.fromLTRB(16, 33, 16, 32),
                margin: const EdgeInsets.only(bottom: 4, top: 4),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  AuthenticatedBankingShareScreen()),
                        );
                      },
                      child: StreamBuilder<UserModel?>(
                        stream: firebaseService.streamUserData(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            userData = snapshot.data!;
                            return CircleAvatar(
                              backgroundImage: userData?.photoURL != null &&
                                      userData!.photoURL!.isNotEmpty
                                  ? AssetImage(userData!.photoURL!)
                                  : AssetImage(DefaultPicture),
                              radius: 25,
                            );
                          } else {
                            return CircleAvatar(
                              backgroundImage: AssetImage(DefaultPicture),
                              radius: 25,
                            );
                          }
                        },
                      ),
                    ),
                    15.width,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        StreamBuilder<UserModel?>(
                          stream: firebaseService.streamUserData(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              userData = snapshot.data!;
                              return Text(
                                  "Hello, ${userData?.displayName ?? 'User'}",
                                  style: primaryTextStyle(
                                      color: Banking_TextColorWhite,
                                      size: 16,
                                      fontFamily: fontRegular));
                            } else {
                              return Text("Hello, User",
                                  style: primaryTextStyle(
                                      color: Banking_TextColorWhite,
                                      size: 16,
                                      fontFamily: fontRegular));
                            }
                          },
                        )
                      ],
                    ).expand(),
                    const Icon(Icons.notifications,
                        size: 30, color: Banking_whitePureColor)
                  ],
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  height: 180,
                  padding: const EdgeInsets.only(
                      left: 8, right: 8, top: 2, bottom: 2),
                  child: AdvertisementCarousel(
                    advertisementList: advertisementList,
                  ),
                ),
              ),
            )
          ];
        },
        body: SingleChildScrollView(
          child: Container(
            padding:
                const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 2),
            color: Banking_app_Background,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: 1,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                          padding: const EdgeInsets.all(8),
                          decoration: boxDecorationRoundedWithShadow(
                            8,
                            backgroundColor: Banking_whitePureColor,
                            spreadRadius: 0,
                            blurRadius: 0,
                          ),
                          child: StreamBuilder<UserFinancialModel?>(
                            stream: firebaseService.streamUserFinancialData(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                UserFinancialModel financialData =
                                    snapshot.data!;
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Display payflowId if available
                                    Text(
                                      '${financialData.payflowId ?? 'Link Bank your Account'}',
                                      style: primaryTextStyle(
                                        size: 14,
                                        color: Colors.blue,
                                        fontFamily: fontMedium,
                                      ),
                                    ).paddingRight(10),

                                    // Show icon only if payflowId is available
                                    if (financialData.payflowId != null)
                                      GestureDetector(
                                        onTap: () {
                                          // Copy the text to clipboard and show toast
                                          _copyToClipboard(
                                              '${financialData.payflowId ?? ''}');
                                        },
                                        child: Icon(
                                          Icons.copy_outlined,
                                          size: 20,
                                          color: Colors.blue,
                                        ),
                                      ),
                                  ],
                                );
                              } else {
                                return Text(
                                  'Link Bank your Account',
                                  style: primaryTextStyle(
                                    size: 14,
                                    color: Colors.blue,
                                    fontFamily: fontMedium,
                                  ),
                                );
                              }
                            },
                          ));
                    }),

                const Divider(),
                // Add your featured class content here
                _buildCategory(
                    context,
                    'General Payment',
                    [
                      FeatureItem(
                          'Scan To Pay', "images/banking/Scan Qr code.png"),
                      FeatureItem('Check Balance',
                          "images/banking/account-balance.png"),
                      FeatureItem('Pay to UPI', "images/banking/Upi.png"),
                      FeatureItem('Pay to Contact',
                          "images/banking/contact-details-svgrepo-com.png"),
                      FeatureItem('Pay to PhoneNumber',
                          "images/banking/dial-pad-svgrepo-com.png"),
                      FeatureItem(
                          'Bank Transfer', "images/banking/bank-transfer.png"),
                      FeatureItem('Wallet', "images/banking/wallet.png"),
                    ],
                    Colors.orange),
                _buildCategory(
                    context,
                    'Insurance',
                    [
                      FeatureItem('Family Insurance',
                          "images/banking/family-insurance-symbol-svgrepo-com.png"),
                      FeatureItem('Car Insurance',
                          "images/banking/car-insurance-svgrepo-com.png"),
                      FeatureItem('House Insurance',
                          "images/banking/house-insurance.png"),
                      FeatureItem('Health Insurance',
                          "images/banking/health_insurance.png"),
                      FeatureItem('Business Insurance',
                          "images/banking/business-insurance.png"),
                    ],
                    Banking_greenLightColor),
                _buildCategory(
                  context,
                  'Mobile Recharge',
                  [
                    FeatureItem('Tigo', "images/banking/Tigo.png",
                        color: Colors.blue),
                    FeatureItem('Airtel', "images/banking/airtel.png",
                        color: Colors.red),
                    FeatureItem('Vodacom', "images/banking/Vodacom.png",
                        color: Colors.red),
                    FeatureItem('Jio', "images/banking/jio.png",
                        color: Colors.indigo),
                    FeatureItem('MTN', "images/banking/Mtn.png",
                        color: Colors.transparent),
                    FeatureItem('Glo', "images/banking/glo.png",
                        color: Colors.transparent),
                  ],
                  Colors.purple,
                ),

                _buildCategory(
                    context,
                    'Transport',
                    [
                      FeatureItem('Flight Ticket',
                          "images/banking/plane-svgrepo-com.png"),
                      FeatureItem(
                          'Bus Ticket', "images/banking/bus-svgrepo-com.png"),
                      FeatureItem('Train Ticket',
                          "images/banking/train-subway-svgrepo-com.png"),
                      FeatureItem('Uber', "images/banking/car-svgrepo-com.png"),
                      FeatureItem('Ride', "images/banking/motorcycle_bike.png"),
                      FeatureItem(
                          'Auto Rickshaw', "images/banking/auto-ricksaw.png"),
                    ],
                    Colors.blue),
                _buildCategory(
                    context,
                    'Pay Bills',
                    [
                      FeatureItem('Electricity',
                          "images/banking/electricity-home-svgrepo-com.png"),
                      FeatureItem(
                          'Water', "images/banking/water-bill-svgrepo-com.png"),
                      FeatureItem('Fees',
                          "images/banking/graduation-cap-svgrepo-com.png"),
                      FeatureItem('Police', "images/banking/police-badge.png"),
                      FeatureItem('DVLA', "images/banking/car-svgrepo-com.png"),
                    ],
                    Colors.red),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategory(
    BuildContext context,
    String category,
    List<FeatureItem> features,
    Color categoryColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            category,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: categoryColor,
            ),
          ),
        ),
        _buildFeatureGrid(context, features),
      ],
    );
  }

  Widget _buildFeatureGrid(BuildContext context, List<FeatureItem> features) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double screenWidth = MediaQuery.of(context).size.width;
        int crossAxisCount = (screenWidth / 100).floor().clamp(1, 4).toInt();

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 1.0,
            mainAxisSpacing: 1.0,
          ),
          itemCount: features.length,
          itemBuilder: (context, index) {
            return _buildFeatureItem(context, features[index]);
          },
        );
      },
    );
  }

  Widget _buildFeatureItem(BuildContext context, FeatureItem featureItem) {
    return Card(
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10.0),
        onTap: () {
          FeaturePageMapping.navigateToPage(context, featureItem);
        },
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(8.0),
                // Use Image widget or SvgPicture.asset based on the file type
                child: featureItem.title == 'Tigo' ||
                        featureItem.title == 'Airtel' ||
                        featureItem.title == 'Vodacom' ||
                        featureItem.title == 'Jio' ||
                        featureItem.title == 'MTN' ||
                        featureItem.title == 'Glo'
                    ? Image.asset(
                        featureItem.imagePath,
                        width: 34.0,
                        height: 34.0,
                      )
                    : ColorFiltered(
                        colorFilter: const ColorFilter.mode(
                          Colors.blue,
                          BlendMode.srcIn,
                        ),
                        child: Image.asset(
                          featureItem.imagePath,
                          width: 34.0,
                          height: 34.0,
                        ),
                      ),
              ),
              const SizedBox(height: 4.0),
              Text(
                featureItem.title,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
