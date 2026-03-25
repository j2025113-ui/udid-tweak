THEOS_DEVICE_IP = localhost
ARCHS = arm64
TARGET = iphone:clang:latest:14.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = UDIDAuth
UDIDAuth_FILES = Tweak.xm
UDIDAuth_FRAMEWORKS = UIKit Foundation

include $(THEOS_MAKE_PATH)/tweak.mk
```

---

### ファイル③ `control`
```
Package: com.yourname.udidauth
Name: UDIDAuth
Depends: mobilesubstrate
Version: 1.0
Architecture: iphoneos-arm64
Description: UDID Auth Tweak
Maintainer: YourName
Author: YourName
Section: Tweaks
