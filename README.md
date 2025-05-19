# 📚 Komga Flake with Desktop Launcher

This Nix flake sets up **Komga** (a media server for comics and manga) and provides:

- A wrapper script to launch Komga in the background
- A desktop launcher (`komga.desktop`)
- A custom icon for GUI integration

---

## ⚙️ Build Instructions

Make sure you have flakes enabled, then run:

```bash
nix build
```

This will create a `result/` directory containing the launcher, `.desktop` file, and icon.

---

## 🚀 Usage

After building:

Launch **Komga** from your app menu. It will start the server and open [http://localhost:25600](http://localhost:25600) in your browser.

---

## 📦 Includes

- Komga `v1.21.3` downloaded from SourceForge
- Java 17 runtime
- Desktop launcher and custom icon

---

## 📁 Assets

Place your `komga.png` icon inside an `assets/` directory next to the flake before building.
