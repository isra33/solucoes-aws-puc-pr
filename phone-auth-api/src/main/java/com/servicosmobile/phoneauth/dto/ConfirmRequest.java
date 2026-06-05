package com.servicosmobile.phoneauth.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class ConfirmRequest {

    @NotBlank
    private String telefone;

    @NotBlank
    private String uuid;

    @NotBlank
    private String codigo;
}