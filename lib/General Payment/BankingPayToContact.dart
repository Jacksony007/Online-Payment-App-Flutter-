import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

import '../Controller/UserDetails.dart';
import '../Settings/PhoneNumberVerifier.dart';
import '../User Model/user_financial_model.dart';
import 'AmountPage.dart';

class PayToContactPage extends StatefulWidget {
  const PayToContactPage({Key? key}) : super(key: key);

  @override
  _PayToContactPageState createState() => _PayToContactPageState();
}

class _PayToContactPageState extends State<PayToContactPage> {
  Iterable<Contact>? _contacts;
  List<Contact>? _filteredContacts;

  bool _isVerified = false;
  bool _isLoading = false;
  bool _verificationFailed = false;

  PhoneNumberVerifier phoneNumberVerifier = PhoneNumberVerifier();

  UserFinancialModel? financialData;
  FirebaseService firebaseService = FirebaseService();

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
            border: InputBorder.none, // No underline
            contentPadding: EdgeInsets.symmetric(
                vertical: 8.0, horizontal: 2.0), // Adjust vertical padding
          ),
        ),
        child: TextField(
          onChanged: _searchContacts,
          decoration: const InputDecoration(
            hintText: 'Search Contacts',
            hintStyle: TextStyle(color: Colors.white70, fontSize: 16.0),
            suffixIcon: Icon(Icons.search, color: Colors.white),
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
              String? phoneNumber = contact.phones!.first.value;
              String cleanedPhoneNumber =
                  phoneNumber!.replaceAll(RegExp(r'\s+'), '');
              verifyPhoneNumber(cleanedPhoneNumber);
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
                    Icons.person,
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

  Future<void> verifyPhoneNumber(String phoneNumber) async {
    setState(() {
      _isVerified = false;
      _isLoading = true;
      _verificationFailed = false;
    });

    UserFinancialModel? financialData =
        await phoneNumberVerifier.verifyPhoneNumber(context, phoneNumber);

    setState(() {
      _isLoading = false;
    });

    if (financialData != null) {
      setState(() {
        _navigateToAmountPage();
        _isVerified = true;
      });
    } else {
      setState(() {
        _verificationFailed = true;
        print(phoneNumber);
      });
    }
  }

  void _navigateToAmountPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AmountPage(financialData: financialData),
      ),
    );
  }
}
