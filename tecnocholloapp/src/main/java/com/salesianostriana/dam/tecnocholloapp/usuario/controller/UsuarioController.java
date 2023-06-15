package com.salesianostriana.dam.tecnocholloapp.usuario.controller;

import com.fasterxml.jackson.annotation.JsonView;
import com.salesianostriana.dam.tecnocholloapp.file.StorageService;
import com.salesianostriana.dam.tecnocholloapp.page.PageDto;
import com.salesianostriana.dam.tecnocholloapp.search.util.SearchCriteria;
import com.salesianostriana.dam.tecnocholloapp.search.util.SearchCriteriaExtractor;
import com.salesianostriana.dam.tecnocholloapp.security.jwt.refresh.RefreshTokenService;
import com.salesianostriana.dam.tecnocholloapp.usuario.dto.EditUserDto;
import com.salesianostriana.dam.tecnocholloapp.usuario.dto.UserDto;
import com.salesianostriana.dam.tecnocholloapp.usuario.dto.UserViews;
import com.salesianostriana.dam.tecnocholloapp.usuario.model.User;
import com.salesianostriana.dam.tecnocholloapp.usuario.service.UsuarioService;
import com.salesianostriana.dam.tecnocholloapp.utils.MediaTypeUrlResource;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.ArraySchema;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.ExampleObject;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import lombok.RequiredArgsConstructor;
import org.springframework.core.io.Resource;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.validation.Valid;
import java.util.List;
import java.util.UUID;

@RestController
@RequiredArgsConstructor
public class UsuarioController {

    private final UsuarioService usuarioService;

    private final StorageService storageService;

    private final RefreshTokenService refreshTokenService;

    @Operation(summary = "Obtiene un listado de usuarios")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200",
                    description = "Se ha encontrado un listado de usuarios",
                    content = {@Content(mediaType = "application/json",
                            array = @ArraySchema(schema = @Schema(implementation = UserDto.class)),
                            examples = {@ExampleObject(
                                    value = """                                                                                      
                                            [
                                                {
                                                    "username": "mhoggins0",
                                                    "avatar": "http://avatar.com/mhoggins0",
                                                    "fullName": "Miguel Hog",
                                                    "createdAt": "26/09/2021 00:00:00"
                                                },
                                                {
                                                    "username": "user1",
                                                    "avatar": http://avatar.com/user1,
                                                    "fullName": "Luismi López",
                                                    "createdAt": "27/09/2021 00:00:00"
                                                }
                                            ]                                    
                                            """
                            )}
                    )}),
            @ApiResponse(responseCode = "404",
                    description = "No se ha encontrado el listado de usuarios",
                    content = @Content),
    })
    @JsonView(UserViews.Master.class)
    @GetMapping("/usuario/")
    public PageDto<UserDto> obtenerTodos(
            @RequestParam(value = "s", defaultValue = "") String search,
            @PageableDefault(size = 10, page = 0) Pageable pageable) {

        List<SearchCriteria> params = SearchCriteriaExtractor.extractSearchCriteriaList(search);

        return usuarioService.search(params, pageable);
    }


    @Operation(summary = "Obtiene una usuario en base a su ID")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200",
                    description = "Se ha encontrado el usuario",
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
            @ApiResponse(responseCode = "404",
                    description = "No se ha encontrado el usuario por el ID",
                    content = @Content),
    })
    @JsonView(UserViews.Master.class)
    @GetMapping("/usuario/{id}")
    public UserDto verPerfiles(@PathVariable UUID id) {
        User user = usuarioService.findUserById(id);
        return UserDto.fromUser(user);
    }

    @Operation(summary = "Obtiene los datos de un usuario autenticado")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200",
                    description = "Se ha obtenido el usuario",
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
            @ApiResponse(responseCode = "401",
                    description = "No hay autenticación para ver al usuario",
                    content = @Content),
    })
    @PreAuthorize("isAuthenticated()")
    @JsonView(UserViews.Master.class)
    @GetMapping("/usuario/me")
    public UserDto verPerfil(@AuthenticationPrincipal User user) {
        User usuario = usuarioService.findUserProducts(user.getId());
        return UserDto.fromUser(usuario);
    }

    @Operation(summary = "Edita los datos personales del usuario autenticado")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200",
                    description = "Se ha editado el usuario correctamente",
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
            @ApiResponse(responseCode = "401",
                    description = "No hay autenticación para editar el usuario",
                    content = @Content),
            @ApiResponse(responseCode = "400",
                    description = "Error en los datos del usuario",
                    content = @Content),
    })
    @JsonView({UserViews.Login.class})
    @PutMapping(value = "/usuario/", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public UserDto modificarDatosPersonales(
            @Valid @RequestPart("body") EditUserDto editUserDto,
            @AuthenticationPrincipal User user,
            @RequestPart("file") MultipartFile file){
        User usuario = usuarioService.findUserProducts(user.getId());
        User created = usuarioService.edit(usuario.getId(), editUserDto, file);
        return UserDto.fromUser(created);
    }

    @PostMapping("/upload/avatar")
    public UserDto create(
            @RequestPart("file") MultipartFile file,
            @AuthenticationPrincipal User user
    ) {
        User usuario = usuarioService.findUserProducts(user.getId());
        usuarioService.saveFile(usuario, file);
        return UserDto.fromUser(usuario);
    }

    @GetMapping("/download/{filename:.+}")
    public ResponseEntity<Resource> getFile(@PathVariable String filename){
        MediaTypeUrlResource resource =
                (MediaTypeUrlResource) storageService.loadAsResource(filename);

        return ResponseEntity.status(HttpStatus.OK)
                .header("Content-Type", resource.getType())
                .body(resource);
    }

    @Operation(summary = "Elimina un usuario en base a su ID")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "204",
                    description = "El destinatario ha sido eliminado correctamente",
                    content = {@Content(mediaType = "application/json",
                            schema = @Schema(implementation = User.class))}),
            @ApiResponse(responseCode = "404",
                    description = "No se encuentra un destinatario con este ID",
                    content = @Content),
    })

    @DeleteMapping("/usuario/")
    public ResponseEntity<?> eliminarMiUsuario(@AuthenticationPrincipal User user) {

        refreshTokenService.deleteByUser(user);
        usuarioService.delete(user.getId());
        return ResponseEntity.noContent().build();
    }

    //ADMIN
