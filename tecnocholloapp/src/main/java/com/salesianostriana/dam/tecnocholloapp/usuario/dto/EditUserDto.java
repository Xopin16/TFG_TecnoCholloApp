package com.salesianostriana.dam.tecnocholloapp.usuario.dto;

import com.salesianostriana.dam.tecnocholloapp.usuario.model.User;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.constraints.NotEmpty;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class EditUserDto {

    private String fullName;

    private String avatar;

    public static EditUserDto fromUser(User user){
        return EditUserDto
                .builder()
                .fullName(user.getFullName())
                .avatar(user.getAvatar())
                .build();
    }
}
