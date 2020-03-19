// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

mixin _$User {
  @optionalTypeArgs
  Result when<Result extends Object>(
    Result $default(FirebaseUser value), {
    @required Result empty(),
  });

  @optionalTypeArgs
  Result maybeWhen<Result extends Object>(
    Result $default(FirebaseUser value), {
    Result empty(),
    @required Result orElse(),
  });

  @optionalTypeArgs
  Result map<Result extends Object>(
    Result $default(_FirebaseUserUser value), {
    @required Result empty(_NoUser value),
  });

  @optionalTypeArgs
  Result maybeMap<Result extends Object>(
    Result $default(_FirebaseUserUser value), {
    Result empty(_NoUser value),
    @required Result orElse(),
  });
}

class _$UserTearOff {
  const _$UserTearOff();

  _FirebaseUserUser call(FirebaseUser value) {
    return _FirebaseUserUser(
      value,
    );
  }

  _NoUser empty() {
    return _NoUser();
  }
}

const $User = _$UserTearOff();

class _$_FirebaseUserUser
    with DiagnosticableTreeMixin
    implements _FirebaseUserUser {
  _$_FirebaseUserUser(this.value) : assert(value != null);

  @override
  final FirebaseUser value;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'User(value: $value)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'User'))
      ..add(DiagnosticsProperty('value', value));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _FirebaseUserUser &&
            (identical(other.value, value) ||
                const DeepCollectionEquality().equals(other.value, value)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(value);

  @override
  _$_FirebaseUserUser copyWith({
    Object value = freezed,
  }) {
    return _$_FirebaseUserUser(
      value == freezed ? this.value : value as FirebaseUser,
    );
  }

  @override
  @optionalTypeArgs
  Result when<Result extends Object>(
    Result $default(FirebaseUser value), {
    @required Result empty(),
  }) {
    assert($default != null);
    assert(empty != null);
    return $default(value);
  }

  @override
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>(
    Result $default(FirebaseUser value), {
    Result empty(),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if ($default != null) {
      return $default(value);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  Result map<Result extends Object>(
    Result $default(_FirebaseUserUser value), {
    @required Result empty(_NoUser value),
  }) {
    assert($default != null);
    assert(empty != null);
    return $default(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>(
    Result $default(_FirebaseUserUser value), {
    Result empty(_NoUser value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }
}

abstract class _FirebaseUserUser implements User {
  factory _FirebaseUserUser(FirebaseUser value) = _$_FirebaseUserUser;

  FirebaseUser get value;

  _FirebaseUserUser copyWith({FirebaseUser value});
}

class _$_NoUser with DiagnosticableTreeMixin implements _NoUser {
  _$_NoUser();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'User.empty()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties..add(DiagnosticsProperty('type', 'User.empty'));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is _NoUser);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  Result when<Result extends Object>(
    Result $default(FirebaseUser value), {
    @required Result empty(),
  }) {
    assert($default != null);
    assert(empty != null);
    return empty();
  }

  @override
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>(
    Result $default(FirebaseUser value), {
    Result empty(),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (empty != null) {
      return empty();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  Result map<Result extends Object>(
    Result $default(_FirebaseUserUser value), {
    @required Result empty(_NoUser value),
  }) {
    assert($default != null);
    assert(empty != null);
    return empty(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>(
    Result $default(_FirebaseUserUser value), {
    Result empty(_NoUser value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (empty != null) {
      return empty(this);
    }
    return orElse();
  }
}

abstract class _NoUser implements User {
  factory _NoUser() = _$_NoUser;
}
