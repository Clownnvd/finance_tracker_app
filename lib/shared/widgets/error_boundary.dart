import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

typedef ErrorReporter = Future<void> Function(Object error, StackTrace stack, {FlutterErrorDetails? details});

class ErrorBoundary extends StatefulWidget {
  final Widget child;

  final Widget Function(BuildContext context, Object error, StackTrace stack)? fallbackBuilder;

  final ErrorReporter? reporter;

  final bool allowRetry;

  const ErrorBoundary({
    super.key,
    required this.child,
    this.fallbackBuilder,
    this.reporter,
    this.allowRetry = true,
  });

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  Object? _error;
  StackTrace? _stack;

  @override
  void initState() {
    super.initState();
    _installErrorHandlers();
  }

  void _installErrorHandlers() {
    FlutterError.onError = (FlutterErrorDetails details) async {
      FlutterError.presentError(details);

      final error = details.exception;
      final stack = details.stack ?? StackTrace.current;

      await _report(error, stack, details: details);

      if (kReleaseMode) {
        _setError(error, stack);
      }
    };

    PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
      _report(error, stack);
      if (kReleaseMode) _setError(error, stack);
      return true; 
    };
  }

  void _setError(Object error, StackTrace stack) {
    if (!mounted) return;
    setState(() {
      _error = error;
      _stack = stack;
    });
  }

  Future<void> _report(Object error, StackTrace stack, {FlutterErrorDetails? details}) async {
    try {
      if (widget.reporter != null) {
        await widget.reporter!(error, stack, details: details);
      }
    } catch (_) {
    }
  }

  void _reset() {
    if (!mounted) return;
    setState(() {
      _error = null;
      _stack = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_error == null || _stack == null) return widget.child;

    if (widget.fallbackBuilder != null) {
      return widget.fallbackBuilder!(context, _error!, _stack!);
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 64),
                  const SizedBox(height: 12),
                  Text(
                    'Something went wrong',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    kReleaseMode
                        ? 'Please restart the app or try again.'
                        : '${_error.toString()}',
                    textAlign: TextAlign.center,
                  ),
                  if (widget.allowRetry) ...[
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: _reset,
                      child: const Text('Try again'),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
