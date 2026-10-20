# Shiori catalogue

Every Shiori component, in every look the app can take: light, dark and pure
black, at phone, desktop and TV density. Each use case has knobs for its
inputs, and the text scale can go up to 200%.

It depends only on `packages/shiori`, so it runs in a browser without
building Mangayomi or its Rust core.

```sh
cd widgetbook
flutter run -d chrome
```

`flutter test` opens every use case once; CI runs it, along with a web build.
Add a use case to `catalogue` in `lib/main.dart` whenever a component is
added or gains a variant.
