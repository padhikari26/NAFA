// import 'dart:developer';
// import 'dart:io';
// import 'package:country/country.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:nafausa/app/theme/theme.dart';
// import 'package:nafausa/app/utils/size_config.dart';
// import 'package:nafausa/core/controller/bloc/global/global_bloc.dart';
// import 'package:nafausa/features/auth/models/register_request_model.dart';
// import 'package:nafausa/shared/widgets/button/custom_button.dart';
// import 'package:nafausa/shared/widgets/country_selector.dart';
// import 'package:nafausa/shared/widgets/custom_scaffold.dart';
// import 'package:nafausa/shared/widgets/loading.dart';
// import '../../../app/utils/constants.dart';
// import '../../../app/utils/helper.dart';
// import '../../../shared/widgets/formfields/custom_material_form_field.dart';
// import '../controllers/bloc/auth_bloc.dart';
// import 'com/profile_picture_selector.dart'; // Adjust import path

// class ProfileUpdateScreen extends StatefulWidget {
//   const ProfileUpdateScreen({super.key});

//   @override
//   State<ProfileUpdateScreen> createState() => _ProfileUpdateScreenState();
// }

// class _ProfileUpdateScreenState extends State<ProfileUpdateScreen> {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _addressLine1Controller = TextEditingController();
//   final TextEditingController _addressLine2Controller = TextEditingController();
//   final TextEditingController _cityController = TextEditingController();
//   final TextEditingController _stateController = TextEditingController();
//   final TextEditingController _zipCodeController = TextEditingController();
//   final TextEditingController _countryController = TextEditingController();

//   File? _pickedImage;
//   final ImagePicker _picker = ImagePicker();
//   Country? _selectedCountry;

//   @override
//   void initState() {
//     if (globalBloc.state.user != null) {
//       final user = globalBloc.state.user;
//       _nameController.text = user?.name ?? '';
//       _emailController.text = user?.email ?? '';
//       _phoneController.text = user?.phone ?? '';
//       _addressLine1Controller.text = user?.addressLine1 ?? '';
//       _addressLine2Controller.text = user?.addressLine2 ?? '';
//       _cityController.text = user?.city ?? '';
//       _stateController.text = user?.state ?? '';
//       _zipCodeController.text = user?.zipCode ?? '';
//       _countryController.text = user?.country ?? '';
//       log('Selected country: ${user?.country}');
//       _selectedCountry = Countries.values.firstWhere(
//         (country) => country.isoShortName == user?.country,
//         orElse: () => Countries.usa, // Default to USA if not found
//       );
//     }
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _emailController.dispose();
//     _phoneController.dispose();
//     _addressLine1Controller.dispose();
//     _addressLine2Controller.dispose();
//     _cityController.dispose();
//     _stateController.dispose();
//     _zipCodeController.dispose();
//     _countryController.dispose();
//     super.dispose();
//   }

