package com.servicosmobile.phoneauth.repository;

import com.servicosmobile.phoneauth.entity.ConfirmationCode;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface ConfirmationCodeRepository
        extends JpaRepository<ConfirmationCode, Long> {

    Optional<ConfirmationCode> findTopByTelefoneAndUuidAndCodigoAndUsadoFalse(
            String telefone,
            String uuid,
            String codigo
    );
}