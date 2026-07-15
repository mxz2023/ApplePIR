# Live Caller ID Lookup local test

This directory contains the local phone-number dataset for Apple's Live Caller ID Lookup example.

The test numbers are:

- `+14085551212`: identity `Johnny Appleseed`, not blocked.
- `+8613812345678`: identity `Local PIR Test Caller`, blocked.
- `+8613132133622`: identity `13132133622 Test Caller`, not blocked.

Replace the second number with the real caller number used for your test call. Keep the number in E.164 format.

## Build the databases

From this directory:

```sh
../../.build/arm64-apple-macosx/release/ConstructDatabase \
  input.txtpb block.binpb identity.binpb

../../.build/checkouts/swift-homomorphic-encryption/.build/arm64-apple-macosx/release/PIRProcessDatabase \
  block-config.json --no-parallel

../../.build/checkouts/swift-homomorphic-encryption/.build/arm64-apple-macosx/release/PIRProcessDatabase \
  identity-config.json --no-parallel
```

The service use cases are `<extension bundle id>.block` and `<extension bundle id>.identity`.

## Test on a real iPhone

1. Replace `+8613812345678` in `input.txtpb` with the real caller number, using E.164 format, and set `block: true` or `false` as needed.
2. Rebuild the two databases with the commands above, then copy the generated `block-0.*` and `identity-0.*` files into `../PIR Server/data/`.
3. Keep `PIRService` running on the Mac at `0.0.0.0:8080`. The iPhone and Mac must be on the same Wi-Fi network.
4. Open `SimpleURLFilter.xcworkspace` in Xcode, select the `SimpleURLFilter` scheme, choose the connected iPhone, and run it. Set your own Apple Development Team if Xcode reports a signing error.
5. On the iPhone, enable the installed extension under **Settings > Apps > Phone > Call Blocking & Identification** (the exact label may vary by iOS version).
6. Make a real cellular call from the matching number to the test iPhone. A blocked entry should be rejected; an identity entry should show `Local PIR Test Caller` (or the name configured in `input.txtpb`).

Watch the Mac terminal while testing. A successful Live Caller ID request produces `/config`, `/key`, and `/queries` requests. This local HTTP setup is for direct development builds; production deployment requires Apple's relay/onboarding configuration.