//   void _saveChanges() {
//     FocusScope.of(context).unfocus();
//     context.read<AuthBloc>().add(UpdateProfileEvent(
//           id: globalBloc.state.user?.id ?? "",
//           data: RegisterRequestModel(
//             email: _emailController.text,
//             name: _nameController.text,
//             phone: _phoneController.text,
//             addressLine1: _addressLine1Controller.text,
//             addressLine2: _addressLine2Controller.text,
//             city: _cityController.text,
//             state: _stateController.text,
//             zipCode: _zipCodeController.text,
//             country: _selectedCountry?.isoShortName,
//           ),
//           photo: _pickedImage,
//         ));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return CustomScaffold(
//       backgroundColor: Colors.grey[50],
//       title: "Edit Profile",
//       showBackButton: true,
//       body: BlocBuilder<AuthBloc, AuthState>(
//         builder: (context, state) {
//           return Processing(
//             loading: state.isLoading,
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
//               child: Column(
//                 children: [
//                   ProfilePictureSelector(
//                     imageUrl: "${AppEnviro.imageUrl}/${globalBloc.state.user?.photo?.path}",
//                     imageFile: _pickedImage,
//                     onImagePickRequested: () {
//                       Helper.pickImage().then((image) {
//                         if (image != null) {
//                           setState(() {
//                             _pickedImage = File(image.path);
//                           });
//                         }
//                       });
//                     },
//                   ),
//                   SizedBox(height: 2.hs),
//                   Container(
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(16),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withAlpha(20),
//                           blurRadius: 15,
//                           offset: const Offset(0, 5),
//                         ),
//                       ],
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(24),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Personal Information',
//                             style: context.titleMedium?.copyWith(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 16.fs,
//                               color: Colors.grey[800],
//                             ),
//                           ),
//                           SizedBox(height: 2.hs),
//                           CustomMaterialFormField(
//                             controller: _nameController,
//                             labelText: 'Name',
//                             hintText: 'John Doe',
//                           ),
//                           SizedBox(height: 1.hs),
//                           CustomMaterialFormField(
//                             controller: _emailController,
//                             labelText: 'Email',
//                             hintText: 'john.doe@example.com',
//                             keyboardType: TextInputType.emailAddress,
//                             isReadOnly: true, // Readable but not editable
//                           ),
//                           SizedBox(height: 1.hs),
//                           CustomMaterialFormField(
//                             controller: _phoneController,
//                             labelText: 'Phone',
//                             hintText: '+1 (555) 123-4567',
//                             keyboardType: TextInputType.phone,
//                             isReadOnly: true, // Readable but not editable
//                           ),
//                           SizedBox(height: 2.hs),
//                           Text(
//                             'Address Information',
//                             style: context.titleMedium?.copyWith(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 16.fs,
//                               color: Colors.grey[800],
//                             ),
//                           ),
//                           const SizedBox(height: 20),
//                           CustomMaterialFormField(
//                             controller: _addressLine1Controller,
//                             labelText: 'Address Line 1',
//                             hintText: 'Street address, P.O. Box',
//                           ),
//                           const SizedBox(height: 16),
//                           CustomMaterialFormField(
//                             controller: _addressLine2Controller,
//                             labelText: 'Address Line 2',
//                             hintText: 'Apartment, suite, unit, building',
//                           ),
//                           const SizedBox(height: 16),
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: CustomMaterialFormField(
//                                   controller: _cityController,
//                                   labelText: 'City',
//                                   hintText: 'Kathmandu',
//                                 ),
//                               ),
//                               const SizedBox(width: 16),
//                               Expanded(
//                                 child: CustomMaterialFormField(
//                                   controller: _stateController,
//                                   labelText: 'State/Province',
//                                   hintText: 'Bagmati',
//                                 ),
//                               ),
//                             ],
//                           ),
//                           SizedBox(width: 1.hs),
//                           CustomMaterialFormField(
//                             controller: _zipCodeController,
//                             labelText: 'Zip Code',
//                             hintText: '44600',
//                             keyboardType: TextInputType.number,
//                           ),
//                           SizedBox(width: 1.hs),
//                           CountryFormField(
//                               initialValue: _selectedCountry,
//                               onChanged: (value) {
//                                 setState(() {
//                                   _selectedCountry = value;
//                                   _countryController.text = value.isoShortName;
//                                 });
//                               }),
//                           SizedBox(height: 2.hs),
//                           // SizedBox(
//                           //   width: double.infinity,
//                           //   child: ElevatedButton(
//                           //     onPressed: _saveChanges,
//                           //     style: ElevatedButton.styleFrom(
//                           //       padding: const EdgeInsets.symmetric(vertical: 16),
//                           //       shape: RoundedRectangleBorder(
//                           //           borderRadius: BorderRadius.circular(12)),
//                           //       backgroundColor: AppColors.nepalBlue,
//                           //       foregroundColor: Colors.white,
//                           //       elevation: 5,
//                           //     ),
//                           //     child: Text(
//                           //       'Save Changes',
//                           //       style: context.titleMedium?.copyWith(
//                           //         fontSize: 18.fs,
//                           //         fontWeight: FontWeight.bold,
//                           //         color: Colors.white,
//                           //       ),
//                           //     ),
//                           //   ),
//                           // ),

//                           CustomButton.filled(
//                             isLoading: state.isLoading,
//                             width: double.maxFinite,
//                             text: 'Update',
//                             onPressed: _saveChanges,
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
