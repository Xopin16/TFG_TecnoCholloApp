package com.salesianostriana.dam.tecnocholloapp.usuario.dto;

import com.salesianostriana.dam.tecnocholloapp.validation.annotation.FieldsValueMatch;
import com.salesianostriana.dam.tecnocholloapp.validation.annotation.OldPasswordMatch;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.constraints.NotEmpty;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@FieldsValueMatch(field = "newPassword", fieldMatch = "verifyNewPassword")
@OldPasswordMatch(oldPasswordField = "oldPassword", newPasswordField = "newPassword")
public class UserPasswordDto {

    private String oldPassword;
    private String newPassword;
    private String verifyNewPassword;

}
