package com.servicosmobile.phoneauth.service;

import com.servicosmobile.phoneauth.entity.ConfirmationCode;
import com.servicosmobile.phoneauth.repository.ConfirmationCodeRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.Random;

@Service
@RequiredArgsConstructor
public class ConfirmationCodeService {

    private final ConfirmationCodeRepository confirmationCodeRepository;

    public ConfirmationCode gerarCodigo(String telefone, String uuid) {
        String codigo = String.valueOf(new Random().nextInt(900000) + 100000);

        ConfirmationCode confirmationCode = ConfirmationCode.builder()
                .telefone(telefone)
                .uuid(uuid)
                .codigo(codigo)
                .usado(false)
                .criadoEm(LocalDateTime.now())
                .build();

        ConfirmationCode salvo = confirmationCodeRepository.save(confirmationCode);

        System.out.println("SMS SIMULADO");
        System.out.println("Telefone: " + telefone);
        System.out.println("Código: " + codigo);

        return salvo;
    }

    public ConfirmationCode validarCodigo(String telefone, String uuid, String codigo) {

    System.out.println("====== VALIDANDO ======");
    System.out.println("Telefone: " + telefone);
    System.out.println("UUID: " + uuid);
    System.out.println("Código: " + codigo);

    return confirmationCodeRepository
            .findTopByTelefoneAndUuidAndCodigoAndUsadoFalse(
                    telefone,
                    uuid,
                    codigo
            )
            .orElseThrow(() -> new RuntimeException("Código de confirmação não encontrado"));
}

    public void marcarComoUsado(ConfirmationCode confirmationCode) {
        confirmationCode.setUsado(true);
        confirmationCodeRepository.save(confirmationCode);
    }
}