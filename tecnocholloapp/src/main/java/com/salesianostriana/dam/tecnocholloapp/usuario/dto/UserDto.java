package com.salesianostriana.dam.tecnocholloapp.usuario.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonView;
import com.salesianostriana.dam.tecnocholloapp.producto.dto.CreateProductDto;
import com.salesianostriana.dam.tecnocholloapp.usuario.model.User;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder

public class UserDto {


    private UUID id;

    private String username;

    private String avatar;
    private String fullName;

    private String role;

    private List<CreateProductDto> productos = new ArrayList<>();

    private List<CreateProductDto> favoritos = new ArrayList<>();

    private String email;
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "dd/MM/yyyy HH:mm:ss")
    private LocalDateTime createdAt;

    private String token;

    public static UserDto fromUser(User user) {

        return UserDto.builder()
                .id(user.getId())
                .username(user.getUsername())
                .avatar(user.getAvatar())
                .fullName(user.getFullName())
                .createdAt(user.getCreatedAt())
                .role(user.getRoles().toString().replace("[", "").replace("]", ""))
                .productos(user.getProducts().stream().map(CreateProductDto::fromProducto).toList())
                .favoritos(user.getFavoritos().stream().map(CreateProductDto::fromProducto).toList())
                .email(user.getEmail())
                .build();
    }

    public static UserDto registerFromUser(User user){
        return UserDto.builder()
                .id(user.getId())
                .username(user.getUsername())
                .avatar(user.getAvatar())
                .fullName(user.getFullName())
                .createdAt(user.getCreatedAt())
                .role(user.getRoles().toString().replace("[", "").replace("]", ""))
                .email(user.getEmail())
                .build();
    }

    public static User of(UserDto dto){

        return User
                .builder()
                .username(dto.getUsername())
                .avatar(dto.getAvatar())
                .fullName(dto.getFullName())
                .createdAt(dto.getCreatedAt())
                .build();
    }

    public static UserDto fromUserToJwt(User user, String token){

        return UserDto
                .builder()
                .id(user.getId())
                .username(user.getUsername())
                .avatar(user.getAvatar())
                .fullName(user.getFullName())
                .createdAt(user.getCreatedAt())
                .role(user.getRoles().toString().replace("[", "").replace("]", ""))
                .email(user.getEmail())
                .token(token)
                .build();
    }


    public UserDto(String username, String fullName, List<CreateProductDto> productos, String aux){
        this.username = username;
        this.fullName = fullName;
        this.productos = productos;
    }

    public UserDto(String username, String fullName, List<CreateProductDto> favoritos){
        this.username = username;
        this.fullName = fullName;
        this.favoritos = favoritos;
    }

    public UserDto(UUID id, String username, String avatar, String fullName, String role, String email, LocalDateTime createdAt) {
        this.id = id;
        this.username = username;
        this.avatar = avatar;
        this.fullName = fullName;
        this.role = role;
        this.email = email;
        this.createdAt = createdAt;
    }

    public UserDto(String username, String avatar, String fullName, LocalDateTime createdAt) {
        this.username = username;
        this.avatar = avatar;
        this.fullName = fullName;
        this.createdAt = createdAt;
    }

    public UserDto(UUID id, String username, String avatar, String fullName, LocalDateTime createdAt, String token) {
        this.id = id;
        this.username = username;
        this.avatar = avatar;
        this.fullName = fullName;
        this.createdAt = createdAt;
        this.token = token;
    }
}