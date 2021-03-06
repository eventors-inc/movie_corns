import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movie_corns/constants/constants.dart';
import 'package:movie_corns/pages/home.dart';
import 'package:progress_dialog/progress_dialog.dart';

/*
 * IT17050272 - D. Manoj Kumar
 * 
 * register.dart file consists with the source code for registeration page user interface
 * & backend services based on user registration
 * Once the user clicks on "Join Movie Corns" button in login page he/she will redirect to
 * this page. In order to register to the system, user needs to provide firstname, surname,
 * username & password as described in below code. An email address used by the user should be 
 * as the username as it will be useful for the future development of the app. The user 
 * needs to provide a password at least 8 character long in order to prevent from umauthorized 
 * logins. Also the password has to mention twice to ensure the password entered.
 * After entering all the required information, user can clicks on "Join Movie Corns" button.
 * Soonafter user clicks on it, the user entered data will stored in "users" database in firebase
 * under a newly auto-created user ID/document ID. This user ID will be used under every tasks. 
 * Once the user successfully registered to the system, the user will be redirected to the home 
 * page (Movie page) of the app
 * As mentioed in below code, the registration page is consisting with validators. It is required 
 * to fill all the details mentioned in the form brfore clicks on "Join Movie Corns" button & if
 * user fails to fil one field the system will display an error message. Apart from that, there are
 * validators to check the length of the password as well as the type of the username is "Email" too. 
 */

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  TextEditingController firstNameInputController;
  TextEditingController lastNameInputController;
  TextEditingController emailInputController;
  TextEditingController pwdInputController;
  TextEditingController confirmPwdInputController;
  ProgressDialog pr1;

  @override
  initState() {
    firstNameInputController = new TextEditingController();
    lastNameInputController = new TextEditingController();
    emailInputController = new TextEditingController();
    pwdInputController = new TextEditingController();
    confirmPwdInputController = new TextEditingController();
    super.initState();
  }

  String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return ValidatorConstants.INVALID_EMAIL_FORMAT;
    } else {
      return null;
    }
  }

  String pwdValidator(String value) {
    if (value.length < 8) {
      return ValidatorConstants.WEAK_PASSWORD;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    pr1 = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr1.style(
        message: ProgressDialogMesssageConstants.WELCOME_ABOARD,
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));
    return Scaffold(
        appBar: AppBar(
          title: Text(TitleConstants.REGISTER),
        ),
        body: Container(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
                child: Form(
              key: _registerFormKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: LabelConstants.LABEL_FIRST_NAME,
                        hintText: HintTextConstants.HINT_FIRST_NAME),
                    controller: firstNameInputController,
                    validator: (value) {
                      if (value.length < 3) {
                        return ValidatorConstants.INVALID_FIRST_NAME;
                      }
                    },
                  ),
                  TextFormField(
                      decoration: InputDecoration(
                          labelText: LabelConstants.LABEL_LAST_NAME,
                          hintText: HintTextConstants.HINT_LAST_NAME),
                      controller: lastNameInputController,
                      validator: (value) {
                        if (value.length < 3) {
                          return ValidatorConstants.INVALID_LAST_NAME;
                        }
                      }),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: LabelConstants.LABEL_EMAIL,
                        hintText: HintTextConstants.HINT_EMAIL),
                    controller: emailInputController,
                    keyboardType: TextInputType.emailAddress,
                    validator: emailValidator,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: LabelConstants.LABEL_PASSWORD,
                        hintText: HintTextConstants.HINT_PASSWORD),
                    controller: pwdInputController,
                    obscureText: true,
                    validator: pwdValidator,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: LabelConstants.LABEL_CONFIRM_PASSWORD,
                        hintText: HintTextConstants.HINT_PASSWORD),
                    controller: confirmPwdInputController,
                    obscureText: true,
                    validator: pwdValidator,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(19)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(ButtonConstants.JOIN_BUTTON),
                        Icon(Icons.arrow_forward),
                      ],
                    ),
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    onPressed: () async {
                      if (_registerFormKey.currentState.validate()) {
                        if (pwdInputController.text ==
                            confirmPwdInputController.text) {
                          await pr1.show();
                          FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                                  email: emailInputController.text,
                                  password: pwdInputController.text)
                              .then((currentUser) => Firestore.instance
                                  .collection("users")
                                  .document(currentUser.user.uid)
                                  .setData({
                                    "uid": currentUser.user.uid,
                                    "fname": firstNameInputController.text,
                                    "surname": lastNameInputController.text,
                                    "email": emailInputController.text,
                                  })
                                  .then((result) => {
                                        pr1.hide().then((isHidden) {
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      HomePage(
                                                        title: TitleConstants
                                                            .ALL_MOVIES,
                                                        uid: currentUser
                                                            .user.uid,
                                                      )),
                                              (_) => false);
                                        }),
                                        firstNameInputController.clear(),
                                        lastNameInputController.clear(),
                                        emailInputController.clear(),
                                        pwdInputController.clear(),
                                        confirmPwdInputController.clear()
                                      })
                                  .catchError((err) => print(err)))
                              .catchError((err) => print(err));
                        } else {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(TitleConstants.ALERT_ERROR),
                                  content: Text(ValidatorConstants
                                      .PASSWORDS_DO_NOT_MATCH),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text(ButtonConstants.OPTION_CLOSE),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    )
                                  ],
                                );
                              });
                        }
                      }
                    },
                  ),
                  SizedBox(
                    height: 130,
                  ),
                  Text(LabelConstants.LABEL_ALREADY_HAVE_ACCOUNT),
                  RaisedButton(
                    textColor: Theme.of(context).primaryColor,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(19)),
                    child: Text(ButtonConstants.LOGIN),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            ))));
  }
}
