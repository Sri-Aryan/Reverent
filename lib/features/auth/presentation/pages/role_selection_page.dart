// lib/features/auth/presentation/pages/role_selection_page.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';

class RoleSelectionPage extends StatelessWidget {
  const RoleSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Container(
                width: 200,
                height: 200,
                child: Image.asset('assets/images/app_logo1.jpg',height: 40,width: 40,),
              ),
              const SizedBox(height: 64),
              Text(
                'Reverent',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: 12),
              Text(
                'A platform where Worshipers connect with their Religious Leaders.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.grey,
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  context.push('/auth/login?role=worshiper');
                },
                child: const Text('Continue as Worshiper'),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () {
                  context.push('/auth/login?role=religious_leader');
                },
                child: const Text('Continue as Religious Leader'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
