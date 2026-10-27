# Hotspot

## Requirements

- Start the PC's hotspot automatically at boot, independently of desktop login or manual scripts.
- Use `nixos` for the Wi-Fi network name and hotspot interface name, with password `nixos123`.
- Use modern hotspot security compatible with macOS without weak-security warnings.
- Preserve the PC's normal Wi-Fi connection and share its internet connection with hotspot clients.

## Security and radio constraints

The hotspot uses WPA3-Personal with SAE authentication, RSN, AES-CCMP encryption,
and required protected management frames. It does not enable legacy WPA or TKIP.

Use at least eight password characters for compatibility with the tested Mac.
Joining failed with `nixos` and succeeded with `nixos123`.

The virtual `nixos` interface shares the Wi-Fi card with the normal client interface.
The card supports only one channel when both interfaces are active. The hotspot uses
5 GHz channel 36 to match the existing uplink. If the uplink changes channels, the
hotspot channel must be updated to match. The configured regulatory domain is CZ.

NetworkManager provides address assignment and internet sharing. The hotspot
retries automatic connection indefinitely after failures. Startup explicitly
activates the declared profile so an older saved hotspot profile cannot take its place.
Startup also retries activation failures if the Wi-Fi service is not ready yet.

## Validation

Check Nix formatting and build the system before applying changes:

```sh
nixfmt --check /etc/nixos/configuration.nix
nix build /etc/nixos#nixosConfigurations.nixos.config.system.build.toplevel --no-link
```

After applying, confirm that the hotspot is active on interface `nixos` and that
the normal Wi-Fi uplink is still connected:

```sh
nmcli -f NAME,TYPE,DEVICE connection show --active
nmcli device show nixos
```

Verify startup with a cold boot and confirm that a Mac can join without a weak-security warning.
A successful build and local hotspot activation do not establish those results.
