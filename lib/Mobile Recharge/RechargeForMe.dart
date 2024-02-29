import 'package:flutter/material.dart';

import '../User Model/RecentRecharge.dart';

class RechargeForMe extends StatefulWidget {
  final bool rechargeForSelf;

  const RechargeForMe({Key? key, required this.rechargeForSelf})
      : super(key: key);

  @override
  _RechargeForMeState createState() => _RechargeForMeState();
}

class _RechargeForMeState extends State<RechargeForMe> {
  String? price;
  double rechargeAmount = 0.0;

  bool recentBundlesExpanded = true;
  bool availableBundlesExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          keyboardType: TextInputType.number,
          onChanged: (value) {
            setState(() {
              price = value;
            });
          },
          decoration: InputDecoration(
            labelText: 'Recharge Amount',
            prefixIcon: Icon(Icons.monetization_on),
            suffix: IconButton(
              onPressed: () {
                setState(() {
                  price = null; // or set to the desired default value
                });
              },
              icon: const Icon(Icons.clear),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter the recharge amount';
            }
            return null;
          },
          controller: TextEditingController(text: price),
        ),
        SizedBox(height: 16),
        _buildBundlesExpansionPanel(),
        // Add other widgets as needed
      ],
    );
  }

  Widget _buildBundlesExpansionPanel() {
    return ExpansionPanelList(
      elevation: 1,
      expandedHeaderPadding: EdgeInsets.zero,
      dividerColor: Colors.transparent,
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          if (index == 0) {
            recentBundlesExpanded = !recentBundlesExpanded;
          } else if (index == 1) {
            availableBundlesExpanded = !availableBundlesExpanded;
          }
        });
      },
      children: [
        ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return const ListTile(
              title: Text(
                'Recent Bundles',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            );
          },
          body: _buildBundlesGrid(recentBundlesList),
          isExpanded: recentBundlesExpanded,
        ),
        ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return const ListTile(
              title: Text(
                'Available Bundles',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            );
          },
          body: _buildBundlesGrid(availableBundlesList),
          isExpanded: availableBundlesExpanded,
        ),
      ],
    );
  }

  Widget _buildBundlesGrid(List<Bundle> bundlesList) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).size.width ~/ 90,
        crossAxisSpacing: 8,
        mainAxisSpacing: 16,
      ),
      itemCount: bundlesList.length,
      itemBuilder: (context, index) {
        return Container(
          width: 70, // Define the width
          height: 70, // Define the height
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(35),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(35),
              child: InkWell(
                onTap: () {
                  setState(() {
                    price = bundlesList[index].price;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        bundlesList[index].name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '\$${bundlesList[index].price}',
                        style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
