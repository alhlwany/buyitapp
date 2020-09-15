import 'package:buyitapp/provider/modelHud.dart';
import 'package:buyitapp/screens/signup_screen.dart';
import 'package:buyitapp/services/auth.dart';
import 'package:buyitapp/users/homePage.dart';
import 'package:buyitapp/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import '../constants.dart';

class LoginScreen extends StatelessWidget {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  static String id = 'LoginScreen';
  String _email, _password;
  final _auth = Auth();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final adminPassword = 'Admin1234';
  bool keepMeLoggedIn = false;

  @override

  Widget build(BuildContext context) {
    double sc_heigh = MediaQuery.of(context).size.height;
    double sc_width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: kMainColor,
        body: ModalProgressHUD(
          inAsyncCall:Provider.of<ModelHud>(context).isLoading ,
          child: Form(
            key: _globalKey,
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 80),
                  child: Container(
                    height: MediaQuery.of(context).size.height * .20,
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Image(
                          image: AssetImage('images/icons/buyicon.png'),
                        ),
                        Positioned(
                            bottom: 0,
                            child: Text('Buy it',
                                style: TextStyle(
                                    fontSize: 25, fontFamily: 'Pacifico')))
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: sc_heigh * .1,
                ),
                CustomTextField(
                    onClick: (value) {
                      _email = value;
                    },
                    icon: Icons.email,
                    hint: 'Enter Your Email'),
                SizedBox(
                  height: sc_heigh * .02,
                ),
                CustomTextField(
                    onClick: (value) {
                      _password = value;
                    },
                    icon: Icons.vpn_key,
                    hint: 'Enter Your Password'),
                SizedBox(
                  height: sc_heigh * .05,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 120),
                  child: Builder(
                    key: _scaffoldKey,
                    builder: (context) => FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      onPressed: () async {
                        final modelhud =
                        Provider.of<ModelHud>(context,listen: false);
                        modelhud.changeisLoading(true);
                        if (_globalKey.currentState.validate()) {
                          try {
                            _globalKey.currentState.save();
                            final authResult =
                                await _auth.signIn(_email, _password);
                            modelhud.changeisLoading(false);
                           // Navigator.pushNamed(context,HomePage.id);

                          }on PlatformException catch (e) {
                            modelhud.changeisLoading(false);
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              Scaffold.of(context).showSnackBar(SnackBar(
                                content: Text(e.message),
                                duration: Duration(seconds: 10),
                                backgroundColor: Colors.black,
                              ));
                            });
                          }
                        }
                      },
                      color: Colors.black,
                      child: Text(
                        'Login',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontFamily: 'Pacifico'),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: sc_heigh * .03,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Don\'t Have an account ?',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontFamily: 'Pacifico'),
                    ),
                    GestureDetector(
                      onTap: () {
                        var pushNamed =
                            Navigator.pushNamed(context, SignupScreen.id);
                      },
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'Pacifico'),
                      ),
                    )
                  ],
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Row(children: <Widget>[
                    Expanded(
                      child: Text('i\'m an admin',
                        style:TextStyle(fontFamily: 'Ranchers'),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    Expanded(
                      child: Text(
                        'i\'m a user',
                        style:TextStyle(fontFamily: 'Ranchers'),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                  ),
                ),

              ],
            ),
          ),
        ),
    );
  }
}
