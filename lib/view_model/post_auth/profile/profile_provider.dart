import 'dart:io';


import 'package:flutter/material.dart';
import 'package:naai/models/user.dart';
import 'package:naai/services/database.dart';
import 'package:naai/utils/exception/exception_handling.dart';
import 'package:naai/utils/loading_indicator.dart';
import 'package:naai/view/widgets/reusable_widgets.dart';
import 'package:naai/view_model/post_auth/home/home_provider.dart';
import 'package:naai/view_model/pre_auth/authentication_provider.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfileProvider with ChangeNotifier {
  UserModel _userData = UserModel();
  String _imageUrl = '' ;
  //============= GETTERS =============//
  UserModel get userData => _userData;
  String get imageUrl => _imageUrl;

  ///Profile photo upload method
  void uploadProfileImage(BuildContext context) async{

    /*Step 1:Pick image*/
    //Install image_picker
    //Import the corresponding library

    ImagePicker imagePicker = ImagePicker();
    XFile? file =
        await imagePicker.pickImage(source: ImageSource.gallery);
    print('${file?.path}');

    if (file == null) return;
    //Import dart:core
    String uniqueFileName =
        DateTime.now().millisecondsSinceEpoch.toString();

    /*Step 2: Upload to Firebase storage*/
    //Install firebase_storage
    //Import the library


    //Get a reference to storage root
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('user_images/'+_userData.name!+'_'+_userData.id!); //set to user's name username //user id is intententinally added because their can be same username for diffrent user

    //Create a reference for the image to be stored
    Reference referenceImageToUpload =
        referenceDirImages.child(_userData.name!); //Add +uniqueFileName to child incase you want to store old images

    //Handle errors/success
    try {
      //Store the file
      await referenceImageToUpload.putFile(File(file.path));
      //Success: get the download URL
      _imageUrl = await referenceImageToUpload.getDownloadURL();
      await updateUserImage(context,_imageUrl);
    } catch (error) {
      //Some error occurred
    } finally{
      notifyListeners();
    }
  }

  /// Method to set user's imageUrl in Firestore
  // void setImage(String value) {
  //   _imageUrl = value;
  //   notifyListeners();
  // }

  ///Update User's Profile image
  Future<void> updateUserImage(
      BuildContext context,
      String _imageUrl,
      ) async {
    UserModel user = UserModel.fromMap(_userData.toMap());

    user.image = _imageUrl;
    Map<String, dynamic> data = user.toMap();
    Loader.showLoader(context);
    try {
      await DatabaseService().updateUserData(data: data)
      .onError(
              (FirebaseException error, stackTrace) =>
          throw ExceptionHandling(message: error.message ?? ""));
      notifyListeners();
    } catch (e) {
      Loader.hideLoader(context);
      ReusableWidgets.showFlutterToast(
        context,
        '$e',
      );
    }
    notifyListeners();
    Navigator.pop(context);

  }


  /// Get user data from [UserProvider]
  void getUserDataFromUserProvider(BuildContext context) {
    _userData = context.read<HomeProvider>().userData;
    _imageUrl = context.read<HomeProvider>().userData.image! == '' ? 'https://firebasestorage.googleapis.com/v0/b/naai-5d31f.appspot.com/o/user_images%2Fsample_user_img.jpg?alt=media&token=a4f1602d-f70c-4aea-b6da-ee54f9e4c2d5':context.read<HomeProvider>().userData.image!; //|| context.read<HomeProvider>().userData.image
    notifyListeners();
  }

  /// Handle the logout button click event
  void handleLogoutClick(BuildContext context) {
    context.read<AuthenticationProvider>().logout(context);
  }
}
