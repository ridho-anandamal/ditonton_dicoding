import 'dart:io';

import 'package:flutter/services.dart';

Future<SecurityContext> get globalContext async {
  final sslCertificate = await rootBundle.load('certificates/certificate.pem');
  SecurityContext securityContext = SecurityContext(withTrustedRoots: false);
  securityContext
      .setTrustedCertificatesBytes(sslCertificate.buffer.asInt8List());
  return securityContext;
}
