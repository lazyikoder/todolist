import 'package:flutter/material.dart';
import 'package:todolistapp/firebase_api/user_authentication.dart';
import 'package:todolistapp/globals/global_variables.dart';
import 'package:todolistapp/screens/todo_list_screen.dart';
import 'package:todolistapp/screens/user_login_page.dart';
import 'package:todolistapp/sizeConfig/size_config.dart';
import 'package:todolistapp/widgets/button_widget.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool isloading = false;
  late UserAuth _userAuth;
  Map<String, dynamic> map = {};

  @override
  void initState() {
    super.initState();
    _userAuth = UserAuth();
  }

  onsignUp() async {
    if (_formKey.currentState!.validate()) {
      globalUSERDOCID = await _userAuth.userSignUpWithEmailAndPassword({
        "name": _username.text,
        "email": _email.text,
        "password": _password.text,
      });
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
                              return value!.isEmpty || value.length < 4
                                  ? "Username cannot be empty"
                                  : null;
                            },
                            controller: _username,
                            maxLength: 60,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              counterText: "",
                              filled: true,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none),
                              fillColor: Colors.grey[200],
                              hintText: "Enter your name",
                              prefixIcon: const Icon(Icons.person),
                            ),
                          ),
                          SizedBox(
                            height: SizeConfig.heightMultiplier * 2,
                          ),
                          TextFormField(
                            validator: (value) {
                              return RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(value!)
                                  ? null
                                  : "Please Enter a valid email";
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
                              title: "SignUp",
                              onClick: onsignUp),
                          SizedBox(
                            height: SizeConfig.heightMultiplier * 1,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginPage(),
                                ),
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                const Text("Already have an account? "),
                                Text(
                                  "Sign In.",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ));
  }
}
