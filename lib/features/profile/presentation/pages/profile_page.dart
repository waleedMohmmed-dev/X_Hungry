import 'package:hungry_app/core/imports/core_imports.dart';
import 'package:hungry_app/core/imports/packages_imports.dart';
import 'package:hungry_app/core/theme/app_theme.dart';
import 'package:hungry_app/features/auth/presentation/pages/login_page.dart';
import 'package:hungry_app/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:hungry_app/features/profile/presentation/bloc/profile_event.dart';
import 'package:hungry_app/features/profile/presentation/bloc/profile_state.dart';
import 'package:hungry_app/features/profile/presentation/widgets/profile_text_field.dart';
import 'package:hungry_app/features/profile/presentation/widgets/profile_image_action_button.dart';
import 'package:hungry_app/features/profile/presentation/widgets/profile_avatar.dart';
import 'package:hungry_app/features/profile/presentation/widgets/profile_header.dart';
import 'package:hungry_app/features/profile/presentation/widgets/profile_visa_card.dart';
import 'package:hungry_app/features/profile/presentation/widgets/profile_action_buttons.dart';
import 'package:hungry_app/core/shared/widgets/app_button.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _visa = TextEditingController();
  String? selectedImage;

  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(const ProfileInit());
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _address.dispose();
    _visa.dispose();
    super.dispose();
  }

  Future<void> pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedImage != null) {
      setState(() => selectedImage = pickedImage.path);
    }
  }

  void removeImage() {
    setState(() => selectedImage = null);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listenWhen: (prev, curr) => prev.user != curr.user,
      listener: (context, state) {
        if (state.user != null && _name.text.isEmpty) {
          _name.text = state.user!.name;
          _email.text = state.user!.email;
          _address.text = state.user!.address ?? '55 Dubai, UAE';
        }
      },
      builder: (context, state) {
        if (!state.isGuest) {
          return _buildProfileContent(context, state);
        } else {
          return _buildGuestMode(context);
        }
      },
    );
  }

  Widget _buildProfileContent(BuildContext context, ProfileState state) {
    final user = state.user;

    return RefreshIndicator(
      displacement: 40,
      color: Colors.white,
      backgroundColor: AppColors.primaryColor,
      onRefresh: () async {
        context.read<ProfileBloc>().add(const ProfileLoadRequested());
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            toolbarHeight: 0,
            backgroundColor: Colors.white,
            scrolledUnderElevation: 0,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SingleChildScrollView(
              clipBehavior: Clip.none,
              child: Skeletonizer(
                enabled: state.user == null,
                containersColor: AppColors.primaryColor.withValues(alpha: 0.3),
                child: Column(
                  children: [
                    const Gap(10),
                    const ProfileHeader(),
                    ProfileAvatar(user: user, selectedImage: selectedImage),
                    Gap(10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ProfileImageActionButton(
                          label: 'Upload',
                          icon: CupertinoIcons.camera,
                          backgroundColor: const Color.fromARGB(255, 6, 78, 13),
                          onTap: pickImage,
                        ),
                        ProfileImageActionButton(
                          label: 'Remove',
                          icon: CupertinoIcons.trash,
                          backgroundColor: const Color.fromARGB(
                            255,
                            111,
                            2,
                            40,
                          ),
                          onTap: removeImage,
                        ),
                      ],
                    ),
                    Gap(20),
                    ProfileTextField(controller: _name, label: 'Name'),
                    Gap(25),
                    ProfileTextField(controller: _email, label: 'Email'),
                    Gap(25),
                    ProfileTextField(controller: _address, label: 'Address'),
                    Gap(20),
                    const Divider(),
                    Gap(10),
                    user?.visa == null
                        ? ProfileTextField(
                            controller: _visa,
                            textInputType: TextInputType.number,
                            label: 'add VISA CARD',
                          )
                        : ProfileVisaCard(visa: user?.visa),
                    Gap(5),
                    ProfileActionButtons(
                      isSubmitting: state.isSubmitting,
                      name: _name.text.trim(),
                      email: _email.text.trim(),
                      address: _address.text.trim(),
                      selectedImage: selectedImage,
                      visa: _visa.text.trim(),
                    ),
                    Gap(300),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGuestMode(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(child: Text('Guest Mode')),
          Gap(20),
          AppButton(
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginPage()),
            ),
            buttonText: 'Go to Login',
          ),
        ],
      ),
    );
  }
}
