How to create custom primary swatch -> https://www.youtube.com/watch?v=IEAvlucQB0s
Visit this link  create custom primary swatch http://mcg.mbitson.com/#!?primaryswatch=%2300c1a3
How To use custom Input widget 
           Form(
                child: Column(
                  children: [
                    Input(
                      labelText: "Email",
                      onSaved: (newValue) {},
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Email is required"; // return some error message when there is some potential error
                        }
                        return null; // retun null when there is no error
                      },
                      suffixIcon: GestureDetector(
                        onTap: () {
                          Utils.snackbar("Clicked", context);
                        },
                        child: const Icon(Icons.email_outlined),
                      ),
                      obscureText: false,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (value) {
                        // value will print the value present in the text field
                        //  print(value);
                        //FocusScope.of(context).requestFocus(_ageFocousNode);
                      },
                    )
                  ],
                ),
              ) 



              ViewModel of form 
                final formKey = GlobalKey<FormState>();
  void saveForm() {
    final isValid = formKey.currentState?.validate();
    if (!isValid!) {
      return;
    }
    formKey.currentState?.save();
  }

  String? validator(value) {
    if (value!.isEmpty) {
      return "Email is required"; // return some error message when there is some potential error
    }
    return null; // retun null when there is no error
  }

  void onFieldSubmitted(value) {
    // value will print the value present in the text field
    //print(value);
    //FocusScope.of(context).requestFocus(_ageFocousNode);
  }
  Widget suffixIcon(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Utils.snackbar("Clicked", context);
      },
      child: const Icon(Icons.email_outlined),
    );
  }

  void onSaved(value) {
   
  }



  import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import '../../../services/socket_io.dart';
import 'signin_view_model.dart';

class SignInScreen extends HookWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final useViewModel =
        useMemoized(() => Provider.of<SignInViewModel>(context, listen: false));
    final useSocketService =
        useMemoized(() => Provider.of<SocketService>(context, listen: false));
    useEffect(() {
      useSocketService.connect();
    },[]);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Consumer<SignInViewModel>(builder: (context, provider, child) {
              return Text(provider.count.toString());
            }),
            ElevatedButton(
              onPressed: useViewModel.setCount,
              child: const Text("Count"),
            ),
            FutureBuilder(
                future: useViewModel.loginApi({}, context),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return const Text("data arrived!");
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  return const CircularProgressIndicator();
                })
          ],
        ),
      ),
    );
  }
}
