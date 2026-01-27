import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// 自动生成的 Firebase 配置文件（手动转换版）
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    // 既然你是部署在 GitHub Pages，直接返回 web 配置即可
    return web;
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDv2--vVIRqzGMbGDALU_9zkEyaEgSIjIk',
    authDomain: 'wifi-menu-da081.firebaseapp.com',
    projectId: 'wifi-menu-da081',
    storageBucket: 'wifi-menu-da081.firebasestorage.app',
    messagingSenderId: '905851958577',
    appId: '1:905851958577:web:efed2be7186f02cd452c10',
    measurementId: 'G-MMFZ1S1Y3E',
  );
}