import 'package:flutter/material.dart';
import 'package:project_nbt/apis/constant_and_services/api_services.dart';
import 'package:project_nbt/apis/modals/auth/signin/sign_verify_otp.dart';
import 'package:project_nbt/apis/providers/auth/sign_in_provider.dart';
import 'package:provider/provider.dart';

class CreateProfileProvider with ChangeNotifier {
  final ApiService service = ApiService();

  String? errorMessage;
  bool isLoading = false;

  final TextEditingController userNameController = TextEditingController();

  final TextEditingController displayNameController = TextEditingController();

  final TextEditingController pronounController = TextEditingController();

  final TextEditingController dateOfBirthController = TextEditingController();

  Future<bool> createProfile({
    required BuildContext context,
    required String username,
    required String displayName,
    required String fullName,
    required String dateOfBirth,
  }) async {
    final signInProvider = context.read<SignInProvider>();

    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final response = await service.createProfile(
        username,
        displayName,
        fullName,
        dateOfBirth,
      );

      if (response.success) {
        await signInProvider.saveUser(response.user);

        debugPrint('CREATE PROFILE: User saved successfully');

        debugPrint('CREATE PROFILE: ${response.user.username}');

        return true;
      }

      errorMessage = response.message;
      return false;
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');

      debugPrint('CREATE PROFILE ERROR: $errorMessage');

      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    userNameController.dispose();
    displayNameController.dispose();
    pronounController.dispose();
    dateOfBirthController.dispose();

    super.dispose();
  }
}
