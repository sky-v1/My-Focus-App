import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_focus/core/providers/auth_provider.dart';
import 'package:my_focus/routes/app_routes.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _isLoading = false;
  bool _isGoogleLoading = false;
  final TextEditingController _usernameOrEmailController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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

  Future<void> _handleGoogleLogin() async {
    if (_isGoogleLoading) return;
    setState(() => _isGoogleLoading = true);

    try {
      final errorMessage =
          await ref.read(authStateProvider.notifier).signInWithGoogle();
      if (errorMessage != null) {
        _showError(errorMessage);
      }
    } catch (error) {
      _showError('Google sign-in failed. Please try again.');
      print("Google sign-in error: $error"); // Developer console log
    } finally {
      if (mounted) setState(() => _isGoogleLoading = false);
    }
  }

  Future<void> _handleLogin() async {
    if (_isLoading) return;
    FocusScope.of(context).unfocus(); // Dismiss keyboard

    final String usernameOrEmail = _usernameOrEmailController.text.trim();
    final String password = _passwordController.text.trim();

    if (usernameOrEmail.isEmpty || password.isEmpty) {
      _showError("Please enter both username/email and password.");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final errorMessage = await ref
          .read(authStateProvider.notifier)
          .logInWithEmailPassword(usernameOrEmail, password);

      if (errorMessage != null) {
        _showError(errorMessage);
      }
    } catch (error) {
      _showError("Login failed. Please check your credentials and try again.");
      print("Login error: $error"); // Developer console log
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final authState = ref.watch(authStateProvider);

    if (authState.isInitializing) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

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
                  Icon(
                    Icons.lock_outlined,
                    size: 64,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(height: 24),

                  // Welcome Text
                  Text(
                    'Welcome Back',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'log in to continue',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 32),

                  // Login Card
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextField(
                            controller: _usernameOrEmailController,
                            decoration: InputDecoration(
                              labelText: 'Username or Email',
                              prefixIcon: const Icon(Icons.person_outline),
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
                              prefixIcon: const Icon(Icons.lock_outlined),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                    context, AuthRoutes.forgotPassword);
                              },
                              child: const Text('Forgot Password?'),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: _isLoading ? null : _handleLogin,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              backgroundColor: colorScheme.primary,
                              foregroundColor: colorScheme.onPrimary,
                              disabledBackgroundColor:
                                  colorScheme.primary.withOpacity(0.6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            // icon: _isLoading
                            //     ? const SizedBox.shrink()
                            //     : const Icon(Icons.login),
                            label: _isLoading
                                ? SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: colorScheme.onPrimary,
                                    ),
                                  )
                                : const Text('Login'),
                          ),
                          const SizedBox(height: 20),

                          // Divider with OR text
                          Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: colorScheme.outlineVariant,
                                  thickness: 1,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  'OR',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: colorScheme.onSurfaceVariant,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  color: colorScheme.outlineVariant,
                                  thickness: 1,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),

                          const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "*Recommended",
                              style: TextStyle(
                                  fontSize: 12, color: Colors.blueGrey),
                            ),
                          ),

                          // Google Sign in button
                          OutlinedButton.icon(
                            onPressed:
                                _isGoogleLoading ? null : _handleGoogleLogin,
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
                                : Image.asset('assets/images/google_logo.png',
                                    height: 20),
                            label: const Text('Sign in with Google'),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Sign Up Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, AuthRoutes.signup);
                        },
                        child: const Text('Sign Up'),
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
}
