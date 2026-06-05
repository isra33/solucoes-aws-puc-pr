package com.servicosmobile.phoneauth.service;

import com.servicosmobile.phoneauth.dto.ConfirmRequest;
import com.servicosmobile.phoneauth.dto.LoginRequest;
import com.servicosmobile.phoneauth.dto.UpdateUserRequest;
import com.servicosmobile.phoneauth.entity.ConfirmationCode;
import com.servicosmobile.phoneauth.entity.User;
import com.servicosmobile.phoneauth.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
 
@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepository;
    private final ConfirmationCodeService confirmationCodeService;

public Object login(LoginRequest request) {
    return userRepository
            .findByTelefoneAndUuid(request.getTelefone(), request.getUuid())
            .filter(user -> Boolean.TRUE.equals(user.getAtivo()))
            .map(user -> (Object) user)
            .orElseGet(() -> {
                ConfirmationCode code = confirmationCodeService.gerarCodigo(
                        request.getTelefone(),
                        request.getUuid()
                );

                return code;
            });
}

    public User confirmar(ConfirmRequest request) {
        ConfirmationCode confirmationCode = confirmationCodeService.validarCodigo(
                request.getTelefone(),
                request.getUuid(),
                request.getCodigo()
        );

        User user = userRepository.findByTelefone(request.getTelefone())
                .orElse(User.builder()
                        .telefone(request.getTelefone())
                        .build());

        user.setUuid(request.getUuid());
        user.setAtivo(true);

        User salvo = userRepository.save(user);

        confirmationCodeService.marcarComoUsado(confirmationCode);

        return salvo;
    }

    public User atualizar(Long id, UpdateUserRequest request) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Usuário não encontrado"));

        user.setNome(request.getNome());
        user.setDescricao(request.getDescricao());

        return userRepository.save(user);
    }
}