import 'package:flutter/material.dart';

class FeatureItem {
  final String title;
  final String imagePath; // Add this field for image or SVG path
  final Color? color; // Add this field for color

  FeatureItem(this.title, this.imagePath, {this.color});

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
          // Implement your navigation logic
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
                  width: 42.0,
                  height: 42.0,
                )
                    : ColorFiltered(
                  colorFilter: const ColorFilter.mode(
                    Colors
                        .green, // Apply green color filter for other items
                    BlendMode.srcIn,
                  ),
                  child: Image.asset(
                    featureItem.imagePath,
                    width: 42.0,
                    height: 42.0,
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