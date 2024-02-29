import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import '../model/BankInfo.dart';
import 'ConfirmationPage.dart';

class FeatureCategory extends StatelessWidget {
  final String category;
  final List<BankInfo> banks;
  final Color categoryColor;

  const FeatureCategory({
    required this.category,
    required this.banks,
    required this.categoryColor,
  });

  @override
  Widget build(BuildContext context) {
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
        FeatureGrid(banks: banks),
      ],
    );
  }
}

class FeatureGrid extends StatelessWidget {
  final List<BankInfo> banks;

  const FeatureGrid({required this.banks});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double screenWidth = MediaQuery.of(context).size.width;
        int crossAxisCount = (screenWidth / 130).floor().clamp(1, 3).toInt();

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 1.0,
            mainAxisSpacing: 1.0,
          ),
          itemCount: banks.length,
          itemBuilder: (context, index) {
            return FeatureItemWidget(bankInfo: banks[index]);
          },
        );
      },
    );
  }
}

class FeatureItemWidget extends StatelessWidget {
  final BankInfo bankInfo;

  const FeatureItemWidget({required this.bankInfo});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10.0),
        onTap: () {
          ConfirmationPage().launch(context);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  bankInfo.logoPath,
                  width: 34.0,
                  height: 34.0,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                bankInfo.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
