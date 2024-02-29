import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import '../Controller/UserDetails.dart';
import '../Controller/UserFinancialData.dart';
import '../Inner Screen/AdvertisementRow.dart';
import '../User Model/user_financial_model.dart';
import '../model/FlightAdvertisement.dart';
import '../User Model/TransactionHistory.dart';
import '../utils/BankingColors.dart';
import '../utils/BankingContants.dart';
import '../utils/BankingImages.dart';

class BalancePage extends StatefulWidget {
  String userId;

  BalancePage({required this.userId, Key? key}) : super(key: key);

  @override
  _BalancePageState createState() => _BalancePageState();
}

class _BalancePageState extends State<BalancePage> {
  FirebaseService firebaseService = FirebaseService();

  UserFinancialModel? userFinancialDetails;

  BankInfo? bankInfoData;

  @override
  void initState() {
    super.initState();
    GetBalance();
  }

  String toTitleCase(String text) {
    return text.toLowerCase().split(' ').map((word) {
      if (word.isNotEmpty) {
        return word[0].toUpperCase() + word.substring(1);
      } else {
        return '';
      }
    }).join(' ');
  }

  Future<void> GetBalance() async {
    String userId = widget.userId;

    if (userId != null && userId.isNotEmpty) {
      try {
        DocumentSnapshot<Map<String, dynamic>> snapshot =
            await FirebaseFirestore.instance
                .collection('bank_info')
                .doc(userId)
                .get();

        if (snapshot.exists) {
          var balanceData = snapshot.data();

          double balance = balanceData?['balance']?.toDouble() ?? 0.0;

          bankInfoData = BankInfo(
            pin: balanceData?['pin'],
            balance: balance,
            userId: balanceData?['userId'],
            isActive: balanceData?['isActive'],
          );

          setState(() {});
        }
      } catch (e) {
        print('Error fetching bank details: $e');
      }
    } else {
      print('userId is null or empty');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Cards',
            style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.all(16),
                child: Stack(
                  children: [
                    Image.asset(
                      Banking_ic_CardImage,
                      fit: BoxFit.cover,
                      height: 200,
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              StreamBuilder<UserFinancialModel?>(
                                  stream:
                                      firebaseService.streamUserFinancialData(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      UserFinancialModel financialData =
                                          snapshot.data!;
                                      return Text(
                                        financialData.accountName ??
                                            'No Account Linked',
                                        style: boldTextStyle(
                                          color: Banking_whitePureColor,
                                          size: 18,
                                          fontFamily: fontMedium,
                                        ),
                                      ).paddingOnly(
                                        top: spacing_large,
                                        left: spacing_standard_new,
                                      );
                                    } else
                                      return Text(
                                        'No Account Linked',
                                        style: boldTextStyle(
                                          color: Banking_whitePureColor,
                                          size: 18,
                                          fontFamily: fontMedium,
                                        ),
                                      ).paddingOnly(
                                        top: spacing_large,
                                        left: spacing_standard_new,
                                      );
                                  }),
                              Text(
                                "PayFlow App",
                                style: boldTextStyle(
                                  color: Banking_whitePureColor,
                                  size: 16,
                                  fontFamily: fontMedium,
                                ),
                              ).paddingOnly(
                                top: spacing_large,
                                right: spacing_standard_new,
                              ),
                            ],
                          ),
                          StreamBuilder<UserFinancialModel?>(
                              stream: firebaseService.streamUserFinancialData(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  UserFinancialModel financialData =
                                      snapshot.data!;
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        financialData.bankName ?? '',
                                        style: boldTextStyle(
                                          color: Banking_whitePureColor,
                                          size: 18,
                                          fontFamily: fontMedium,
                                        ),
                                      ).paddingOnly(
                                        top: spacing_large,
                                        left: spacing_standard_new,
                                      ),
                                      Text(
                                        financialData.accountNumber ?? '',
                                        style: boldTextStyle(
                                          color: Banking_whitePureColor,
                                          size: 18,
                                          fontFamily: fontMedium,
                                        ),
                                      ).paddingOnly(
                                        top: spacing_large,
                                        left: spacing_standard_new,
                                      ),
                                    ],
                                  );
                                } else
                                  return Text(
                                    'No Account Linked',
                                    style: boldTextStyle(
                                      color: Banking_whitePureColor,
                                      size: 18,
                                      fontFamily: fontMedium,
                                    ),
                                  ).paddingOnly(
                                    top: spacing_large,
                                    left: spacing_standard_new,
                                  );
                              }),
                          Text(
                            '${bankInfoData?.balance.toString() ?? '0.00'} \$',
                            style: boldTextStyle(
                              color: Banking_whitePureColor,
                              size: 18,
                              fontFamily: fontMedium,
                            ),
                          ).paddingOnly(
                            top: spacing_standard,
                            left: spacing_standard_new,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Add Transaction History
            Container(
              margin: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Transaction History',
                    style: boldTextStyle(
                      color: Banking_blackColor,
                      size: 20,
                      fontFamily: fontMedium,
                    ),
                  ).paddingOnly(bottom: spacing_standard_new),
                  if (transactions.isNotEmpty)
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: transactions.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(transactions[index].type),
                          subtitle: Text(transactions[index].date),
                          trailing: Text(transactions[index].amount),
                        );
                      },
                    ),
                  if (transactions.isEmpty)
                    Text(
                      'No transactions yet.',
                      style: TextStyle(
                        color: Banking_blackColor,
                        fontSize: 16,
                      ),
                    ),
                ],
              ),
            ),
            Padding(
                padding: EdgeInsets.all(26),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Investments for you',
                      style: TextStyle(
                        color: Banking_blackColor,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    AdvertisementRow(advertisements: busAdvertisementList),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
