# Releases (.apk and .ipa)

`.github/workflows/release.yml` builds the mobile app and publishes it.

| Trigger | Result |
|---|---|
| Push a tag `vX.Y.Z` (e.g. `git tag v0.1.0 && git push origin v0.1.0`) | GitHub Release with the APK, the IPA and `SHA256SUMS.txt` |
| Tag with a suffix (`v0.2.0-beta.1`) | Same, marked as a pre-release (store version `0.2.0`) |
| Actions → release → Run workflow | Builds only; files are downloadable as run artifacts |

The version name comes from the tag; the build number is the workflow run number, so it always
increases.

## Signing

The workflow works **without any secrets**, but then:

- the APK is **debug-signed** (`izmir-go-X.Y.Z-debugsigned.apk`): installable for testing, not for Google Play;
- the IPA is **unsigned** (`izmir-go-X.Y.Z-unsigned.ipa`): it must be re-signed before an iPhone will install it.

Add these repository secrets (Settings → Secrets and variables → Actions) for real signing:

### Android

| Secret | Value |
|---|---|
| `ANDROID_KEYSTORE_BASE64` | `base64 -w0 upload-keystore.jks` |
| `ANDROID_KEYSTORE_PASSWORD` | keystore password |
| `ANDROID_KEY_ALIAS` | key alias |
| `ANDROID_KEY_PASSWORD` | key password |

Create a keystore once and keep a backup outside the repository:

```bash
keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

With a key configured, the release also includes an `.aab` for Google Play.

### iOS

You need an Apple Developer Program membership.

| Secret | Value |
|---|---|
| `IOS_CERTIFICATE_P12_BASE64` | `base64 -i distribution.p12` (an *Apple Distribution* certificate with its private key) |
| `IOS_CERTIFICATE_PASSWORD` | password of the .p12 |
| `IOS_PROVISIONING_PROFILE_BASE64` | `base64 -i profile.mobileprovision` |

The bundle id and team come from the provisioning profile. CI switches the Runner target to manual
signing using `apps/mobile/tool/ios_manual_signing.py`; the committed project is unchanged.
An **ad-hoc** profile (device UDIDs registered) gives an IPA you can install directly; an **App
Store** profile gives an IPA for TestFlight/App Store Connect. Set the repository variable
`IOS_EXPORT_METHOD` to `app-store-connect` in that case.

## Repository variables (optional)

| Variable | Purpose |
|---|---|
| `API_BASE_URL` | API the release app uses (default `config/prod.json`, currently a placeholder) |
| `ANDROID_APPLICATION_ID` | Replaces the `com.example.izmir_go` placeholder |
| `IOS_EXPORT_METHOD` | `release-testing` (ad-hoc, default), `app-store-connect` or `enterprise` |

> Until `API_BASE_URL` points to a deployed backend, release builds open but cannot load data.
