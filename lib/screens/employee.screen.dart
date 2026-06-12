import 'dart:convert';
import 'package:corporate_filter/core/constants/api.constants.dart';
import 'package:corporate_filter/core/theme/app.theme.dart';
import 'package:corporate_filter/core/theme/theme.cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:corporate_filter/core/logger.dart';

class EmployeeScreen extends StatefulWidget {
  const EmployeeScreen({Key? key}) : super(key: key);

  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  final TextEditingController _inputController = TextEditingController();
  String? _professionalText;
  bool _isLoading = false;
  bool _hasCopied = false;

  static final String _apiUrl = ApiConstants.rewriteUrl;

  @override
  void initState() {
    super.initState();
    logger.i('Employee Screen mounted', tag: 'SCREEN-E');
  }

  @override
  void dispose() {
    _inputController.dispose();
    logger.i('Employee Screen disposed', tag: 'SCREEN-E');
    super.dispose();
  }

  Future<void> _handleProfessionalize() async {
    final rawText = _inputController.text.trim();

    if (rawText.isEmpty) {
      logger.w(
        "User tapped Professionalize with empty input",
        tag: 'Invalid Input',
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Please enter some text."),
          backgroundColor: Colors.amber,
        ),
      );
      return;
    }

    logger.i("User intitated rewrite request", tag: "Request Initiated");
    logger.d('Request body -> raw_text : "$rawText"', tag: 'API-REQUEST');

    setState(() {
      _isLoading = true;
      _professionalText = null;
      _hasCopied = false;
    });

    final stopwatch = Stopwatch()..start();
    final minDelayFuture = Future.delayed(const Duration(seconds: 4));

    try {
      final Map<String, dynamic> requestBody = ApiConstants.useLocalApi
          ? {
              "model": "corporate-filter",
              "messages": [
                {"role": "system", "content": "You are a professional communication assistant. Rewrite the user's message into polished, professional corporate language. Return only the rewritten text."},
                {"role": "user", "content": rawText},
              ],
              "temperature": 0.3,
              "max_tokens": 256,
            }
          : {"raw_text": rawText};

      final response = await http
          .post(
            Uri.parse(_apiUrl),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(requestBody),
          )
          .timeout(const Duration(seconds: 1000));

      stopwatch.stop();
      logger.i(
        'Response received - status : ${response.statusCode} | elapsed : ${stopwatch.elapsedMilliseconds}ms',
        tag: "API-RESPONSE",
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String professional = '';

        if (ApiConstants.useLocalApi) {
          if (data['choices'] != null && data['choices'].isNotEmpty) {
            professional = data['choices'][0]['message']['content']
                .toString()
                .trim();
          }
        } else {
          professional = data['professional_text']?.toString().trim() ?? '';
        }

        logger.i(
          'Rewrite successful. Output length : ${professional.length} chars',
          tag: 'API-RESPONSE-LEN',
        );

        await minDelayFuture;

        setState(() {
          _professionalText = professional;
        });
      } else {
        logger.e(
          'API returned non-200 : ${response.statusCode} -> ${response.body}',
          tag: 'API-ERROR',
        );
        _showError('Error : (${response.statusCode}). Try again');
      }
    } catch (e) {
      if (stopwatch.isRunning) stopwatch.stop();
      logger.e('Network/HTTP error: $e', tag: 'API-ERROR');
      _showError(
        'Could not process your reqeust right now. Please try again later',
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
    );
  }

