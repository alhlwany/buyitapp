import 'package:buyitapp/provider/adminMode.dart';
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
  bool isAdmin = false;

  @override
  Widget build(BuildContext context) {

    double sc_heigh = MediaQuery.of(context).size.height;
    double sc_width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: kMainColor,
      body: ModalProgressHUD(
        inAsyncCall: Provider.of<ModelHud>(context).isLoading,
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
                   _validate(context);
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
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Provider.of<AdminMode>(context, listen: false)
                              .changeIsAdmin(true);
                        },
                        child: Text(
                          'i\'m an admin',
                          style: TextStyle(
                              fontFamily: 'Ranchers',
                              color: Provider.of<AdminMode>(context).isAdmin
                                  ? kMainColor
                                  : Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Provider.of<AdminMode>(context, listen: false)
                              .changeIsAdmin(false);
                        },
                        child: Text(
                          'i\'m a user',
                          style: TextStyle(
                              fontFamily: 'Ranchers',
                              color: Provider.of<AdminMode>(context).isAdmin
                                  ? Colors.white
                                  : kMainColor),
                          textAlign: TextAlign.center,
                        ),
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

  void _validate(BuildContext context) async {
    final modelhud = Provider.of<ModelHud>(context, listen: false);
    modelhud.changeisLoading(true);
    if (_globalKey.currentState.validate()) {
      _globalKey.currentState.save();
      if (Provider.of<AdminMode>(context, listen: false).isAdmin) {
        if (_password == adminPassword) {
          try {
            await _auth.signIn(_email.trim(), _password.trim());
            //  Navigator.pushNamed(context, AdminHome.id);
          } catch (e) {
            modelhud.changeisLoading(false);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text(e.message),
                duration: Duration(seconds: 10),
                backgroundColor: Colors.black,
              ));
            });
          }
        } else {
          modelhud.changeisLoading(false);
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text('Something went wrong !'),
          ));
        }
      } else {
        try {
          await _auth.signIn(_email.trim(), _password.trim());
          // Navigator.pushNamed(context, HomePage.id);
        } catch (e) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text(e.message),
              duration: Duration(seconds: 10),
              backgroundColor: Colors.black,
            ));
          });
        }
      }
    }
    modelhud.changeisLoading(false);
  }

  void keepUserLoggedIn() async {
    // SharedPreferences preferences = await SharedPreferences.getInstance();
    // preferences.setBool(kKeepMeLoggedIn, keepMeLoggedIn);
  }
}
