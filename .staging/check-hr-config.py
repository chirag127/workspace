import headroom
print("HEADROOM_VERSION:", getattr(headroom, "__version__", "?"))
print("HEADROOM_FILE:", headroom.__file__)
# Check all env vars Headroom might read
import os
for k, v in sorted(os.environ.items()):
    if "HEADROOM" in k.upper() or "UPSTREAM" in k.upper():
        print(f"  {k}={v}")