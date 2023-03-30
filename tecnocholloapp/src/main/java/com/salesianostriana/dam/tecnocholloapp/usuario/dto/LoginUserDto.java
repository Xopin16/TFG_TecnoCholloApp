package com.salesianostriana.dam.tecnocholloapp.usuario.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.constraints.NotEmpty;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class LoginUserDto {

    @NotEmpty(message = "{createUserDto.username.notempty}")
    private String username;
    @NotEmpty(message = "{createUserDto.password.notempty}")
    private String password;

}

