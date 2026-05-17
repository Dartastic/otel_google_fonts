// Licensed under the Apache License, Version 2.0
// Copyright 2025, Mindful Software LLC, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';
import 'package:dartastic_opentelemetry_api/dartastic_opentelemetry_api.dart';

import 'otel_google_fonts_suppression.dart';

class GoogleFontsResult {
  const GoogleFontsResult({
    this.familyName,
    this.variants,
    this.subsets,
    this.display,
    this.fontFormat,
    this.sizeBytes,
    this.statusCode,
    this.errorCode,
    this.errorMessage,
  });

  final String? familyName;
  final String? variants;
  final String? subsets;
  final String? display;
  final String? fontFormat;
  final int? sizeBytes;
  final int? statusCode;
  final String? errorCode;
  final String? errorMessage;
}

class GoogleFontsCallResult<T> {
  const GoogleFontsCallResult({required this.value, this.result});
  final T value;
  final GoogleFontsResult? result;
}

Future<T> tracedGoogleFonts<T>({
  required String operation,
  required Future<GoogleFontsCallResult<T>> Function() invoke,
  Tracer? tracer,
}) async {
  if (googleFontsInstrumentationSuppressed()) {
    final r = await invoke();
    return r.value;
  }
  final t = tracer ?? OTel.tracerProvider().getTracer('otel_google_fonts');
  final span = t.startSpan('gfonts $operation', kind: SpanKind.client);
  try {
    span.setStringAttribute('rpc.system', 'google_fonts');
    final r = await invoke();
    final res = r.result;
    if (res != null) {
      if (res.familyName != null) {
        span.setStringAttribute('gfonts.family', res.familyName!);
      }
      if (res.variants != null) {
        span.setStringAttribute('gfonts.variants', res.variants!);
      }
      if (res.subsets != null) {
        span.setStringAttribute('gfonts.subsets', res.subsets!);
      }
      if (res.display != null) {
        span.setStringAttribute('gfonts.display', res.display!);
      }
      if (res.fontFormat != null) {
        span.setStringAttribute('gfonts.format', res.fontFormat!);
      }
      if (res.sizeBytes != null) {
        span.setIntAttribute('http.response.body.size', res.sizeBytes!);
      }
      if (res.statusCode != null) {
        span.setIntAttribute('http.response.status_code', res.statusCode!);
      }
      if (res.errorCode != null) {
        span.setStringAttribute('gfonts.error.code', res.errorCode!);
      }
      final fail =
          res.errorCode != null ||
          (res.statusCode != null && res.statusCode! >= 400);
      if (fail) {
        span.setStringAttribute(
          ErrorResource.errorType.key,
          res.errorCode ?? 'gfonts.error',
        );
        span.setStatus(SpanStatusCode.Error, res.errorMessage);
      }
    }
    return r.value;
  } catch (e, st) {
    span.recordException(e, stackTrace: st);
    span.setStatus(SpanStatusCode.Error, e.toString());
    rethrow;
  } finally {
    span.end();
  }
}
