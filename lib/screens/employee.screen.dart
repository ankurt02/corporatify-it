import 'dart:convert';
import 'package:corporate_filter/core/constants/api.constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
import 'package:corporate_filter/core/logger.dart';

class ScreenC extends StatefulWidget {
  const ScreenC({Key? key}) : super(key: key);

  @override
  State<ScreenC> createState() => _ScreenCState();
}

class _ScreenCState extends State<ScreenC> {
  final TextEditingController _inputController = TextEditingController();
  String? _professionalText;
  bool _isLoading = false;
  bool _hasCopied = false;

  // Ensure ApiConstants.rewriteUrl now points to LM Studio's /v1/chat/completions
  static final String _apiUrl = ApiConstants.rewriteUrl;

  @override
  void initState() {
    super.initState();
    logger.i('ScreenC (Employee Screen) mounted', tag: 'SCREEN-E');
  }

  @override
  void dispose() {
    _inputController.dispose();
    logger.i('ScreenC (Employee Screen) disposed', tag: 'SCREEN-E');
    super.dispose();
  }

  Future<void> _handleProfessionalize() async {
    final rawText = _inputController.text.trim();

    if (rawText.isEmpty) {
      logger.w('User tapped Professionalize with empty input', tag: 'SCREEN-E');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter some text first.'),
          backgroundColor: Colors.amber,
        ),
      );
      return;
    }

    logger.i('User initiated rewrite request', tag: 'SCREEN-E');
    logger.d('Request body → raw_text: "$rawText"', tag: 'API-REQUEST');

    setState(() {
      _isLoading = true;
      _professionalText = null;
      _hasCopied = false;
    });

    final stopwatch = Stopwatch()..start();

    try {
      // DYNAMIC PAYLOAD: Switch shape based on environment
      final Map<String, dynamic> requestBody = ApiConstants.useLocalApi
          ? {
              // Local LM Studio Format
              "model": "corporate-filter",
              "messages": [
                {
                  "role": "system",
                  "content":
                      "You are a professional communication assistant. Rewrite the user's message into polished, professional corporate language. Return only the rewritten text.",
                },
                {"role": "user", "content": rawText},
              ],
              "temperature": 0.3,
              "max_tokens": 256,
            }
          : {
              // Production Hugging Face Format
              "raw_text": rawText,
            };

      // SEND THE REQUEST
      final response = await http
          .post(
            Uri.parse(_apiUrl),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(requestBody), // Use the dynamic body here!
          )
          .timeout(const Duration(seconds: 1000));

      stopwatch.stop();
      logger.i(
        'Response received — status: ${response.statusCode} | elapsed: ${stopwatch.elapsedMilliseconds}ms',
        tag: 'API-RESPONSE',
      );
      logger.d('Response body: ${response.body}', tag: 'API-RESPONSE');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String professional = '';

        // DYNAMIC PARSER: Extract text based on environment
        if (ApiConstants.useLocalApi) {
          // Parse LM Studio format
          if (data['choices'] != null && data['choices'].isNotEmpty) {
            professional = data['choices'][0]['message']['content']
                .toString()
                .trim();
          }
        } else {
          // Parse Hugging Face format
          professional = data['professional_text']?.toString().trim() ?? '';
        }

        logger.i(
          'Rewrite successful. Output length: ${professional.length} chars',
          tag: 'API-RESPONSE',
        );

        setState(() {
          _professionalText = professional;
        });
      } else {
        logger.e(
          'API returned non-200: ${response.statusCode} → ${response.body}',
          tag: 'API-ERROR',
        );
        _showError('Server error (${response.statusCode}). Try again.');
      }
    } catch (e, stackTrace) {
      stopwatch.stop();
      logger.e(
        'Network/HTTP error after ${stopwatch.elapsedMilliseconds}ms: $e',
        tag: 'API-ERROR',
      );
      logger.v('Stack trace: $stackTrace', tag: 'API-ERROR');
      _showError('Could not process your request right now. Please try again.');
    } finally {
      setState(() => _isLoading = false);
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

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.amber),
          onPressed: () {
            logger.i('User navigated back from ScreenC', tag: 'SCREEN-E');
            Navigator.pop(context);
          },
        ),
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
                      // const Text(
                      //   'Raw Text',
                      //   style: TextStyle(
                      //     color: Colors.amber,
                      //     fontWeight: FontWeight.w600,
                      //     fontSize: 13,
                      //     letterSpacing: 1.0,
                      //   ),
                      // ),
                      const SizedBox(height: 4),
                      Container(
                        // margin: EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF111111),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.grey, width: 1),
                        ),
                        child: TextField(
                          controller: _inputController,
                          minLines: 5,
                          maxLines: 10,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                          cursorColor: Colors.amber,
                          decoration: const InputDecoration(
                            hintText: 'Enter your raw text here...',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                            contentPadding: EdgeInsets.all(16),
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
                                  ? Colors.amber.withOpacity(0.5)
                                  : Colors.amber,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              _isLoading ? 'Processing...' : 'Professionalize',
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Gap(6),
                      Container(
                        height: 36,
                        // decoration: BoxDecoration(
                        //   border: Border.all(color: Colors.pink, width: 2),
                        // ),
                        alignment: Alignment.center,
                        child: Text(
                          "This assistant is powered by the Microsoft Phi-3.5-mini (3.8B) model and has been fine-tuned on a custom dataset of approximately 7,500 training samples.",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            height: 1.4,
                          ),
                        ),
                      ),
                      const SizedBox(height: 36),
                      if (_isLoading) ...[
                        const Text(
                          'Professional Rewrite',
                          style: TextStyle(
                            color: Colors.amber,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const _ShimmerBox(),
                      ] else if (_professionalText != null) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Professional Rewrite',
                              style: TextStyle(
                                color: Colors.amber,
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
                                          Icon(
                                            Icons.check,
                                            color: Colors.greenAccent,
                                            size: 16,
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            'Copied!',
                                            style: TextStyle(
                                              color: Colors.greenAccent,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      )
                                    : const Row(
                                        key: ValueKey('copy'),
                                        children: [
                                          Icon(
                                            Icons.copy,
                                            color: Colors.amber,
                                            size: 16,
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            'Copy',
                                            style: TextStyle(
                                              color: Colors.amber,
                                              fontSize: 13,
                                            ),
                                          ),
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
                            color: const Color(0xFF111111),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.grey, width: 1),
                          ),
                          child: SelectableText(
                            _professionalText!,
                            style: const TextStyle(
                              color: Colors.white,
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
                              horizontal:
                                  MediaQuery.of(context).size.width > 900
                                  ? 24
                                  : 0,
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFF161616),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.amber.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: const Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    color: Colors.amber,
                                    size: 20,
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      'Disclaimer: This tool provides AI-generated content. Please review critical text outputs for accuracy before formal communication.\n\nPerformance Notice: As this live demo utilizes shared cloud infrastructure, processing times depend heavily on server load and can take anywhere from 1-12 minutes.',
                                      style: TextStyle(
                                        color: Colors.grey,
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

class _ShimmerBox extends StatelessWidget {
  const _ShimmerBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF1E1E1E),
      highlightColor: const Color(0xFF2C2C2C),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _shimmerLine(double.infinity, 14),
          const SizedBox(height: 10),
          _shimmerLine(double.infinity, 14),
          const SizedBox(height: 10),
          _shimmerLine(double.infinity, 14),
          const SizedBox(height: 10),
          _shimmerLine(200, 14),
        ],
      ),
    );
  }

  Widget _shimmerLine(double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}
