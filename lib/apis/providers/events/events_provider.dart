import 'package:flutter/material.dart';
import 'package:project_nbt/apis/constant_and_services/api_services.dart';

class EventsProvider with ChangeNotifier {
  final ApiService service = ApiService();

  String? errorMessage;
  bool isLoading = false;

  final TextEditingController titleController = TextEditingController();

  final TextEditingController descriptionController = TextEditingController();

  final TextEditingController whatToExpectController = TextEditingController();

  final TextEditingController organizerNoteController = TextEditingController();
  final TextEditingController eventDateController = TextEditingController();
  final TextEditingController venueNameController = TextEditingController();
  final TextEditingController venueAddressNoteController =
      TextEditingController();
  final TextEditingController posterUrlNoteController = TextEditingController();

  Future<bool> createEvents({
    required BuildContext context,
    required String title,
    required String description,
    required String whatToExpect,
    required String organizerNote,
    required String eventDate,
    required String venueName,
    required String venueAddress,
    required String posterUrl,
  }) async {
    // final signInProvider = context.read<SignInProvider>();

    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final response = await service.createEvent(
        title,
        description,
        whatToExpect,
        organizerNote,
        eventDate,
        venueName,
        venueAddress,
        posterUrl,
      );

      if (response.success) {
        // await signInProvider.saveUser(response.user);

        debugPrint('CREATE PROFILE: User saved successfully');

        // debugPrint('CREATE PROFILE: ${response.}');

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
    titleController.dispose();
    descriptionController.dispose();
    whatToExpectController.dispose();
    organizerNoteController.dispose();
    eventDateController.dispose();
    venueNameController.dispose();
    venueAddressNoteController.dispose();
    posterUrlNoteController.dispose();

    super.dispose();
  }
}
