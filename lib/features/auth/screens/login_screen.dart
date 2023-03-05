import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/common/widgets/custom_button.dart';
import 'package:whatsapp/utils/constant/app_color.dart';
import 'package:whatsapp/utils/constant/app_string.dart';

class LoginScreen extends StatefulWidget {
  static const routeName='/login-screen';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final phoneController=TextEditingController();
  Country ? country;
  @override
  void dispose() {
    super.dispose();
    phoneController.dispose();
  }
  pickCountry( ){
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
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller:phoneController ,
                      decoration: InputDecoration(
                        hintText: AppString.phoneHint
                      ),
                    ),
                  )

                ],
              ),
              SizedBox(height: size.height*0.6,),
              SizedBox(
                width: 90,
                child:CustomButton(text: AppString.loginButtonTitle, onPressed: (){}),
              )
            ],
          ),
        ),
      ),
    );
  }
}
