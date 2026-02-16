import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nafausa/app/utils/size_config.dart';
import 'package:nafausa/shared/widgets/loading.dart';
import '../../../app/utils/app_colors.dart';
import '../controllers/bloc/auth_bloc.dart';

class AuthScreen extends StatefulWidget {
  final bool isLogin;
  const AuthScreen({super.key, this.isLogin = true});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Controllers
  final _membershipIdController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cityController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic),
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _membershipIdController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return Processing(
              loading: state.isLoading,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primaryGradient.colors.first,
                      AppColors.primaryGradient.colors.last,
                    ],
                  ),
                ),
                child: SafeArea(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height -
                        MediaQuery.of(context).padding.top,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10.hs,
                          width: double.infinity,
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: CustomPaint(
                                  painter: NepalPatternPainter(),
                                ),
                              ),
                              // Logo
                              Center(
                                child: FadeTransition(
                                  opacity: _fadeAnimation,
                                  child: Image.asset(
                                    'assets/logo.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: SlideTransition(
                            position: _slideAnimation,
                            child: FadeTransition(
                              opacity: _fadeAnimation,
                              child: Container(
                                margin: const EdgeInsets.all(18),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(24),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withAlpha(25),
                                      blurRadius: 30,
                                      offset: const Offset(0, 15),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(18),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Center(
                                          child: Text(
                                            'Welcome to NAFA',
                                            style: TextStyle(
                                              fontSize: 20.fs,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.nepalBlue,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 1.5.hs),
                                        Form(
                                          key: _formKey,
                                          child: _buildEnhancedForm(),
                                        ),
                                        SizedBox(height: 4.hs),
                                        Container(
                                          width: double.infinity,
                                          height: 56,
                                          decoration: BoxDecoration(
                                            gradient: const LinearGradient(
                                              colors: [
                                                AppColors.nepalBlue,
                                                AppColors.nepalRed
                                              ],
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            boxShadow: [
                                              BoxShadow(
                                                color: AppColors.nepalBlue
                                                    .withAlpha(73),
                                                blurRadius: 15,
                                                offset: const Offset(0, 8),
                                              ),
                                            ],
                                          ),
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              onTap: () {
                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  _handleLogin();
                                                }
                                              },
                                              child: Center(
                                                child: Text(
                                                  'Continue',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15.fs,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildEnhancedForm() {
    return Column(
      children: [
        _buildEnhancedFormField(
          controller: _nameController,
          label: 'Full Name',
          hint: 'Enter your full name',
          icon: Icons.person_outline,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Name is required';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        _buildEnhancedFormField(
          controller: _phoneController,
          label: 'Phone Number',
          hint: 'Enter your phone number',
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Phone number is required';
            }
            if (value.length != 10) {
              return 'Enter a valid phone number';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        _buildEnhancedFormField(
          controller: _cityController,
          label: 'City',
          hint: 'Enter your city',
          icon: Icons.location_city_outlined,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'City is required';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        _buildEnhancedFormField(
          controller: _membershipIdController,
          label: 'Authorization Code',
          hint: 'Enter your authorization code',
          icon: Icons.card_membership_outlined,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Authorization code is required';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildEnhancedFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    TextCapitalization? textCapitalization,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.nepalBlue,
          ),
        ),
        SizedBox(height: 0.5.hs),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            textCapitalization: textCapitalization ?? TextCapitalization.none,
            validator: validator,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: Colors.grey.shade500,
                fontWeight: FontWeight.normal,
              ),
              prefixIcon: Icon(
                icon,
                color: AppColors.nepalBlue,
                size: 22,
              ),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
          ),
        ),
      ],
    );
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      context.read<AuthBloc>().add(LoginSubmitEvent(
          name: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
          city: _cityController.text.trim(),
          loginCode: _membershipIdController.text.trim()));
    }
  }
}

class NepalPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withAlpha(25)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    // Draw subtle geometric pattern inspired by Nepalese motifs
    for (int i = 0; i < 5; i++) {
      for (int j = 0; j < 3; j++) {
        final center = Offset(
          (size.width / 6) * (i + 1),
          (size.height / 4) * (j + 1),
        );

        // Draw diamond shapes
        final path = Path();
        path.moveTo(center.dx, center.dy - 8);
        path.lineTo(center.dx + 8, center.dy);
        path.lineTo(center.dx, center.dy + 8);
        path.lineTo(center.dx - 8, center.dy);
        path.close();

        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
