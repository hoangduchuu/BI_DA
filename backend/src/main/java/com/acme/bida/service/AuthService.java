package com.acme.bida.service;

import com.acme.bida.domain.entity.User;
import com.acme.bida.dto.LoginRequest;
import com.acme.bida.dto.LoginResponse;
import com.acme.bida.repository.UserRepository;
import com.acme.bida.auth.JwtUtil;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
@RequiredArgsConstructor
@Slf4j
public class AuthService {
    
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtUtil jwtUtil;
    
    public Optional<LoginResponse> authenticate(LoginRequest request) {
        return userRepository.findByUsername(request.getUsername())
                .filter(user -> user.getIsActive())
                .filter(user -> passwordEncoder.matches(request.getPassword(), user.getPasswordHash()))
                .map(this::generateLoginResponse);
    }
    
    public LoginResponse generateLoginResponse(User user) {
        String accessToken = jwtUtil.generateToken(user.getUsername(), user.getId(), user.getRole().name());
        String refreshToken = jwtUtil.generateRefreshToken(user.getUsername(), user.getId());
        
        return LoginResponse.builder()
                .accessToken(accessToken)
                .refreshToken(refreshToken)
                .expiresIn(jwtUtil.getExpiration())
                .userInfo(mapToUserInfo(user))
                .build();
    }
    
    public Optional<User> validateToken(String token) {
        if (!jwtUtil.validateToken(token)) {
            return Optional.empty();
        }
        
        String username = jwtUtil.extractUsername(token);
        return userRepository.findByUsername(username)
                .filter(User::getIsActive);
    }
    
    private LoginResponse.UserInfo mapToUserInfo(User user) {
        return LoginResponse.UserInfo.builder()
                .id(user.getId())
                .username(user.getUsername())
                .email(user.getEmail())
                .role(user.getRole().name())
                .companyId(user.getCompanyId())
                .clubId(user.getClubId())
                .build();
    }
}
