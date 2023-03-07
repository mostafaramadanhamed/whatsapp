import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/common/utils/utils.dart';
import 'package:whatsapp/common/widgets/custom_button.dart';
import 'package:whatsapp/features/auth/controller/auth_controller.dart';
import 'package:whatsapp/utils/constant/app_color.dart';
import 'package:whatsapp/utils/constant/app_string.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const routeName='/login-screen';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final phoneController=TextEditingController();
  Country ? country;
  @override
  void dispose() {
    super.dispose();
    phoneController.dispose();
  }
 void pickCountry( ){
    showCountryPicker(
      context: context,
      showPhoneCode: true, // optional. Shows phone code before the country name.
      onSelect: (Country _country) {
        print('Select country: ${_country.countryCode}');
        setState((){
          country=_country;});

      },
    );
  }

  void sendPhoneNumber(){
    String phoneNumber=phoneController.text.trim();
    if(country != null && phoneNumber.isNotEmpty){
      ref.read(authControllerProvider).signInWithPhone(context, '+${country!.phoneCode}$phoneNumber');
    }
    else{
      showSnackBar(context: context, content: 'Fill out all fields');
    }
  }
  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text( AppString.loginAppbarTitle,),
        elevation: 0,
        backgroundColor: backgroundColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text( AppString.loginMessage,),
              const  SizedBox(height: 10,),
              TextButton(onPressed: (){
                pickCountry();
              },
                child:const Text(AppString.loginPickCountry),),
              const  SizedBox(height: 5,),
              Row(
                children: [
                if(country !=null)  Text('+${country!.phoneCode}'),
                  const SizedBox(width: 10,),
                  SizedBox(
                    width: size.width*0.7,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller:phoneController ,
                      decoration: const InputDecoration(
                        hintText: AppString.phoneHint
                      ),
                    ),
                  )

                ],
              ),
              SizedBox(height: size.height*0.6,),
              SizedBox(
                width: 90,
                child:CustomButton(text: AppString.loginButtonTitle, onPressed: sendPhoneNumber),
              )
            ],
          ),
        ),
      ),
    );
  }
}
