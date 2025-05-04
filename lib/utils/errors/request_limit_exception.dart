import 'dart:io';

class RequestLimitException extends TlsException {
  RequestLimitException(super.message);
}
