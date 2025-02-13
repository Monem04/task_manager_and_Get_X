import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/presentation/controllers/auth_controller.dart';
import 'package:task_manager/presentation/controllers/image_picker_controller.dart';
import 'package:task_manager/presentation/controllers/update_profile_controller.dart';
import 'package:task_manager/presentation/utils/snackbar.dart';
import 'package:task_manager/presentation/widgets/center_circular_progress_indicator.dart';

import '../widgets/screen_background.dart';
import '../widgets/tm_app_bar_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController _emailTEController = TextEditingController();
  TextEditingController _firstNameTEController = TextEditingController();
  TextEditingController _lastNameTEController = TextEditingController();
  TextEditingController _mobileTEController = TextEditingController();
  TextEditingController _passwordTEController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  UpdateProfileController uPController = Get.find<UpdateProfileController>();
  // XFile? _pickedImage;
  // bool _updateProfileInProgress = false;

  @override
  void initState() {
    super.initState();
    _setUserData();
  }
  void _setUserData(){
    _emailTEController.text = AuthController.userData?.email ?? " ";
    _firstNameTEController.text = AuthController.userData?.firstName ?? " ";
    _lastNameTEController.text = AuthController.userData?.lastName ?? " ";
    _mobileTEController.text = AuthController.userData?.mobile ?? " ";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TMAppBar(isOnProfileScreen: true,),
      body: ScreenBackground(
        child:
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 56,),
                Text("Update Profile",
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold),),
                const SizedBox(height: 32,),
                _buildPhotoPicker(),
                const SizedBox(height: 12,),
                buildProfileFormMethod(),
                GetBuilder<UpdateProfileController>(
                  builder: (controller) {
                    return Visibility(
                      visible: !controller.inProgress,
                      replacement: const CenterCircularProgressIndicator(),
                      child: ElevatedButton(
                          onPressed: (){
                            if(_formKey.currentState!.validate()){
                              _postUpdateProfile();
                            }
                          },
                          child: const Icon(Icons.arrow_circle_right_outlined, color: Colors.white,)),
                    );
                  }
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _postUpdateProfile()async {
    final bool result = await uPController.postUpdateProfile(
        _emailTEController.text.trim(),
        _firstNameTEController.text.trim(),
        _lastNameTEController.text.trim(),
        _mobileTEController.text.trim(),
        _passwordTEController.text,
    );
    // _updateProfileInProgress = true;
    // setState(() {});

    // Map<String, dynamic> reqBody ={
    //   "email":_emailTEController.text,
    //   "firstName": _firstNameTEController.text.trim(),
    //   "lastName": _lastNameTEController.text.trim(),
    //   "mobile": _mobileTEController.text.trim(),
    // };
    // if(_passwordTEController.text.isNotEmpty){
    //   reqBody["password"] = _passwordTEController.text;
    // }
    // if(_pickedImage != null){
    //   List<int> imageBytes = await _pickedImage!.readAsBytes();
    //   String convertedImage = base64Encode(imageBytes);
    //   reqBody["photo"] = convertedImage;
    // }
    //
    // final NetworkResponse response = await NetworkCaller.postRequest(
    //   url: Urls.updateProfile,
    //   body: reqBody,
    // );

    // _updateProfileInProgress = false;
    // setState(() {});
    if(result){
      // UserModel userModel = UserModel.fromJson(response.responseData);
      // AuthController.saveUserData(userModel);
      showSnackBarMessage(context, "Profile has been updated");
    }else{
      debugPrint("there is the issue");
      showSnackBarMessage(context, uPController.errorMessage!, true);
    }
  }

  Widget buildProfileFormMethod() {
    return Form(
      key: _formKey,
      child:
      Column(
        children: [
          TextFormField(
            controller: _emailTEController,
            enabled: false,
            decoration: const InputDecoration(
              hintText: "Email",
            ),
          ),
          const SizedBox(height: 12,),
          TextFormField(
            controller: _firstNameTEController,
            validator: (String? value){
              if(value?.trim().isEmpty?? true){
                return "Enter your first name";
              }
              return null;
            },
            decoration: const InputDecoration(
              hintText: "First Name",
            ),
          ),
          const SizedBox(height: 12,),
          TextFormField(
            controller: _lastNameTEController,
            validator: (String? value){
              if(value?.trim().isEmpty ?? true){
                return "Enter your last name";
              }return null;
            },
            decoration: const InputDecoration(
              hintText: "Last Name",
            ),
          ),
          const SizedBox(height: 12,),
          TextFormField(
            controller: _mobileTEController,
            validator: (String? value){
              if(value?.trim().isEmpty ?? true){
                return "Enter your mobile NO.";
              }return null;
            },
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              hintText: "Mobile",
            ),
          ),
          const SizedBox(height: 12,),
          TextFormField(
            obscureText: true,
            controller: _passwordTEController,
            decoration: const InputDecoration(
              hintText: "Password",
            ),
          ),
          const SizedBox(height: 32,),
        ],
      ),
    );
  }

  Widget _buildPhotoPicker() {
    return GestureDetector(
      onTap: _imagePicker,
      child: Container(
                  height: kToolbarHeight,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Colors.white
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 100,
                        decoration: const BoxDecoration(
                            color: Color(0xff666666),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(6),
                                bottomLeft: Radius.circular(6)
                        )
                      ),
                        child: const Center(
                          child: Text("Photos", style: TextStyle(
                              color: Color(0xffE8E8E8)
                      ),
                          ),
                        ),
                    ),
                      const SizedBox(width: 12,),
                      GetBuilder<ImagePickerController>(
                        builder: (controller) {
                          return Text(controller.pickedImage!= null? controller.pickedImage!.name : "Select an image");
                        }
                      ),
                    ],
                  ),
                ),
    );
  }

  String _getSelectedImageTitle(){
    if(uPController.pickedImage !=null){
      return uPController.pickedImage!.name;
    }
    return "Select an image";
  }

  Future<void> _imagePicker()async {
    final bool result = await Get.find<ImagePickerController>().imagePicker();
    if(result){
      uPController.pickedImage = Get.find<ImagePickerController>().pickedImage;
      debugPrint("I didn't get the image");
    }
  }
  // Future<void> _imagePicker()async {
  //   ImagePicker imagePicker = ImagePicker();
  //   final XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);
  //   if(image!=null){
  //     // _pickedImage = image;
  //     uPController.pickedImage = image;
  //     setState(() {});
  //   }
  // }

  @override
  void dispose() {
    _emailTEController.dispose();
    _firstNameTEController.dispose();
    _lastNameTEController.dispose();
    _mobileTEController.dispose();
    _passwordTEController.dispose();
    super.dispose();
  }
}
