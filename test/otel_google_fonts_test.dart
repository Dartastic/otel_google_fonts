// Licensed under the Apache License, Version 2.0
// Copyright 2025, Mindful Software LLC, All rights reserved.

import 'package:otel_google_fonts/otel_google_fonts.dart';
import 'package:test/test.dart';

void main() {
  group('otel_google_fonts', () {
    test('suppression toggles in zone', () async {
      expect(googleFontsInstrumentationSuppressed(), isFalse);
      await runWithoutGoogleFontsInstrumentationAsync(() async {
        expect(googleFontsInstrumentationSuppressed(), isTrue);
      });
      expect(googleFontsInstrumentationSuppressed(), isFalse);
    });

    test('GoogleFontsResult fields default null', () {
      const r = GoogleFontsResult();
      expect(r.statusCode, isNull);
    });
  });
}
