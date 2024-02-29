import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import '../Controller/UserDetails.dart';
import '../User Model/user_model.dart';
import '../screen/UnauthenticatedBankingShareScreen.dart';
import '../utils/AppTextDecoration.dart';
import '../utils/BankingColors.dart';
import '../utils/BankingImages.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({
    Key? key,
  }) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  File? profilePictureController;

  FirebaseService firebaseService = FirebaseService();

  UserModel? userData;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);

    if (pickedImage != null) {
      setState(() {
        profilePictureController = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Banking_app_Background,
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
              key: _formKey,
              child:
                  // Display user's picture
                  StreamBuilder<UserModel?>(
                stream: firebaseService.streamUserData(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    userData = snapshot.data!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              // Add logic to open a dialog or navigate to a page for image selection or capture.
                              // For simplicity, directly pick from gallery in this example.
                              _pickImage(ImageSource.gallery);
                            },
                            child: CircleAvatar(
                              radius: 70,
                              backgroundColor: Colors.blue,
                              backgroundImage: profilePictureController != null
                                  ? Image.file(profilePictureController!).image
                                  : (userData?.photoURL != null &&
                                          userData!.photoURL!.isNotEmpty)
                                      ? AssetImage(userData!.photoURL!)
                                      : AssetImage(DefaultPicture),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: TextEditingController(
                              text: userData?.displayName),
                          decoration: AppTextDecoration.defaultInputDecoration(
                            labelText: 'Display Name',
                            prefixIcon: Icons.person,
                            iconColor: Colors.blue,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your Display name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller:
                              TextEditingController(text: userData?.email),
                          decoration: AppTextDecoration.defaultInputDecoration(
                            labelText: 'Email Address',
                            prefixIcon: Icons.email,
                            iconColor: Colors.blue,
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter Email Address';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              String displayName = displayNameController.text;
                              String email = emailController.text;
                              File? profilePicture = profilePictureController;

                              await SaveUserProfile()._updateUserProfile(
                                  displayName, email, profilePicture);

                              // Show a toast message
                              Fluttertoast.showToast(
                                msg: 'Profile updated successfully',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.blue,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          child: const Text('Save'),
                        ),
                      ],
                    );
                  } else {
                    return UnauthenticatedBankingShareScreen();
                  }
                },
              )),
        ),
      ),
    );
  }
}
