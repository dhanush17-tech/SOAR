import 'package:country_currency_pickers/country.dart';
import 'package:country_currency_pickers/currency_picker_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:SOAR/main_constraints.dart';

class Questionnaire extends StatefulWidget {
  @override
  _QuestionnaireState createState() => _QuestionnaireState();
}

class _QuestionnaireState extends State<Questionnaire> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getman();
    print(currencycode);
  }

  Future loadpass() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool(
      "keys",
    );
  }

  getman() {
    loadpass().then((ca) {
      setState(() {
        man = ca;
      });
    });
  }

  bool man;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      backgroundColor: man == false ? light_background : dark_background,
      body: SingleChildScrollView(
           physics: BouncingScrollPhysics(),
        reverse: MediaQuery.of(context).viewInsets.bottom != 0 ? true : false,
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8),
          child: Form(
            key: key2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                Text(
                  "Investment Needed",
                  style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.w400,
                      fontFamily: "good",
                      color: man == false
                          ? light_text_heading
                          : dark_text_heading),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        child: Container(
                          width: 260,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(4279704112),
                          ),
                          child: TextFormField(
                            validator: (e) => e.length == 0 ? "" : null,
                            controller: lowPrice,
                            style: TextStyle(
                                color: Color(4278228470),
                                fontSize: 30,
                                fontFamily: "good",
                                fontWeight: FontWeight.w500),
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.left,
                            decoration: InputDecoration(
                              filled: true,
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: Theme(
                        data:
                            man == false ? ThemeData.light() : ThemeData.dark(),
                        child: CurrencyPickerDropdown(
                          itemBuilder: _buildCurrencyDropdownItem,
                          initialValue: "INR",
                          onValuePicked: (Country country) {
                            setState(() {
                              currencycode = country.currencyCode;
                            });
                            print(currencycode);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 0),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10, left: 0),
                    child: Text(
                      'How does your problem or service help?',
                      style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.w400,
                          fontFamily: "good",
                          color: man == false
                              ? light_text_heading
                              : dark_text_heading),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.only(left: 0),
                  child: Container(
                    width: 500,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(4279704112),
                    ),
                    child: TextFormField(
                      controller: pitchController,
                      validator: (value) => value.length < 20
                          ? "Your summary should be more than 20"
                          : null,
                      style: TextStyle(
                          color: Color(4278228470),
                          fontSize: 30,
                          fontFamily: "good",
                          fontWeight: FontWeight.w500),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(9),
                          border: InputBorder.none),
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                    ),
                  ),
                ),
                SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.only(right: 0),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 0),
                    child: Text(
                      'Who are your targeted end users',
                      style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.w400,
                          fontFamily: "good",
                          color: man == false
                              ? light_text_heading
                              : dark_text_heading),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.only(left: 0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: Container(
                      width: 500,
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(4279704112),
                      ),
                      child: TextFormField(
                        style: TextStyle(
                            color: Color(4278228470),
                            fontSize: 30,
                            fontFamily: "good",
                            fontWeight: FontWeight.w500),
                        controller: companyController,
                        validator: (e) => e.length == 0 ? "" : null,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          filled: true,
                          contentPadding:
                              EdgeInsets.only(left: 9, right: 9, bottom: 5),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).viewInsets.bottom,
                ),
                SizedBox(height: 10)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrencyDropdownItem(Country country) => Container(
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 8.0,
            ),
            Text("${country.currencyCode}"),
          ],
        ),
      );
}

TextEditingController pitchController = new TextEditingController();
TextEditingController companyController = new TextEditingController();
final key2 = GlobalKey<FormState>();
TextEditingController lowPrice = TextEditingController(); //after
String currencycode = "INR";
