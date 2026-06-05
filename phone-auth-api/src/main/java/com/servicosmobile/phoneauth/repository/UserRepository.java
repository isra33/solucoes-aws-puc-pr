package com.servicosmobile.phoneauth.repository;

import com.servicosmobile.phoneauth.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface UserRepository extends JpaRepository<User, Long> {

    Optional<User> findByTelefone(String telefone);

    Optional<User> findByTelefoneAndUuid(
            String telefone,
            String uuid
    );
}