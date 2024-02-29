import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../User Model/RecentRecharge.dart';

class RechargeForOthers extends StatefulWidget {
  final bool rechargeForOther;

  const RechargeForOthers({Key? key, required this.rechargeForOther})
      : super(key: key);

  @override
  _RechargeForOthersState createState() => _RechargeForOthersState();
}

class _RechargeForOthersState extends State<RechargeForOthers> {
  String? phoneNumber;
  double rechargeAmount = 0.0;
  Iterable<Contact>? _contacts;
  List<Contact>? _filteredContacts;

  bool recentRechargesExpanded = true;
  bool selectContactExpanded = true;

  @override
  void initState() {
    super.initState();
    _getContacts();
  }

  Future<void> _getContacts() async {
    if (await Permission.contacts.request().isGranted) {
      try {
        final contacts = await ContactsService.getContacts();
        setState(() {
          _contacts = contacts;
          _filteredContacts = List.from(_contacts!);
        });
      } catch (e) {
        _showSnackBar('Error fetching contacts: $e');
      }
    } else {
      _showSnackBar('Contacts permission not granted.');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _searchContacts(String query) {
    setState(() {
      _filteredContacts = _contacts
          ?.where((contact) =>
              contact.displayName
                  ?.toLowerCase()
                  .contains(query.toLowerCase()) ==
              true)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          keyboardType: TextInputType.number,
          onChanged: (value) {
            setState(() {
              phoneNumber = value;
            });
          },
          decoration: InputDecoration(
            labelText: 'Phone Number',
            prefixIcon: Icon(Icons.phone),
            suffix: IconButton(
              onPressed: () {
                setState(() {
                  phoneNumber = null; // or set to the desired default value
                });
              },
              icon: const Icon(Icons.clear),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter the phone number';
            }
            return null;
          },
          controller: TextEditingController(text: phoneNumber),
        ),

        _buildRecentRechargesList(),

        SizedBox(height: 10),

        // Add other widgets as needed
      ],
    );
  }

  Widget _buildRecentRechargesList() {
    return ExpansionPanelList(
      elevation: 1,
      expandedHeaderPadding: EdgeInsets.zero,
      dividerColor: Colors.transparent,
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          if (index == 0) {
            recentRechargesExpanded = !recentRechargesExpanded;
          } else if (index == 1) {
            selectContactExpanded = !selectContactExpanded;
          }
        });
      },
      children: [
        ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return const ListTile(
              title: Text(
                'Recent Recharges',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            );
          },
          body: _buildRecentRechargesGrid(),
          isExpanded: recentRechargesExpanded,
        ),
        ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return const ListTile(
              title: Text(
                'Select Contact for Recharge',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            );
          },
          body: Column(
            children: [
              _buildSearchField(),
              _buildContent(),
            ],
          ),
          isExpanded: selectContactExpanded,
        )
      ],
    );
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
        onChanged: _searchContacts,
        decoration: const InputDecoration(
          hintText: 'Search Contacts ',
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

  Widget _buildRecentRechargesGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).size.width ~/ 90,
        crossAxisSpacing: 8,
        mainAxisSpacing: 16,
      ),
      itemCount: recentRechargeList.length,
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
                    phoneNumber = recentRechargeList[index].phoneNumber;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        recentRechargeList[index].name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        recentRechargeList[index].phoneNumber,
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

  Widget _buildContent() {
    if (_filteredContacts == null) {
      return Center(
          child: Container(
        padding: EdgeInsets.all(10),
        child: CircularProgressIndicator(),
      ));
    } else if (_filteredContacts!.isEmpty) {
      return const Center(child: Text('No contacts found.'));
    } else {
      return Container(
        height: 500,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: _filteredContacts!.length,
          itemBuilder: (context, index) {
            Contact contact = _filteredContacts!.elementAt(index);
            return Container(
              height: 70.0,
              margin:
                  const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(10.0),
                dense: true,
                title: Text(
                  contact.displayName ?? '',
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                subtitle: Text(
                  contact.phones?.isNotEmpty == true
                      ? contact.phones!.first.value ?? ''
                      : '',
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey,
                  ),
                ),
                leading: const CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Icon(
                    Icons.phone,
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  setState(() {
                    phoneNumber = _filteredContacts![index].phones?.first.value;
                  });
                },
              ),
            );
          },
        ),
      );
    }
  }
}
