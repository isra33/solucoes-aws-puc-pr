# 📱 Phone Auth API + Flutter App

## Serviços Mobile em Cloud AWS – PUC-PR

### Tema 1 – Login por Telefone

Este projeto foi desenvolvido para a disciplina **Serviços Mobile em Cloud AWS** da **PUC-PR**.

O objetivo do trabalho foi implementar um sistema de autenticação utilizando **telefone + UUID do dispositivo**, conforme especificado no Tema 1 da atividade.

---

# 👨‍💻 Integrantes

* Israel Bulcão Tavares 

---

---

# 👨‍💻 Professor

* Prof. Vinícius Mendonça

---

# 🎥 Vídeo de Demonstração

Link do vídeo:

```text
https://www.youtube.com/watch?v=UpqPb8Nny1Y
```

O vídeo apresenta:

* Estrutura do projeto Spring Boot
* Estrutura do aplicativo Flutter
* Funcionamento do banco H2
* Fluxo completo de autenticação
* Login inicial
* Confirmação de código SMS
* Login de usuário ativo
* Troca de dispositivo
* Atualização de perfil
* Integração Flutter + API

---

# 📋 Requisitos Implementados

### Login por telefone

✔ Recebimento de telefone e UUID

✔ Login automático para usuários ativos

✔ Geração de código SMS para novos dispositivos

✔ Retorno HTTP 202 quando confirmação é necessária

✔ Confirmação utilizando código SMS

✔ Ativação automática de usuário

✔ Troca de UUID em caso de novo dispositivo

✔ Atualização de perfil via PUT

✔ Aplicativo Flutter integrado à API

---

# 🏗 Arquitetura Backend

Tecnologias utilizadas:

* Java 21
* Spring Boot 3.5.14
* Spring Data JPA
* Spring Security
* H2 Database
* Maven
* Lombok

Estrutura do projeto:

```text
src/main/java

com.servicosmobile.phoneauth

├── config
│   └── SecurityConfig.java
│
├── controller
│   └── UserController.java
│
├── dto
│   ├── LoginRequest.java
│   ├── ConfirmRequest.java
│   └── UpdateUserRequest.java
│
├── entity
│   ├── User.java
│   └── ConfirmationCode.java
│
├── repository
│   ├── UserRepository.java
│   └── ConfirmationCodeRepository.java
│
├── service
│   ├── UserService.java
│   └── ConfirmationCodeService.java
│
└── PhoneAuthApplication.java
```

---

# 📱 Arquitetura Flutter

Tecnologias utilizadas:

* Flutter
* Dart
* HTTP Package
* Shared Preferences
* UUID Package
* Device Info Plus

Estrutura:

```text
lib

├── models
│   └── user.dart
│
├── services
│   └── auth_service.dart
│
├── screens
│   ├── login_screen.dart
│   ├── confirm_code_screen.dart
│   ├── home_screen.dart
│   └── edit_profile_screen.dart
│
├── widgets
│   └── app_snackbar.dart
│
└── main.dart
```

---

# 🔄 Fluxo de Autenticação

## 1. Login Inicial

Endpoint:

```http
POST /users/login
```

Request:

```json
{
  "telefone": "71999999999",
  "uuid": "abc-123"
}
```

Resposta:

```http
202 Accepted
```

O sistema gera um código de confirmação.

---

## 2. Confirmar Código SMS

Endpoint:

```http
POST /users/confirm
```

Request:

```json
{
  "telefone": "71999999999",
  "uuid": "abc-123",
  "codigo": "465796"
}
```

Resposta:

```http
200 OK
```

O usuário é criado e ativado.

---

## 3. Login de Usuário Ativo

Endpoint:

```http
POST /users/login
```

Request:

```json
{
  "telefone": "71999999999",
  "uuid": "abc-123"
}
```

Resposta:

```http
200 OK
```

O usuário é autenticado imediatamente.

---

## 4. Atualização de Perfil

Endpoint:

```http
PUT /users/{id}
```

Request:

```json
{
  "nome": "Israel Tavares",
  "descricao": "Aluno da PUC-PR"
}
```

Resposta:

```http
200 OK
```

Perfil atualizado com sucesso.

---

## 5. Novo Dispositivo

Caso o usuário utilize outro dispositivo:

```json
{
  "telefone": "71999999999",
  "uuid": "novo-dispositivo-001"
}
```

O sistema gera um novo código SMS.

Após confirmação:

```http
POST /users/confirm
```

o UUID antigo é substituído pelo novo.

---

# 📱 UUID por Plataforma

### Android

O aplicativo gera um UUID utilizando:

```dart
Uuid().v4()
```

e o armazena localmente usando SharedPreferences.

### iOS

Foi implementado suporte ao:

```text
identifierForVendor
```

utilizando o pacote:

```dart
device_info_plus
```

conforme sugerido no enunciado da atividade.

---

# 🗄 Banco de Dados

Foi utilizado o banco em memória H2.

Tabelas principais:

```text
USERS
CONFIRMATION_CODES
```

A tabela USERS armazena:

* id
* telefone
* uuid
* nome
* descricao
* ativo

A tabela CONFIRMATION_CODES armazena:

* telefone
* uuid
* codigo
* usado
* criadoEm

---

# ▶ Como Executar

## Backend

Executar:

```bash
mvn spring-boot:run
```

API:

```text
http://localhost:8080
```

Console H2:

```text
http://localhost:8080/h2-console
```

---

## Flutter

Instalar dependências:

```bash
flutter pub get
```

Executar:

```bash
flutter run
```

---

# 📚 Considerações Finais

Este projeto implementa integralmente os requisitos obrigatórios do Tema 1 – Login por Telefone, demonstrando a integração entre:

* Spring Boot
* H2 Database
* Flutter
* UUID por dispositivo
* Fluxo de confirmação por SMS
* Atualização de perfil
* Troca de dispositivo com validação de segurança

Projeto desenvolvido para fins acadêmicos na disciplina Serviços Mobile em Cloud AWS.
