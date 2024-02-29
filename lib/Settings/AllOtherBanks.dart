import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import '../model/BankInfo.dart';
import 'ConfirmationPage.dart';

class AllOtherBanks extends StatefulWidget {
  @override
  _AllOtherBanksState createState() => _AllOtherBanksState();
}

class _AllOtherBanksState extends State<AllOtherBanks> {
  late List<BankInfo> _otherBanks;
  List<BankInfo>? _filteredBanks;

  @override
  void initState() {
    super.initState();
    _otherBanks = OtherBank.otherbanks();
    _filteredBanks = List.from(_otherBanks);
  }

  Widget _buildSearchField() {
    return Container(
      height: 50.0,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: TextField(
        onChanged: _searchBanks,
        decoration: const InputDecoration(
          hintText: 'Search Other Banks',
          hintStyle: TextStyle(color: Colors.black12, fontSize: 16.0),
          suffixIcon: Icon(Icons.search, color: Colors.blue),
          border: InputBorder.none,
        ),
        style: const TextStyle(color: Colors.blue, fontSize: 16.0),
        cursorColor: Colors.blue,
        keyboardAppearance: Brightness.dark,
      ),
    );
  }

  Widget _buildContent() {
    if (_filteredBanks == null) {
      return const Center(child: CircularProgressIndicator());
    } else if (_filteredBanks!.isEmpty) {
      return const Center(child: Text('No bank found.'));
    } else {
      return Column(
        children: [
          const SizedBox(height: 10.0),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _filteredBanks!.length,
            itemBuilder: (context, index) {
              BankInfo bank = _filteredBanks!.elementAt(index);
              return Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      ConfirmationPage().launch(context);
                    },
                    child: Container(
                      height: 50.0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border:
                            Border.all(color: Colors.transparent, width: 1.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: AssetImage(bank.logoPath),
                              radius: 20,
                            ),
                            SizedBox(width: 10.0),
                            Text(
                              bank.name,
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                ],
              );
            },
          ),
        ],
      );
    }
  }

  void _searchBanks(String query) {
    setState(() {
      _filteredBanks = _otherBanks
          .where(
              (bank) => bank.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Other Banks',
              style: TextStyle(
                  color: Colors.purple,
                  fontSize: 21,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
        _buildSearchField(),
        Expanded(child: _buildContent()),
      ],
    );
  }
}
