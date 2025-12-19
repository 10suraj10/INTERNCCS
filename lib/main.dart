import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(), // show login page first
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.lightGreen),
      ),

      //home: const MyHomePage(title: 'Image App Home Page'),

    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  //final String title;*
  @override
  State<LoginPage> createState() => _LoginPageState();
}
//* LOGIN PAGE
class _LoginPageState extends State<LoginPage> {
  /*int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });*/

  // To read what user typed
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  // Function called when user presses Login button
  void login() {
    String user = usernameController.text;
    String pass = passwordController.text;

    // Check username and password using if-else
    if (user == "NCCSIntern" && pass == "2025") {
      // Go to HomePage if correct
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      // Show error message if wrong
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Incorrect username or password")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: "Username"),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: "Password"),
              //obscureText: true, // hides password
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: login, // call login() when pressed
              child: const Text("Login"),
            )
          ],
        ),
      ),
    );
  }
}
// ------------------ HOME PAGE AFTER LOGIN ------------------
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Welcome Page")),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              "https://picsum.photos/200", // sample random image
              height: 150,
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // logs out and goes back
              },
              child: const Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }
}