import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:olx/form/cat_provider.dart';
import 'package:olx/form/seller_form.dart';
import 'package:olx/screens/home_screen.dart';
import 'package:olx/services/firebase_services.dart';
import 'package:provider/provider.dart';

class UserReviewScreen extends StatefulWidget {
  UserReviewScreen({Key? key}) : super(key: key);
  static const String id = 'user-review-screen';

  @override
  _UserReviewScreenState createState() => _UserReviewScreenState();
}

class _UserReviewScreenState extends State<UserReviewScreen> {
  static final _formkey = GlobalKey<FormState>();

  var _nameController = TextEditingController();
  var _countryController = TextEditingController(text: '+91');
  var _phoneController = TextEditingController();
  var _emailController = TextEditingController();
  var _addressController = TextEditingController();
  FirebaseService _service = FirebaseService();

  Future<void> updateUser(provider, Map<String, dynamic> data, context) async {
    return _service.users.doc(_service.user!.uid).update(data).then(
      (value) {
        saveProductToDb(provider, context);
      },
    ).catchError((error) {
      print("There was an error updating profile");
    });
  }

  Future<void> saveProductToDb(CategoryProvider provider, context) async {
    return _service.products.add(provider.dataToFirestore).then(
      (value) {
        print('Product uploaded');
        provider.clearData();
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Product Uploaded')));
        Navigator.pushReplacementNamed(context, home_screen.id);
      },
    ).catchError((error) {
      print(error);
      print("There was an error updating products");
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Failed to upload')));
    });
  }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<CategoryProvider>(context);

    showConfirmDialog() {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Confirm',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text('Are you Sure to save below product'),
                    SizedBox(
                      height: 10,
                    ),
                    ListTile(
                      leading:
                          Image.network(_provider.dataToFirestore['images'][0]),
                      title: Text(_provider.dataToFirestore['category']),
                      subtitle: Text(_provider.dataToFirestore['price']),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      NeumorphicButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: NeumorphicStyle(
                          border: NeumorphicBorder(
                              color: Theme.of(context).primaryColor),
                          color: Colors.transparent,
                        ),
                        child: Text('Cancel'),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      NeumorphicButton(
                        onPressed: () {
                          updateUser(
                                  _provider,
                                  {
                                    'contactDetails': {
                                      'mobile': _phoneController.text,
                                      'email': _emailController.text,
                                      'name': _nameController.text,
                                      'address': _addressController.text,
                                    },
                                  },
                                  context)
                              .whenComplete(() {
                            print("update completed");
                          });
                        },
                        style: NeumorphicStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                        child: Text('Confirm'),
                      )
                    ])
                  ],
                ),
              ),
            );
          });
    }

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text("Review your details",
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold)),
            iconTheme: IconThemeData(color: Colors.black),
            shape: Border(
              bottom: BorderSide(
                  color: Colors.grey.shade400, style: BorderStyle.solid),
            )),
        body: Form(
          key: _formkey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.blueAccent.shade400,
                      radius: 40,
                      child: CircleAvatar(
                        backgroundColor: Colors.blueGrey.shade500,
                        radius: 38,
                        child: Icon(
                          CupertinoIcons.person_alt,
                          size: 60,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                        child: TextFormField(
                      controller: _nameController,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Your Name',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) return 'Enter your name';

                        return null;
                      },
                    ))
                  ],
                ),
                SizedBox(height: 30),
                Text("Contact details",
                    style:
                        TextStyle(fontSize: 25, fontWeight: FontWeight.w500)),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                        flex: 2,
                        child: TextFormField(
                          controller: _countryController,
                          enabled: false,
                          decoration: InputDecoration(
                            labelText: 'Country code',
                            helperText: '', //just to align numbering
                          ),
                        )),
                    SizedBox(width: 10),
                    Expanded(
                      flex: 5,
                      child: TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Mobile number',
                        ),
                        maxLength: 10,
                        validator: (value) {
                          if (value!.isEmpty) return 'Enter Mobile number';
                          if (value.length < 10)
                            return 'Enter correct Mobile number';
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                  ),
                  validator: (value) {
                    final bool isvalid = EmailValidator.validate(_emailController
                        .text); // import 'package:email_validator/email_validator.dart';
                    if (value == null || value.isEmpty) {
                      return 'Enter Email';
                    }
                    if (value.isNotEmpty && isvalid == false)
                      return 'Enter valid Email';
                    return null;
                  },
                ),
                TextFormField(
                  controller: _addressController,
                  keyboardType: TextInputType.text,
                  minLines: 1,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'Address',
                    counterText: 'Your address with pincode',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Fill required fields';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        bottomSheet: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: NeumorphicButton(
                  child: Text(
                    "Confirm",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.cyan,
                    ),
                  ),
                  onPressed: () {
                    if (_formkey.currentState!.validate()) {
                      showConfirmDialog();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Fill required fields.')));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
