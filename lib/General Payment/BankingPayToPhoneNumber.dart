import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

import 'AmountPage.dart';

class PayToPhoneNumberPage extends StatefulWidget {
  const PayToPhoneNumberPage({Key? key}) : super(key: key);

  @override
  _PayToPhoneNumberPageState createState() => _PayToPhoneNumberPageState();
}

class _PayToPhoneNumberPageState extends State<PayToPhoneNumberPage> {
  Iterable<Contact>? _contacts;
  List<Contact>? _filteredContacts;

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
              contact.phones
                  ?.any((phone) => phone.value?.contains(query) ?? false) ??
              false)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _buildSearchField(),
        backgroundColor: Colors.blue,
      ),
      body: _buildContent(),
    );
  }

  Widget _buildSearchField() {
    return Container(
      height: 40.0,
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Theme(
        data: ThemeData(
          inputDecorationTheme: const InputDecorationTheme(
            border: InputBorder.none,
            contentPadding:
                EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
          ),
        ),
        child: TextField(
          onChanged: _searchContacts,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            hintText: 'Search by Phone Number',
            hintStyle: TextStyle(color: Colors.white70, fontSize: 16.0),
            suffixIcon: Icon(Icons.dialpad, color: Colors.white),
          ),
          style: const TextStyle(color: Colors.white, fontSize: 16.0),
          cursorColor: Colors.white,
          keyboardAppearance: Brightness.dark,
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_filteredContacts == null) {
      return const Center(child: CircularProgressIndicator());
    } else if (_filteredContacts!.isEmpty) {
      return const Center(child: Text('No contacts found.'));
    } else {
      return ListView.builder(
        itemCount: _filteredContacts!.length,
        itemBuilder: (context, index) {
          Contact contact = _filteredContacts!.elementAt(index);
          return GestureDetector(
            onTap: () {
              _navigateToAmountPage(contact);
            },
            child: Container(
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
              ),
            ),
          );
        },
      );
    }
  }

  void _navigateToAmountPage(Contact contact) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AmountPage(),
      ),
    );
  }
}
