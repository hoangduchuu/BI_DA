package com.acme.bida.dto;

import lombok.Data;
import lombok.Builder;

@Data
@Builder
public class LoginResponse {
    private String accessToken;
    private String refreshToken;
    private String tokenType = "Bearer";
    private Long expiresIn;
    private UserInfo userInfo;
    
    @Data
    @Builder
    public static class UserInfo {
        private Long id;
        private String username;
        private String email;
        private String role;
        private Long companyId;
        private Long clubId;
    }
}
