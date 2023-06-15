package com.salesianostriana.dam.tecnocholloapp.usuario.dto;

import com.salesianostriana.dam.tecnocholloapp.usuario.model.User;
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
public class EditUserDto {

    @NotEmpty(message = "{createUserDto.email.notempty}")
    @Email(message = "{createUserDto.email.email}")
    private String email;

    @NotEmpty(message = "{createUserDto.email.notempty}")
    @Email(message = "{createUserDto.email.email}")
    private String verifyEmail;

    private String avatar;

//    public static EditUserDto fromUser(User user){
//        return EditUserDto
//                .builder()
//                .email(user.getEmail())
//                .verifyEmail()
//                .avatar(user.getAvatar())
//                .build();
//    }
}
