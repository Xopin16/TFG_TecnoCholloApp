package com.salesianostriana.dam.tecnocholloapp.usuario.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.constraints.NotEmpty;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder

public class UserPasswordDto {

    private String oldPassword;
    private String newPassword;
    private String verifyNewPassword;

}
