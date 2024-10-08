
import 'package:get/get.dart';
import 'package:koi_farm/models/response.model.dart';
import 'package:koi_farm/models/signup_body_model.dart';
import 'package:koi_farm/data/repository/auth_repo.dart';

class AuthController extends GetxController implements GetxService {
  final AuthRepo authRepo;
  AuthController({required this.authRepo});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<ResponseModel> registration(SignUpBody signUpBody) async {
    _isLoading = true;
    update();
    Response response = await authRepo.registration(signUpBody);
    late ResponseModel responseModel;
    if (response.statusCode == 200) {
      //code 200 means no error
      authRepo.saveUserToken(response.body["token"]);
      responseModel = ResponseModel(true, response.body["token"]);
    } else {
      responseModel = ResponseModel(false, response.body["errors"][0]["message"]);
      print(response.statusCode);
      print(response.statusText);
      print("authController above");
    }
    _isLoading = false;
    //update for changes on front end
    update();
    return responseModel;
  }

  Future<ResponseModel> login(String email, String password) async {
    print("Getting token");
    authRepo.getUserToken().toString();
    print(authRepo.getUserToken().toString());
    _isLoading = true;
    update();
    Response response = await authRepo.login(email, password);
    late ResponseModel responseModel;
    if (response.statusCode == 200) {
      print("Backend token");
      //code 200 means no error

      authRepo.saveUserToken(response.body["token"]);
      print(response.body["token"].toString());
      responseModel = ResponseModel(true, response.body["token"]);
    } else {
      responseModel = ResponseModel(false, response.body["errors"][0]["message"]);
      print("failed response model");
      print(response.statusCode);
      print(response.body["token"].toString());
      print(authRepo.getUserToken().toString());
    }
    _isLoading = false;
    // or true
    //update for changes on front end
    update();
    return responseModel;
  }

  void saveUserNumberAndPassword(String number, String password) {
    authRepo.saveUserNumberAndPassword(number, password);
  }

  bool userLoggedIn() {
    return authRepo.userLoggedIn();
  }

  bool clearSharedData() {
    return authRepo.clearSharedData();
  }
}
