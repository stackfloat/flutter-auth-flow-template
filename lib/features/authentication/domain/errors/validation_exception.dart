abstract class ValidationException implements Exception {
  const ValidationException();
}

/* ───────────── NAME ───────────── */

class InvalidNameException extends ValidationException {
  const InvalidNameException();
}

/* ───────────── EMAIL ───────────── */

class InvalidEmailException extends ValidationException {
  const InvalidEmailException();
}

/* ───────────── PASSWORD ───────────── */

class WeakPasswordException extends ValidationException {
  const WeakPasswordException();
}

class PasswordMismatchException extends ValidationException {
  const PasswordMismatchException();
}
