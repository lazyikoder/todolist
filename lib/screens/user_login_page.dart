import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todolistapp/firebase_api/user_authentication.dart';
import 'package:todolistapp/globals/global_variables.dart';
import 'package:todolistapp/screens/todo_list_screen.dart';
import 'package:todolistapp/screens/user_signup_page.dart';
import 'package:todolistapp/sizeConfig/size_config.dart';
import 'package:todolistapp/widgets/button_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool isloading = false;
  late UserAuth _userAuth;
  @override
  void initState() {
    super.initState();
    _userAuth = UserAuth();
  }

  onsignIn() async {
    if (_formKey.currentState!.validate()) {
      globalUSERDOCID = await _userAuth.userLoginWithEmailAndPassword(
          _email.text, _password.text);

      if (globalUSERDOCID!.isNotEmpty) {
        setState(
          () {
            isloading = true;
          },
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ToDoListScreen(title: 'Todo\'s List'),
          ),
        );
      } else {
        Fluttertoast.showToast(
          msg: "Invalid username/password",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isloading
            ? Center(
                // ignore: avoid_unnecessary_containers
                child: Container(
                child: const CircularProgressIndicator(),
              ))
            : Container(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: SizeConfig.heightMultiplier * 2,
                          ),
                          TextFormField(
                            validator: (value) {
                              return RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(value!)
                                  ? null
                                  : "Please Enter a valid email_ID";
                            },
                            controller: _email,
                            maxLength: 60,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              counterText: "",
                              filled: true,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none),
                              fillColor: Colors.grey[200],
                              hintText: "Enter your email",
                              prefixIcon: const Icon(Icons.email),
                            ),
                          ),
                          SizedBox(
                            height: SizeConfig.heightMultiplier * 2,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value!.isEmpty || value.length <= 6) {
                                return "Invalid Password";
                              }
                            },
                            obscureText: true,
                            controller: _password,
                            maxLength: 60,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              counterText: "",
                              filled: true,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none),
                              fillColor: Colors.grey[200],
                              hintText: "Password",
                              prefixIcon: const Icon(Icons.lock),
                            ),
                          ),
                          SizedBox(
                            height: SizeConfig.heightMultiplier * 2,
                          ),
                          bottomButton(
                              context: context,
                              title: "Login",
                              onClick: onsignIn),
                          SizedBox(
                            height: SizeConfig.heightMultiplier * 2,
                          ),
                          InkWell(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                const Text("Don't have an account? "),
                                Text(
                                  "Sign Up.",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignUpPage(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ));
  }
}
