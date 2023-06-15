package com.salesianostriana.dam.tecnocholloapp.usuario.dto;

import com.salesianostriana.dam.tecnocholloapp.validation.annotation.FieldsValueMatch;
import com.salesianostriana.dam.tecnocholloapp.validation.annotation.StrongPassword;
import com.salesianostriana.dam.tecnocholloapp.validation.annotation.UniqueEmail;
import com.salesianostriana.dam.tecnocholloapp.validation.annotation.UniqueUsername;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.constraints.Email;
import javax.validation.constraints.NotEmpty;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@FieldsValueMatch.List({
        @FieldsValueMatch(
                field = "password", fieldMatch = "verifyPassword",
                message = "{createUserDto.password.nomatch}"
        ),
        @FieldsValueMatch(
                field = "email", fieldMatch = "verifyEmail",
                message = "{createUserDto.emails.nomatch}"
        )
})
public class CreateUserDto {

    @UniqueUsername(message = "{createUserDto.username.unique}")
    @NotEmpty(message = "{createUserDto.username.notempty}")
    private String username;
    @NotEmpty(message = "{createUserDto.password.notempty}")
    @StrongPassword(message = "{createUserDto.password.strong}")
    private String password;
    @NotEmpty(message = "{createUserDto.verifypassword.notempty}")
    private String verifyPassword;
    @NotEmpty(message = "{createUserDto.email.notempty}")
    @UniqueEmail(message = "{createUserDto.email.unique}")
    @Email(message = "{createUserDto.email.email}")
    private String email;
    @NotEmpty(message = "{createUserDto.email.notempty}")
    @Email(message = "{createUserDto.email.email}")
    private String verifyEmail;
    @NotEmpty(message = "{createUserDto.fullname.notempty}")
    private String fullName;

}