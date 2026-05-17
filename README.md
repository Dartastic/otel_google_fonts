# otel_google_fonts

Dartastic OpenTelemetry bridge for Google Fonts (web font CDN).

Wraps each call in a CLIENT-kind span with vendor-specific attributes following OpenTelemetry semantic conventions where applicable.

```dart
import 'package:otel_google_fonts/otel_google_fonts.dart';

await tracedGoogleFonts<void>(
  operation: 'someOp',
  invoke: () async {
    final r = await client.someOp();
    return GoogleFontsCallResult(value: r, result: GoogleFontsResult(statusCode: 200));
  },
);
```

Suppress instrumentation within a block:

```dart
await runWithoutGoogleFontsInstrumentationAsync(() async {
  await client.someInternalSync();
});
```
