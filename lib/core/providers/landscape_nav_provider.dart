import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Controls whether navigation bars (AppBar & ModuleNavBar) are visible when in landscape mode.
/// By default in landscape, it is false (hidden for immersive view), and toggles on tap.
final landscapeNavVisibleProvider = StateProvider<bool>((ref) => false);
