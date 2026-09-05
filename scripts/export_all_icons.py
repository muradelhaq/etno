from PIL import Image
import os

master = Image.open("assets/images/app_icon.png")

# Android mipmaps
android_sizes = {
    "android/app/src/main/res/mipmap-mdpi/ic_launcher.png": (48, 48),
    "android/app/src/main/res/mipmap-hdpi/ic_launcher.png": (72, 72),
    "android/app/src/main/res/mipmap-xhdpi/ic_launcher.png": (96, 96),
    "android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png": (144, 144),
    "android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png": (192, 192),
}

for path, size in android_sizes.items():
    os.makedirs(os.path.dirname(path), exist_ok=True)
    resized = master.resize(size, Image.Resampling.LANCZOS)
    resized.save(path, "PNG")
    print(f"Saved {path} ({size})")

# iOS AppIcon.appiconset
ios_sizes = {
    "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@1x.png": (20, 20),
    "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@2x.png": (40, 40),
    "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@3x.png": (60, 60),
    "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@1x.png": (29, 29),
    "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@2x.png": (58, 58),
    "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@3x.png": (87, 87),
    "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@1x.png": (40, 40),
    "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@2x.png": (80, 80),
    "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@3x.png": (120, 120),
    "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-60x60@2x.png": (120, 120),
    "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-60x60@3x.png": (180, 180),
    "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-76x76@1x.png": (76, 76),
    "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-76x76@2x.png": (152, 152),
    "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-83.5x83.5@2x.png": (167, 167),
    "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-1024x1024@1x.png": (1024, 1024),
}

for path, size in ios_sizes.items():
    if os.path.exists(os.path.dirname(path)):
        # iOS AppStore icons must not have alpha channel
        rgb_img = Image.new("RGB", master.size, (15, 46, 34))
        rgb_img.paste(master, mask=master.split()[3])
        resized = rgb_img.resize(size, Image.Resampling.LANCZOS)
        resized.save(path, "PNG")
        print(f"Saved {path} ({size})")

# Web icons
web_sizes = {
    "web/favicon.png": (48, 48),
    "web/icons/Icon-192.png": (192, 192),
    "web/icons/Icon-512.png": (512, 512),
    "web/icons/Icon-maskable-192.png": (192, 192),
    "web/icons/Icon-maskable-512.png": (512, 512),
}

for path, size in web_sizes.items():
    if os.path.exists(os.path.dirname(path)):
        resized = master.resize(size, Image.Resampling.LANCZOS)
        resized.save(path, "PNG")
        print(f"Saved {path} ({size})")

# macOS icons
macos_sizes = {
    "macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_16.png": (16, 16),
    "macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_32.png": (32, 32),
    "macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_64.png": (64, 64),
    "macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_128.png": (128, 128),
    "macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_256.png": (256, 256),
    "macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_512.png": (512, 512),
    "macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_1024.png": (1024, 1024),
}

for path, size in macos_sizes.items():
    if os.path.exists(os.path.dirname(path)):
        resized = master.resize(size, Image.Resampling.LANCZOS)
        resized.save(path, "PNG")
        print(f"Saved {path} ({size})")

# Windows icon (.ico)
win_ico = "windows/runner/resources/app_icon.ico"
if os.path.exists(os.path.dirname(win_ico)):
    master.save(win_ico, format="ICO", sizes=[(16, 16), (32, 32), (48, 48), (64, 64), (128, 128), (256, 256)])
    print(f"Saved {win_ico}")

print("All app icons updated successfully!")
