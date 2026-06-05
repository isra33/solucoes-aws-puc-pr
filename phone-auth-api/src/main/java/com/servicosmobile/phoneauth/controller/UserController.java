package com.servicosmobile.phoneauth.controller;

import com.servicosmobile.phoneauth.dto.ConfirmRequest;
import com.servicosmobile.phoneauth.dto.LoginRequest;
import com.servicosmobile.phoneauth.dto.UpdateUserRequest;
import com.servicosmobile.phoneauth.entity.User;
import com.servicosmobile.phoneauth.service.UserService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/users")
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;

   @PostMapping("/login")
public ResponseEntity<?> login(@RequestBody @Valid LoginRequest request) {
    Object response = userService.login(request);

    if (response instanceof User) {
        return ResponseEntity.ok(response);
    }

    return ResponseEntity
            .status(HttpStatus.ACCEPTED)
            .body(response);
}

    @PostMapping("/confirm")
    public ResponseEntity<User> confirm(@RequestBody @Valid ConfirmRequest request) {
        User user = userService.confirmar(request);
        return ResponseEntity.ok(user);
    }

    @PutMapping("/{id}")
    public ResponseEntity<User> update(
            @PathVariable Long id,
            @RequestBody UpdateUserRequest request
    ) {
        User user = userService.atualizar(id, request);
        return ResponseEntity.ok(user);
    }
}