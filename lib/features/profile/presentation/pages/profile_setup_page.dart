// lib/features/profile/presentation/pages/profile_setup_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/profile_provider.dart';

class ProfileSetupPage extends ConsumerStatefulWidget {
  const ProfileSetupPage({super.key});

  @override
  ConsumerState<ProfileSetupPage> createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends ConsumerState<ProfileSetupPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  String? _selectedFaith;

  final List<String> faiths = [
    'Christianity',
    'Islam',
    'Judaism',
    'Other'
  ];

  Future<void> _completeSetup() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await ref.read(profileProvider.notifier).completeProfile(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        faith: _selectedFaith!,
      );

      if (mounted) {
        context.go('/home');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Setup failed: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Profile'),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),
                Text(
                  'Complete Your Profile',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Tell us about yourself',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.grey,
                  ),
                ),
                const SizedBox(height: 48),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                Text(
                  'Faith',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.lightBlue.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.lightBlue.withOpacity(0.2),
                    ),
                  ),
                  child: Column(
                    children: faiths.map((faith) {
                      return RadioListTile<String>(
                        title: Text(faith),
                        value: faith,
                        groupValue: _selectedFaith,
                        onChanged: (value) {
                          setState(() {
                            _selectedFaith = value;
                          });
                        },
                        activeColor: AppColors.primary,
                        contentPadding: EdgeInsets.zero,
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _selectedFaith == null ? null : _completeSetup,
                  child: const Text('Continue'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
