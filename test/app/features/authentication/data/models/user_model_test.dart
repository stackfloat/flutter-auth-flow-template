import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:furniture_ecommerce_app/features/authentication/data/models/user_model.dart';
import 'package:furniture_ecommerce_app/features/authentication/domain/entities/user.dart';

void main() {
  final tUserModel = UserModel(
    id: 1,
    name: 'John Doe',
    email: 'john.doe@example.com',
    token: 'token',
  );

  group('UserModel', () {
    test('should be a subclass of [User] entity', () {
      expect(tUserModel, isA<User>());
    });

    test('should have correct props for equality comparison', () {
      final userModel1 = UserModel(
        id: 1,
        name: 'John Doe',
        email: 'john.doe@example.com',
        token: 'token',
      );

      final userModel2 = UserModel(
        id: 1,
        name: 'John Doe',
        email: 'john.doe@example.com',
        token: 'token',
      );

      expect(userModel1, equals(userModel2));
    });
  });

  group('fromLocalJson', () {
    test('should return a [UserModel] when local JSON is valid with token', () {
      final json = {
        'id': 1,
        'name': 'John Doe',
        'email': 'john.doe@example.com',
        'token': 'token',
      };

      final result = UserModel.fromLocalJson(json);

      expect(result, tUserModel);
    });

    test('should return [UserModel] with empty token when token is missing', () {
      final json = {
        'id': 1,
        'name': 'John Doe',
        'email': 'john.doe@example.com',
      };

      final result = UserModel.fromLocalJson(json);

      expect(result.id, 1);
      expect(result.name, 'John Doe');
      expect(result.email, 'john.doe@example.com');
      expect(result.token, '');
    });

    test('should throw [FormatException] when id is missing', () {
      final json = {
        'name': 'John Doe',
        'email': 'john.doe@example.com',
      };

      expect(
        () => UserModel.fromLocalJson(json),
        throwsA(isA<FormatException>()),
      );
    });

    test('should throw [FormatException] when name is missing', () {
      final json = {
        'id': 1,
        'email': 'john.doe@example.com',
      };

      expect(
        () => UserModel.fromLocalJson(json),
        throwsA(isA<FormatException>()),
      );
    });

    test('should throw [FormatException] when email is missing', () {
      final json = {
        'id': 1,
        'name': 'John Doe',
      };

      expect(
        () => UserModel.fromLocalJson(json),
        throwsA(isA<FormatException>()),
      );
    });
  });

  group('fromApiJson', () {
    test('should return valid [UserModel] from API json', () async {
      final file = File('test/fixtures/user.json');
      final json = jsonDecode(await file.readAsString());
      final result = UserModel.fromApiJson(json);

      expect(result, isA<UserModel>());
      expect(result.id, 8);
      expect(result.name, 'John Doe');
      expect(result.email, 'john@test.com');
      expect(result.token, '162|awFlhrYwbuU1cXhm7q1tqo2VrWsWPCGagBry2Chr7fd08773');
    });

    test('should throw [FormatException] when data field is missing', () {
      final json = {
        'status': true,
        'message': 'Login successful.',
      };

      expect(
        () => UserModel.fromApiJson(json),
        throwsA(isA<FormatException>()),
      );
    });

    test('should throw [FormatException] when user field is missing', () {
      final json = {
        'status': true,
        'message': 'Login successful.',
        'data': {
          'token': 'test-token',
        },
      };

      expect(
        () => UserModel.fromApiJson(json),
        throwsA(isA<FormatException>()),
      );
    });

    test('should throw [FormatException] when token field is missing', () {
      final json = {
        'status': true,
        'message': 'Login successful.',
        'data': {
          'user': {
            'id': 1,
            'name': 'John Doe',
            'email': 'john@test.com',
          },
        },
      };

      expect(
        () => UserModel.fromApiJson(json),
        throwsA(isA<FormatException>()),
      );
    });

    test('should throw [FormatException] when user id is missing', () {
      final json = {
        'status': true,
        'message': 'Login successful.',
        'data': {
          'user': {
            'name': 'John Doe',
            'email': 'john@test.com',
          },
          'token': 'test-token',
        },
      };

      expect(
        () => UserModel.fromApiJson(json),
        throwsA(isA<FormatException>()),
      );
    });

    test('should throw [FormatException] when user name is missing', () {
      final json = {
        'status': true,
        'message': 'Login successful.',
        'data': {
          'user': {
            'id': 1,
            'email': 'john@test.com',
          },
          'token': 'test-token',
        },
      };

      expect(
        () => UserModel.fromApiJson(json),
        throwsA(isA<FormatException>()),
      );
    });

    test('should throw [FormatException] when user email is missing', () {
      final json = {
        'status': true,
        'message': 'Login successful.',
        'data': {
          'user': {
            'id': 1,
            'name': 'John Doe',
          },
          'token': 'test-token',
        },
      };

      expect(
        () => UserModel.fromApiJson(json),
        throwsA(isA<FormatException>()),
      );
    });
  });

  group('toLocalJson', () {
    test('should return a valid JSON map without token', () {
      final result = tUserModel.toLocalJson();

      expect(result, {
        'id': 1,
        'name': 'John Doe',
        'email': 'john.doe@example.com',
      });
      expect(result.containsKey('token'), false);
    });
  });

  group('toEntity', () {
    test('should return a valid [User] entity', () {
      final result = tUserModel.toEntity();

      expect(result, isA<User>());
      expect(result.id, tUserModel.id);
      expect(result.name, tUserModel.name);
      expect(result.email, tUserModel.email);
    });
  });
}
