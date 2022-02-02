import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:olx/form/cat_provider.dart';
import 'package:provider/provider.dart';

class seller_form extends StatefulWidget {
  const seller_form({Key? key}) : super(key: key);

  @override
  _seller_formState createState() => _seller_formState();
}

class _seller_formState extends State<seller_form> {
  static const String id = 'seller-form';
  final _formkey = GlobalKey<FormState>();
  var _brandController = TextEditingController();
  var _yearController = TextEditingController();
  var _priceController = TextEditingController();
  var _fuelController = TextEditingController();
  var _kmController = TextEditingController();
  var _addressController = TextEditingController();

  List<String> _fuelList = ['Diesel', 'Petrol', 'Electric', 'Gas'];

  @override
  Widget build(BuildContext context) {
    var _catProvider = Provider.of<CategoryProvider>(context);

    Widget _appBar(title, fieldvale) {
      return AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('$title/fieldvalue',
            style: TextStyle(
                color: Colors.white,
                fontSize: 14.0,
                fontWeight: FontWeight.bold)),
      );
    }

    Widget _brandlist() {
      return Dialog(
          backgroundColor: Colors.orangeAccent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _appBar(_catProvider.SelectedCategory, 'Brands'),
              Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _catProvider.doc['model'].length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        onTap: () {
                          setState(() {
                            _brandController.text =
                                _catProvider.doc['model'][index];
                            // print(_brandController.text);
                          });
                          Navigator.pop(context); // to get close this widget
                        },
                        title: Text(
                          _catProvider.doc['model'][index],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      );
                    }),
              ),
            ],
          ));
    }

    Widget _listview(fieldvalue) {
      return Dialog(
        backgroundColor: Colors.orangeAccent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _appBar(_catProvider.SelectedCategory, fieldvalue),
            ListView.builder(
                shrinkWrap: true,
                itemCount: _fuelList.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    onTap: () {
                      _fuelController.text = _fuelList[index];
                      Navigator.pop(context);
                    },
                    title: Text(
                      _fuelList[index],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  );
                }),
          ],
        ),
      );
    }

    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text("Add details",
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold)),
            iconTheme: IconThemeData(color: Colors.black),
            shape: Border(
              bottom: BorderSide(
                  color: Colors.grey.shade400, style: BorderStyle.solid),
            )),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Form(
              key: _formkey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      "CAR",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return _brandlist();
                            });
                      },
                      child: TextFormField(
                        controller: _brandController,
                        enabled: false, // can't enter manually
                        decoration: InputDecoration(
                          labelText: 'Brand/Model/Variant',
                          hintText: "audi/a6/2020",
                        ),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Fill required fields';
                          }
                          return null;
                        },
                      ),
                    ),
                    TextFormField(
                      controller: _yearController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Year*',
                        hintText: "2012",
                      ),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Fill required fields';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Price',
                        prefixText: "Rs ",
                      ),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Fill required fields';
                        }
                        return null;
                      },
                    ),
                    InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return _listview('Fuel');
                            });
                      },
                      child: TextFormField(
                        controller: _fuelController,
                        enabled: false, // can't enter manually
                        decoration: InputDecoration(
                          labelText: 'Fuel',
                          hintText: "Diesel",
                        ),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Fill required fields';
                          }
                          return null;
                        },
                      ),
                    ),
                    TextFormField(
                      controller: _kmController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Km travelled',
                        suffixText: " km",
                      ),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Fill required fields';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      maxLength: 500,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        counterText:
                            'Mention Condition,feature and reason behind selling',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Fill required fields';
                        }
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
                    SizedBox(
                      height: 100,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        bottomSheet: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: NeumorphicButton(
                  child: Text(
                    'Next',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: NeumorphicStyle(
                    color: Colors.greenAccent,
                  ),
                  onPressed: () {},
                ),
              ),
            )
          ],
        ));
  }
}
