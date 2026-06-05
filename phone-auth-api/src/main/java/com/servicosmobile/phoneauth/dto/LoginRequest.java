package com.servicosmobile.phoneauth.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class LoginRequest {

    @NotBlank
    private String telefone;

    @NotBlank
    private String uuid;
}