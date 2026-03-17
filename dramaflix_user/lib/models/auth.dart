class AuthStateData {
  final bool isLoading;
  final String? error;
  final String? email;
  final String? name;
  final bool? emailExists;
  final bool obscurePassword;

  AuthStateData({
    this.isLoading = false,
    this.error,
    this.email,
    this.name,
    this.emailExists,
    this.obscurePassword = true,
  });

  // Sentinel used to distinguish "caller passed null explicitly" from
  // "caller did not pass this field at all".
  static const _unset = Object();

  AuthStateData copyWith({
    bool? isLoading,
    // Use Object? + sentinel so callers can pass null to clear these fields.
    Object? error = _unset,
    String? email,
    String? name,
    Object? emailExists = _unset,
    bool? obscurePassword,
  }) {
    return AuthStateData(
      isLoading: isLoading ?? this.isLoading,
      error: error == _unset ? this.error : error as String?,
      email: email ?? this.email,
      name: name ?? this.name,
      emailExists: emailExists == _unset
          ? this.emailExists
          : emailExists as bool?,
      obscurePassword: obscurePassword ?? this.obscurePassword,
    );
  }
}
