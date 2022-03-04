import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:galleryimage/galleryimage.dart';
import 'package:olx/form/UserReviewScreen.dart';
import 'package:olx/form/cat_provider.dart';
import 'package:olx/services/firebase_services.dart';
import 'package:olx/widgets/ImagePickerWidget.dart';
import 'package:provider/provider.dart';

class seller_form extends StatefulWidget {
  const seller_form({Key? key}) : super(key: key);

  @override
  _seller_formState createState() => _seller_formState();
}

class _seller_formState extends State<seller_form> {
  static const String id = 'seller-form';
  FirebaseService _service = FirebaseService();

  final _formkey = GlobalKey<FormState>();
  var _brandController = TextEditingController();
  var _yearController = TextEditingController();
  var _priceController = TextEditingController();
  var _fuelController = TextEditingController();
  var _kmController = TextEditingController();
  var _descriptionController = TextEditingController();

  List<String> _fuelList = ['Diesel', 'Petrol', 'Electric', 'Gas'];

  validate(CategoryProvider provider) {
    if (_formkey.currentState!.validate()) {
      if (provider.urlList.length > 0) {
        // print("data to firestore done");
        provider.dataToFirestore.addAll({
          'category': provider.SelectedCategory,
          'brand': _brandController.text,
          'year': _yearController.text,
          'price': _priceController.text,
          'fuel': _fuelController.text,
          'kmDrive': _kmController.text,
          'description': _descriptionController.text,
          'id': _service.user!.uid,
          'images': provider.urlList,
        });

        Navigator.pushNamed(context, UserReviewScreen.id);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Upload Images'),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please fill required fiels'),
      ));
    }
  }

  @override
  void didChangeDependencies() {
    // TO get context
    var _catProvider = Provider.of<CategoryProvider>(context);
    setState(() {
      _brandController.text = _catProvider.dataToFirestore.isEmpty
          ? ''
          : _catProvider.dataToFirestore['brand'];
      _yearController.text = _catProvider.dataToFirestore.isEmpty
          ? ''
          : _catProvider.dataToFirestore['year'];
      _priceController.text = _catProvider.dataToFirestore.isEmpty
          ? ''
          : _catProvider.dataToFirestore['price'];
      _fuelController.text = _catProvider.dataToFirestore.isEmpty
          ? ''
          : _catProvider.dataToFirestore['fuel'];
      _kmController.text = _catProvider.dataToFirestore.isEmpty
          ? ''
          : _catProvider.dataToFirestore['km'];
      _descriptionController.text = _catProvider.dataToFirestore.isEmpty
          ? ''
          : _catProvider.dataToFirestore['description'];
    });
    super.didChangeDependencies();
  }

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
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0.0),
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
                      controller: _descriptionController,
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
                    SizedBox(
                      height: 30,
                    ),
                    if (_catProvider.urlList.length > 0)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: InkWell(
                          onTap: () {
                            print(_catProvider.urlList.length);
                          },
                          child: GalleryImage(
                            imageUrls: _catProvider.urlList,
                          ),
                        ),
                      ),
                    InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return ImagePickerWidget();
                            });
                      },
                      child: Neumorphic(
                        child: Container(
                          height: 40.0,
                          child: Center(
                            child: Text(
                              'Upload Image',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 200,
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
                padding: const EdgeInsets.all(25.0),
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
                  onPressed: () {
                    validate(_catProvider);
                  },
                ),
              ),
            )
          ],
        ));
  }
}