  void _copyToClipboard() {
    if (_professionalText == null) return;
    Clipboard.setData(ClipboardData(text: _professionalText!));
    logger.i('User copied professional text to clipboard', tag: 'SCREEN-E');
    setState(() => _hasCopied = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _hasCopied = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    logger.v('ScreenC build()', tag: 'SCREEN-E');

    // Theme references extracting the 4 design palette colors cleanly
    final currentTheme = Theme.of(context);
final primaryColor = currentTheme.primaryColorRef;
final backgroundColor = currentTheme.backgroundColorRef;
final textColor = currentTheme.textColorRef;
final dimColor = currentTheme.dimColorRef;
final mutedTextColor = currentTheme.mutedTextColorRef; // <-- Add this line

    return Scaffold(
      backgroundColor: backgroundColor, // Dynamically driven background
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: textColor.withOpacity(0.7)),
          onPressed: () {
            logger.i('User navigated back from ScreenC', tag: 'SCREEN-E');
            Navigator.pop(context);
          },
        ),
        actions: [
          // Theme switch list-style button implemented dynamically into AppBar action deck
          BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, state) {
              IconData icon;
              String label;

              switch (state.themeMode) {
                case AppThemeMode.light:
                  icon = Icons.wb_sunny_outlined;
                  label = 'Light mode';
                  break;
                case AppThemeMode.dark:
                  icon = Icons.dark_mode_outlined;
                  label = 'Dark mode';
                  break;
                case AppThemeMode.original:
                  icon = Icons.auto_awesome_outlined;
                  label = 'Corporate';
                  break;
              }

              return Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: TextButton.icon(
                  onPressed: () => context.read<ThemeCubit>().toggleTheme(),
                  icon: Icon(icon, color: textColor.withOpacity(0.8), size: 20),
                  label: Text(
                    label,
                    style: TextStyle(
                      color: textColor.withOpacity(0.8),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 48,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 4),
                      Container(
                        decoration: BoxDecoration(
                          color: dimColor, // Uses context "dim" surface layer
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: primaryColor.withOpacity(0.5), width: 1),
                        ),
                        child: TextField(
                          controller: _inputController,
                          minLines: 3,
                          maxLines: 5,
                          style: TextStyle(
                            color: textColor,
                            fontSize: 15,
                          ),
                          cursorColor: primaryColor,
                          decoration: InputDecoration(
                            hintText: 'Enter your raw text here...',
                            hintStyle: TextStyle(
                              color: textColor.withOpacity(0.4),
                              fontSize: 14,
                            ),
                            contentPadding: const EdgeInsets.all(16),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: _isLoading ? null : _handleProfessionalize,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              color: _isLoading
                                  ? primaryColor.withOpacity(0.5)
                                  : primaryColor,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              _isLoading ? 'Processing...' : 'Professionalize',
                              style: TextStyle(
                                color: currentTheme.brightness == Brightness.light ? Colors.white : Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Gap(6),
                      Container(
                        height: 45,
                        alignment: Alignment.center,
                        child: Text(
                          "This assistant is powered by the Microsoft Phi-3.5-mini (3.8B) model and has been fine-tuned on a custom dataset of approximately 7,500 training samples.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: mutedTextColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            height: 1.4,
                          ),
                        ),
                      ),
                      const SizedBox(height: 36),
                      if (_isLoading) ...[
                        Text(
                          'Generating Rewrite...',
                          style: TextStyle(
                            color: textColor.withOpacity(0.7),
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: SizedBox(
                            height: 180,
                            child: Lottie.asset('assets/lottie/sparkle_loading.json'),
                          ),
                        ),
                      ]
                      else if (_professionalText != null) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Professional Rewrite',
                              style: TextStyle(
                                color: textColor.withOpacity(0.7),
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                                letterSpacing: 1.0,
                              ),
                            ),
                            GestureDetector(
                              onTap: _copyToClipboard,
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 250),
                                child: _hasCopied
                                    ? const Row(
                                        key: ValueKey('copied'),
                                        children: [
                                          Icon(Icons.check, color: Colors.greenAccent, size: 16),
                                          SizedBox(width: 4),
                                          Text('Copied!', style: TextStyle(color: Colors.greenAccent, fontSize: 13)),
                                        ],
                                      )
                                    : Row(
                                        key: const ValueKey('copy'),
                                        children: [
                                          Icon(Icons.copy, color: primaryColor, size: 16),
                                          const SizedBox(width: 4),
                                          Text('Copy', style: TextStyle(color: primaryColor, fontSize: 13)),
                                        ],
                                      ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: dimColor,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: primaryColor.withOpacity(0.5), width: 1),
                          ),
                          child: SelectableText(
                            _professionalText!,
                            style: TextStyle(
                              color: textColor,
                              fontSize: 15,
                              height: 1.6,
                            ),
                          ),
                        ),
                      ],
                      const Expanded(child: SizedBox(height: 24)),
                      Center(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width > 900
                                ? 850
                                : double.infinity,
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: MediaQuery.of(context).size.width > 900 ? 24 : 0,
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: dimColor.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: primaryColor.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    color: primaryColor,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      'Disclaimer: This tool provides AI-generated content. Please review critical text outputs for accuracy before formal communication.\n\nPerformance Notice: As this live demo utilizes shared cloud infrastructure, processing times depend heavily on server load and can take anywhere from 1-12 minutes.',
                                      style: TextStyle(
                                        color: textColor.withOpacity(0.6),
                                        fontSize: 12,
                                        height: 1.4,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}