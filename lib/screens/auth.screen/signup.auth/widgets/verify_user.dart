import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import '../../../../widgets/Input.widgets/input.dart';
import '../../../../utils/utils.dart';
import '../../../../widgets/button.widgets/elevated_button.dart';
import '../../../../widgets/text.widgets/text.dart';
import '../../../../widgets/tools.widgets/tools.dart';
import '../signup_view_model.dart';

class VerifyUser extends HookWidget {
  const VerifyUser({super.key});

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    final useViewModel =
        useMemoized(() => Provider.of<SignUpViewModel>(context,listen: false));
        useEffect(() {
      return () => useViewModel.disposeVerifyUserformKey();
    }, []);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 50,
              ),
              SizedBox(
                width: dimension["width"]! - 32,
                child: Row(
                  children: [
                    BackIconButton(onTap: () => useViewModel.goBack(context)),
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              const SmallLogo(),
              const SizedBox(
                height: 40,
              ),
              const SubHeadingText("Verify Yourself",fontSize: 26,),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    Form(
                      key: useViewModel.verifyUserformKey,
                      child: Column(
                        children: [
                          Input(
                            labelText: "Employee ID",
                            autoFocus: true,
                            onSaved:(value) => useViewModel.onSavedEmployeeIdField(value,context),
                            keyboardType: TextInputType.text,
                            validator: useViewModel.employeeIdFieldValidator,
                            suffixIcon: useViewModel.suffixIconForEmployeeId(),
                            onFieldSubmitted: useViewModel.onEmployeeIdFieldSubmitted,
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Consumer<SignUpViewModel>(builder: (context, provider, child) =>CustomElevatedButton(
                            title: "Verify",
                            loading: provider.loading,
                            onPress: useViewModel.saveVerifyUserForm,
                          ),
                           )
                        ],
                      ),
                    )
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
