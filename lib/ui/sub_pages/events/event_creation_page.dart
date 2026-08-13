import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_nbt/apis/providers/events/events_provider.dart';
import 'package:project_nbt/ui/components/buttons/secondary_button.dart';
import 'package:project_nbt/ui/components/custom_navigation_bar/custom_navigation_bar.dart';
import 'package:project_nbt/ui/components/text_feild/primary_text_feild.dart';
import 'package:provider/provider.dart';

class EventsCreationForm extends StatefulWidget {
  const EventsCreationForm({super.key});

  @override
  State<EventsCreationForm> createState() => _EventsCreationFormState();
}

class _EventsCreationFormState extends State<EventsCreationForm> {
  late final eventProvider = context.read<EventsProvider>();

  @override
  void dispose() {
    eventProvider.titleController.dispose();
    eventProvider.descriptionController.dispose();
    eventProvider.eventDateController.dispose();
    eventProvider.venueAddressNoteController.dispose();
    eventProvider.venueNameController.dispose();
    eventProvider.whatToExpectController.dispose();
    eventProvider.organizerNoteController.dispose();
    super.dispose();
  }

  void _validateAndProceed() async {
    final eventProvider = context.read<EventsProvider>();
    final title = eventProvider.titleController.text.trim();
    final eventDate = eventProvider.eventDateController.text.trim();
    final eventVenue = eventProvider.venueNameController.text.trim();
    final eventVenueLocation = eventProvider.venueAddressNoteController.text
        .trim();
    final eventDescription = eventProvider.descriptionController.text.trim();
    final whatToExpect = eventProvider.whatToExpectController.text.trim();
    final organizerNote = eventProvider.organizerNoteController.text.trim();

    if (title.isEmpty) {
      _showErrorNotification(
        "Event Creation",
        "Please enter a valid event title.",
      );
      return;
    }
    if (eventDate.isEmpty) {
      _showErrorNotification(
        "Event Creation",
        "Please enter your display name.",
      );
      return;
    }
    if (eventVenue.isEmpty) {
      _showErrorNotification(
        "Event Creation",
        "Please enter your display name.",
      );
      return;
    }
    if (eventVenueLocation.isEmpty) {
      _showErrorNotification(
        "Event Creation",
        "Please enter your display name.",
      );
      return;
    }
    if (eventDescription.isEmpty) {
      _showErrorNotification(
        "Event Creation",
        "Please enter your display name.",
      );
      return;
    }
    if (whatToExpect.isEmpty) {
      _showErrorNotification(
        "Event Creation",
        "Please enter your display name.",
      );
      return;
    }
    if (organizerNote.isEmpty) {
      _showErrorNotification(
        "Event Creation",
        "Please enter your display name.",
      );
      return;
    }

    final success = await eventProvider.createEvents(
      context: context,
      title: title,
      description: eventDescription,
      whatToExpect: whatToExpect,
      organizerNote: organizerNote,
      eventDate: eventDate,
      venueName: eventVenue,
      venueAddress: eventVenueLocation,
      posterUrl: "",
    );

    if (!mounted) return;

    if (success) {
      _showSuccessNotification(context);
      eventProvider.titleController.clear();
      eventProvider.descriptionController.clear();
      eventProvider.eventDateController.clear();
      eventProvider.venueAddressNoteController.clear();
      eventProvider.venueNameController.clear();
      eventProvider.whatToExpectController.clear();
      eventProvider.organizerNoteController.clear();

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CustomNavigationBar()),
      );
    } else {
      _showErrorNotification(
        "Profile Creation Failed",
        eventProvider.errorMessage ??
            "Could not create profile. Please try again.",
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final eventProvider = context.read<EventsProvider>();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2105),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: Theme.of(context).colorScheme.primary,
              onPrimary: Theme.of(context).colorScheme.onPrimary,
              onSurface: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      final day = picked.day.toString().padLeft(2, '0');
      final month = picked.month.toString().padLeft(2, '0');
      final year = picked.year.toString();
      setState(() {
        // FIX: this used to write to a separate, unused `_dobController`
        // while the visible TextField was bound to
        // createProfileProvider.dateOfBirthController — so the picked date
        // never showed up on screen and validation always saw an empty
        // string. Now it writes to the same controller the field displays.
        eventProvider.eventDateController.text = "$day/$month/$year";
      });
    }
  }

  void _showSuccessNotification(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    OverlayState? overlayState = Overlay.of(context);
    OverlayEntry? overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 10,
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.inverseSurface.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle_outline,
                    color: theme.inverseSurface,
                    size: 28,
                  ),
                ),
                SizedBox(width: 16),
                Container(
                  width: 1,
                  height: 40,
                  color: theme.outline.withOpacity(0.3),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Event Created",
                        style: GoogleFonts.k2d(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: theme.inverseSurface,
                        ),
                      ),
                      Text(
                        "Your event is created successfully.",
                        style: GoogleFonts.k2d(
                          fontSize: 12,
                          color: theme.tertiary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    overlayState.insert(overlayEntry);
    Future.delayed(Duration(seconds: 3), () {
      overlayEntry?.remove();
    });
  }

  // Future<void> _selectDate(BuildContext context) async {
  //   // Remove the time component
  //   final DateTime today = DateTime(
  //     DateTime.now().year,
  //     DateTime.now().month,
  //     DateTime.now().day,
  //   );
  //
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: today,
  //     firstDate: today,
  //     lastDate: DateTime(today.year + 10, 12, 31),
  //     builder: (context, child) {
  //       return Theme(
  //         data: Theme.of(context).copyWith(
  //           colorScheme: Theme.of(context).colorScheme.copyWith(
  //             primary: Theme.of(context).colorScheme.primary,
  //             onPrimary: Theme.of(context).colorScheme.onPrimary,
  //             surface: Theme.of(context).colorScheme.surface,
  //             onSurface: Theme.of(context).colorScheme.onSurface,
  //           ),
  //           datePickerTheme: DatePickerThemeData(
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(24),
  //             ),
  //           ),
  //         ),
  //         child: child!,
  //       );
  //     },
  //   );
  //
  //   if (picked != null) {
  //     setState(() {
  //       _dateController.text =
  //           "${picked.day.toString().padLeft(2, '0')}/"
  //           "${picked.month.toString().padLeft(2, '0')}/"
  //           "${picked.year}";
  //     });
  //   }
  // }

  void _showErrorNotification(String title, String subtitle) {
    final theme = Theme.of(context).colorScheme;
    OverlayState? overlayState = Overlay.of(context);
    OverlayEntry? overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 10,
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.onInverseSurface,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.error.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.info_outline, color: theme.error, size: 28),
                ),
                const SizedBox(width: 16),
                Container(
                  width: 1,
                  height: 40,
                  color: theme.outline.withOpacity(0.3),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.k2d(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: theme.error,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: GoogleFonts.k2d(
                          fontSize: 12,
                          color: theme.tertiary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    overlayState.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 3), () {
      overlayEntry?.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: theme.surface,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Consumer<EventsProvider>(
                builder: (BuildContext context, eventProvider, child) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 60),
                      // Top Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Create your next experience",
                                style: GoogleFonts.k2d(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                "Event Details",
                                style: GoogleFonts.k2d(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Icon(
                              Icons.calendar_month,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      // Intro Card
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.event_note_outlined,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Plan with clarity",
                                    style: GoogleFonts.k2d(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    "Fill in the essentials for a polished event page",
                                    style: GoogleFonts.k2d(
                                      fontSize: 14,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Form Fields
                      _buildSectionLabel("Event title"),
                      PrimaryTextField(
                        controller: eventProvider.titleController,
                        hintText: "Summer Networking Night",
                      ),

                      const SizedBox(height: 20),
                      _buildSectionLabel("Event date"),
                      PrimaryTextField(
                        controller: eventProvider.eventDateController,
                        readOnly: true,
                        hintText: "Friday, Aug 22, 2026",
                        onTap: () => _selectDate(context),
                        suffixIcon: const Icon(
                          Icons.calendar_today_outlined,
                          size: 18,
                        ),
                      ),

                      const SizedBox(height: 20),
                      _buildSectionLabel("Event venue"),
                      PrimaryTextField(
                        controller: eventProvider.venueNameController,
                        hintText: "The Grand Hall",
                      ),

                      const SizedBox(height: 20),
                      _buildSectionLabel("Event venue location / address"),
                      PrimaryTextField(
                        controller: eventProvider.venueAddressNoteController,
                        hintText:
                            "123 Market Street, Downtown, San Francisco, CA",
                        maxLine: 3,
                      ),

                      const SizedBox(height: 20),
                      _buildSectionLabel("Event description"),
                      PrimaryTextField(
                        controller: eventProvider.descriptionController,
                        hintText:
                            "Share the purpose, agenda, and highlights of your event.",
                        maxLine: 4,
                      ),

                      const SizedBox(height: 20),
                      _buildSectionLabel("What to expect in event"),
                      PrimaryTextField(
                        controller: eventProvider.whatToExpectController,
                        hintText:
                            "Key sessions, networking, refreshments, live demos, and more.",
                        maxLine: 3,
                      ),

                      const SizedBox(height: 20),
                      _buildSectionLabel("Organizer's note"),
                      PrimaryTextField(
                        controller: eventProvider.organizerNoteController,
                        hintText:
                            "Add a warm note, reminders, or special instructions for attendees.",
                        maxLine: 3,
                      ),

                      const SizedBox(height: 20),
                      _buildSectionLabel("Event poster"),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.add_photo_alternate_outlined,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Upload a poster or cover image",
                                    style: GoogleFonts.k2d(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Use a clear visual to make the event stand out",
                                    style: GoogleFonts.k2d(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.grey.shade50,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                "Choose File",
                                style: GoogleFonts.k2d(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Venue Preview
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade50,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.location_on_outlined,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Venue preview",
                                        style: GoogleFonts.k2d(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        "Make sure the address is accurate for guests and navigation",
                                        style: GoogleFonts.k2d(
                                          fontSize: 14,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.network(
                                "https://api.a0.dev/assets/image?text=a%20detailed%203d%20city%20map%20with%20green%20parks%20and%20rivers&aspect=16:9",
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  );
                },
              ),
            ),
          ),
          // Bottom Action Bar
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            decoration: BoxDecoration(
              color: theme.onInverseSurface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: SecondaryButton(
                    text: "Save Draft",
                    onPressed: () {},
                    color: theme.tertiary.withOpacity(0.1),
                    borderColor: theme.tertiary,
                    textColor: theme.inversePrimary,
                    borderRadius: 15,
                    height: 52,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SecondaryButton(
                    text: "Publish Event",
                    borderRadius: 15,
                    onPressed: _validateAndProceed,
                    height: 52,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4),
      child: Text(
        label,
        style: GoogleFonts.k2d(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }
}