//    @Operation(summary = "Edita como administrador los datos personales de un usuario en base a su ID ")
//    @ApiResponses(value = {
//            @ApiResponse(responseCode = "200",
//                    description = "Se ha editado el usuario correctamente",
//                    content = {@Content(mediaType = "application/json",
//                            schema = @Schema(implementation = UserDto.class),
//                            examples = {@ExampleObject(
//                                    value = """
//                                            {
//                                                    "username": "user1",
//                                                    "avatar": http://avatar.com/user1,
//                                                    "fullName": "Luismi López",
//                                                    "createdAt": "27/09/2021 00:00:00"
//                                                }
//                                            """
//                            )}
//                    )}),
//            @ApiResponse(responseCode = "401",
//                    description = "No hay autenticación para editar el usuario",
//                    content = @Content),
//            @ApiResponse(responseCode = "400",
//                    description = "Error en los datos del usuario",
//                    content = @Content),
//    })
//    @JsonView({UserViews.Login.class})
//    @PutMapping(value = "/admin/usuario/{id}", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
//    public UserDto modificarDatosAdmin(@Valid @RequestPart("body") EditUserDto editUserDto, @PathVariable UUID id){
////        User user = usuarioService.findUserById(id);
//        User usuario = usuarioService.findUserProducts(id);
//        usuarioService.edit(usuario.getId(), editUserDto);
//        return UserDto.fromUser(usuario);
//    }


    @Operation(summary = "Como administrador, elimina un usuario en base a su ID")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "204",
                    description = "El usuario ha sido eliminado correctamente",
                    content = {@Content(mediaType = "application/json",
                            schema = @Schema(implementation = User.class))}),
            @ApiResponse(responseCode = "404",
                    description = "No se encuentra un usuario con este ID",
                    content = @Content),
    })
    @DeleteMapping("/admin/usuario/{id}")
    public ResponseEntity<?> eliminarUsuarioAdmin(@PathVariable UUID id) {

        usuarioService.deleteById(id);
        return ResponseEntity.noContent().build();
    }


}
