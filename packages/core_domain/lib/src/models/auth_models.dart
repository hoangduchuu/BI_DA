import 'package:json_annotation/json_annotation.dart';

part 'auth_models.g.dart';

@JsonSerializable()
class LoginRequest {
  final String username;
  final String password;

  const LoginRequest({
    required this.username,
    required this.password,
  });

  factory LoginRequest.fromJson(Map<String, dynamic> json) => _$LoginRequestFromJson(json);
  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}

@JsonSerializable()
class LoginResponse {
  final String accessToken;
  final String refreshToken;
  final String? tokenType;
  final int expiresIn;
  final String userId;
  final String username;
  final String role;
  final String companyId;
  final String? clubId;

  const LoginResponse({
    required this.accessToken,
    required this.refreshToken,
    this.tokenType,
    required this.expiresIn,
    required this.userId,
    required this.username,
    required this.role,
    required this.companyId,
    this.clubId,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    final userInfo = json['userInfo'] as Map<String, dynamic>?;
    if (userInfo == null) {
      throw FormatException('userInfo is required in LoginResponse');
    }
    
    return LoginResponse(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      tokenType: json['tokenType'] as String?,
      expiresIn: json['expiresIn'] as int,
      userId: userInfo['id'].toString(),
      username: userInfo['username'] as String,
      role: userInfo['role'] as String,
      companyId: userInfo['companyId'].toString(),
      clubId: userInfo['clubId']?.toString(),
    );
  }
  
  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}

@JsonSerializable()
class CreateUserRequest {
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String password;
  final String role;
  final String? clubId;

  const CreateUserRequest({
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.password,
    required this.role,
    this.clubId,
  });

  factory CreateUserRequest.fromJson(Map<String, dynamic> json) => _$CreateUserRequestFromJson(json);
  Map<String, dynamic> toJson() => _$CreateUserRequestToJson(this);
}
