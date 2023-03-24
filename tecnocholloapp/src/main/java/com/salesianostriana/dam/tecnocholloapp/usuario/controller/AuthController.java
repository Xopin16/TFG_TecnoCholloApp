package com.salesianostriana.dam.tecnocholloapp.usuario.controller;

import com.fasterxml.jackson.annotation.JsonView;
import com.salesianostriana.dam.tecnocholloapp.security.jwt.access.JwtProvider;
import com.salesianostriana.dam.tecnocholloapp.usuario.dto.*;
import com.salesianostriana.dam.tecnocholloapp.usuario.model.User;
import com.salesianostriana.dam.tecnocholloapp.usuario.service.UsuarioService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.ExampleObject;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import javax.validation.Valid;

@RestController
@RequiredArgsConstructor
public class AuthController {

    private final UsuarioService userService;
    private final AuthenticationManager authManager;
    private final JwtProvider jwtProvider;


    @Operation(summary = "Registra un nuevo usuario en la aplicacion")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "201",
                    description = "Se ha registrado el usuario",
                    content = {@Content(mediaType = "application/json",
                            schema = @Schema(implementation = UserDto.class),
                            examples = {@ExampleObject(
                                    value = """
                                                {
                                                    "id": "ac1b0412-8683-13cb-8186-835474d40000",
                                                    "username": "durban",
                                                    "fullName": "Carlos Durbán",
                                                    "role": "USER",
                                                    "email": "durbi@gmail.com",
                                                    "createdAt": "24/02/2023 13:09:55"
                                                }                          
                                            """
                            )}
                    )}),
            @ApiResponse(responseCode = "400",
                    description = "Error en los datos al registrar el usuario",
                    content = @Content),
    })
    @PostMapping("/auth/register")
    public ResponseEntity<UserDto> createUserWithUserRole(@Valid @RequestBody CreateUserDto createUserDto) {

        User user = userService.createUserWithUserRole(createUserDto);
        return ResponseEntity.status(HttpStatus.CREATED).body(UserDto.registerFromUser(user));
    }

    @Operation(summary = "Registra un nuevo administrador en la aplicacion")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "201",
                    description = "Se ha registrado el usuario",
                    content = {@Content(mediaType = "application/json",
                            schema = @Schema(implementation = UserDto.class),
                            examples = {@ExampleObject(
                                    value = """
                                                {
                                                    "id": "ac1b0412-8683-13cb-8186-835474d40000",
                                                    "username": "durban",
                                                    "fullName": "Carlos Durbán",
                                                    "role": "USER",
                                                    "email": "durbi@gmail.com",
                                                    "createdAt": "24/02/2023 13:09:55"
                                                }                            
                                            """
                            )}
                    )}),
            @ApiResponse(responseCode = "400",
                    description = "Error en los datos al registrar el administrador",
                    content = @Content),
    })
    @PostMapping("/auth/register/admin")
    public ResponseEntity<UserDto> createUserWithAdminRole(@Valid @RequestBody CreateUserDto createUserDto) {

        User user = userService.createUserWithAdminRole(createUserDto);
        return ResponseEntity.status(HttpStatus.CREATED).body(UserDto.registerFromUser(user));
    }

    @Operation(summary = "Realiza el inicio de sesión de un nuevo usuario en la aplicacion")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "201",
                    description = "Se ha iniciado sesión correctamente",
                    content = {@Content(mediaType = "application/json",
                            schema = @Schema(implementation = UserDto.class),
                            examples = {@ExampleObject(
                                    value = """
                                               {
                                                    "username": "user1",
                                                    "avatar": http://avatar.com/user1,
                                                    "fullName": "Luismi López",
                                                    "createdAt": "27/09/2021 00:00:00"
                                                }                             
                                            """
                            )}
                    )}),
            @ApiResponse(responseCode = "400",
                    description = "Error en los datos al iniciar sesión",
                    content = @Content),
    })
    @PostMapping("/auth/login")
    public ResponseEntity<UserDto> login(@Valid @RequestBody LoginUserDto loginUserDto) {

        Authentication authentication =
                authManager.authenticate(
                        new UsernamePasswordAuthenticationToken(
                                loginUserDto.getUsername(),
                                loginUserDto.getPassword()
                        )
                );

        SecurityContextHolder.getContext().setAuthentication(authentication);

        String token = jwtProvider.generateToken(authentication);

        User user = (User) authentication.getPrincipal();

        return ResponseEntity.status(HttpStatus.CREATED)
                .body(UserDto.fromUserToJwt(user, token));

    }

    @Operation(summary = "Cambia la contraseña de un usuario")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "201",
                    description = "Se ha cambiado la contraseña correctamente",
                    content = {@Content(mediaType = "application/json",
                            schema = @Schema(implementation = UserDto.class),
                            examples = {@ExampleObject(
                                    value = """
                                               {
                                                    "username": "user1",
                                                    "avatar": http://avatar.com/user1,
                                                    "fullName": "Luismi López",
                                                    "createdAt": "27/09/2021 00:00:00"
                                                }                             
                                            """
                            )}
                    )}),
            @ApiResponse(responseCode = "400",
                    description = "Error en los datos al editar la contraseña",
                    content = @Content),
    })
    @JsonView({UserViews.Master.class})
    @PutMapping("/user/changePassword")
    public ResponseEntity<UserDto> changePassword(@Valid @RequestBody UserPasswordDto userPasswordDto,
                                                  @AuthenticationPrincipal User loggedUser) {

        User modified = userService.editPassword(loggedUser.getId(), userPasswordDto.getNewPassword());
        return ResponseEntity.ok(UserDto.fromUser(modified));
    }

}
