// Licensed under the Apache License, Version 2.0
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';
import 'package:otel_google_fonts/otel_google_fonts.dart';

/// Traces Google Fonts calls with OpenTelemetry.
///
/// `otel_google_fonts` depends on the OpenTelemetry API only, so the application
/// initializes an SDK once at startup. Wrap each Google Fonts call in
/// [tracedGoogleFonts]; the `invoke` callback makes the real call and reports what
/// came back, which is recorded on the span.
Future<void> main() async {
  await OTel.initialize(serviceName: 'google-fonts-example');

  // Traces a Google Fonts call.
  final googleFontsId = await tracedGoogleFonts<String>(
    operation: 'create',
    invoke: () async {
      // Make the Google Fonts call here, then report what it returned.
      const id = 'google_fonts_8f3a2c';
      return const GoogleFontsCallResult(
          value: id,
          result: GoogleFontsResult(
              familyName: 'example',
              variants: 'example',
              subsets: 'example',
              display: 'example',
              fontFormat: 'example',
              sizeBytes: 512,
              statusCode: 201,
              errorCode: 'example',
              errorMessage: 'example'));
    },
  );
  OTelLog.info('tracedGoogleFonts create returned $googleFontsId');

  // Calls that should not be traced, such as health checks, run inside
  // runWithoutGoogleFontsInstrumentationAsync.
  await runWithoutGoogleFontsInstrumentationAsync(
    () => tracedGoogleFonts<String>(
      operation: 'create',
      invoke: () async {
        const id = 'google_fonts_8f3a2c';
        return const GoogleFontsCallResult(
            value: id,
            result: GoogleFontsResult(
                familyName: 'example',
                variants: 'example',
                subsets: 'example',
                display: 'example',
                fontFormat: 'example',
                sizeBytes: 512,
                statusCode: 201,
                errorCode: 'example',
                errorMessage: 'example'));
      },
    ),
  );

  await OTel.shutdown();
}
