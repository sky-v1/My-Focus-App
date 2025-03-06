import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_focus/core/providers/auth_provider.dart';
import 'package:my_focus/routes/app_routes.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  bool _isLoading = false;
  bool _isGoogleLoading = false;
  bool _showGoogleSignupPrompt = false;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Check if there's a pending Google auth
    _checkPendingGoogleAuth();
  }

  void _checkPendingGoogleAuth() {
    final authState = ref.read(authStateProvider);
    if (authState.isPendingGoogleAuth) {
      setState(() {
        _showGoogleSignupPrompt = true;
      });
    }
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   // Check for authenticated state and navigate if needed
  //   final authState = ref.read(authStateProvider);
  //   if (authState.isAuthenticated && !authState.isInitializing) {
  //     // Navigate to home screen
  //     WidgetsBinding.instance.addPostFrameCallback((_) {
  //       Navigator.pushReplacementNamed(context, '/home');
  //     });
  //   }
  // }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style:
              TextStyle(color: Theme.of(context).colorScheme.onErrorContainer),
        ),
        backgroundColor: Theme.of(context).colorScheme.errorContainer,
      ),
    );
  }

  Future<void> _handleDirectGoogleSignup() async {
    if (_isGoogleLoading) return;
    setState(() => _isGoogleLoading = true);

    try {
      // Call the provider to handle Google sign-up
      final errorMessage =
          await ref.read(authStateProvider.notifier).signInWithGoogle();
      if (errorMessage != null) {
        _showError(errorMessage);
      }
    } catch (e) {
      _showError("Google sign-up failed. Please try again.");
      print("Google sign-up error: $e"); // Developer console log
    } finally {
      if (mounted) setState(() => _isGoogleLoading = false);
    }
  }

  Future<void> _handleInitialSignup() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    FocusScope.of(context).unfocus();
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      _showError("Please fill in all fields.");
      setState(() => _isLoading = false);
      return;
    }

    try {
      final errorMessage = await ref
          .read(authStateProvider.notifier)
          .initializeEmailSignup(username, email, password);

      if (errorMessage != null) {
        _showError(errorMessage);
      } else {
        // Show Google signup prompt if successful
        setState(() {
          _showGoogleSignupPrompt = true;
        });
      }
    } catch (e) {
      _showError("Sign-up initialization failed. Please try again.");
      print("Username validation error: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleCompleteGoogleSignup() async {
    if (_isGoogleLoading) return;
    setState(() => _isGoogleLoading = true);

    try {
      // Complete the sign-up by linking username with Google account
      final errorMessage = await ref
          .read(authStateProvider.notifier)
          .completeEmailSignupWithGoogle();
      if (errorMessage != null) {
        _showError(errorMessage);
      }
    } catch (e) {
      _showError("Failed to complete sign-up with Google. Please try again.");
      print("Google link error: $e"); // Developer console log
    } finally {
      if (mounted) {
        setState(() {
          _isGoogleLoading = false;
          _showGoogleSignupPrompt = false;
        });
      }
    }
  }

  Future<void> _handleCancelGoogleLink() async {
    await ref.read(authStateProvider.notifier).logout();
    if (mounted) {
      setState(() {
        _showGoogleSignupPrompt = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.primaryContainer,
              colorScheme.surface,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Icon(Icons.favorite, size: 64, color: colorScheme.primary),
                  const SizedBox(height: 24),

                  // Welcome Text
                  Text(
                    'Welcome',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Create an account to continue',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 32),

                  if (_showGoogleSignupPrompt)
                    _buildGoogleAuthPrompt()
                  else
                    _buildSignupForm(),

                  // Log in Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, AuthRoutes.login);
                        },
                        child: const Text('Login'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignupForm() {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                prefixIcon: const Icon(Icons.face),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: const Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: const Icon(Icons.lock),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _isLoading ? null : _handleInitialSignup,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                disabledBackgroundColor: colorScheme.primary.withAlpha((0.6*255).toInt()),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isLoading
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colorScheme.onPrimary,
                      ),
                    )
                  : const Text('Sign Up'),
            ),

            const SizedBox(height: 20),
            const Row(
              children: [
                Expanded(child: Divider()),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('OR'),
                ),
                Expanded(child: Divider()),
              ],
            ),
            const SizedBox(height: 4),

            const Align(
              alignment: Alignment.topLeft,
              child: Text(
                "*Recommended",
                style: TextStyle(fontSize: 12, color: Colors.blueGrey),
              ),
            ),

            // Google Sign-up button
            OutlinedButton.icon(
              onPressed: _isGoogleLoading ? null : _handleDirectGoogleSignup,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                side: BorderSide(color: colorScheme.outline),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: _isGoogleLoading
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  : Image.asset('assets/images/google_logo.png', height: 20),
              label: const Text('Sign up with Google'),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildGoogleAuthPrompt() {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Link with Google',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'To complete your signup, please link your account with Google. This will allow us to access certain features on your behalf.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Complete with Google button
            ElevatedButton.icon(
              onPressed: _isGoogleLoading ? null : _handleCompleteGoogleSignup,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                disabledBackgroundColor:
                    colorScheme.primary.withAlpha((0.6 * 255).toInt()),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: _isGoogleLoading
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colorScheme.onPrimary,
                      ),
                    )
                  : Image.asset('assets/images/google_logo.png',
                      height: 20, color: colorScheme.onPrimary),
              label: const Text('Continue with Google'),
            ),

            const SizedBox(height: 16),

            // Cancel button
            TextButton(
              onPressed: () {
                _handleCancelGoogleLink();
              },
              child: Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}
