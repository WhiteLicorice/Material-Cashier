import 'package:flutter/material.dart';
import 'package:brm_cashier/main.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

var logger = Logger();

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  SignInScreenState createState() => SignInScreenState();
}

class SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Material Cashier',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize:
                      MainAxisSize.min, // Ensure column takes minimum space
                  children: [
                    TextFormField(
                      controller: _usernameController,
                      decoration: const InputDecoration(labelText: 'Username'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your username';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          // Get the username entered by the user
                          String username = _usernameController.text.trim();

                          // Query Supabase to find the profile ID for the given username
                          var query = await Supabase.instance.client
                              .from('profiles')
                              .select('email')
                              .eq('username', username);

                          //  Guard against incorrect usernames
                          if (query.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Credentials incorrect.'),
                                duration: Duration(seconds: 1),
                              ),
                            );
                            return;
                          }

                          var email = query[0]['email'];
                          logger.d(email);

                          try {
                            await Supabase.instance.client.auth
                                .signInWithPassword(
                                    email: email,
                                    password: _passwordController.text);

                            // Hacky way of terminating sessions, since free Supabase doesn't let us control session duration
                            // This has the side effect of logging out the cashier from all other devices
                            await Supabase.instance.client.auth
                                .signOut(scope: SignOutScope.global);

                            await Supabase.instance.client.auth
                                .signInWithPassword(
                                    email: email,
                                    password: _passwordController.text);
                          } catch (e) {
                            logger.d(e);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Credentials incorrect.'),
                                duration: Duration(seconds: 1),
                              ),
                            );
                            return;
                          } finally {
                            logger.d(Supabase.instance.client.auth.currentUser);
                          }

                          // Assuming sign-in is successful, navigate to MyApp
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MyApp(),
                            ),
                          );
                        }
                      },
                      child: const Text('Sign In'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
