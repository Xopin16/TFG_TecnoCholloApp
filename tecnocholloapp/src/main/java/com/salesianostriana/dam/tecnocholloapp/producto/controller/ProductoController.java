package com.salesianostriana.dam.tecnocholloapp.producto.controller;

import com.salesianostriana.dam.tecnocholloapp.categoria.service.CategoriaService;
import com.salesianostriana.dam.tecnocholloapp.page.PageDto;
import com.salesianostriana.dam.tecnocholloapp.producto.dto.CreateProductDto;
import com.salesianostriana.dam.tecnocholloapp.producto.dto.ProductDto;
import com.salesianostriana.dam.tecnocholloapp.producto.model.Product;
import com.salesianostriana.dam.tecnocholloapp.producto.repository.ProductoRepository;
import com.salesianostriana.dam.tecnocholloapp.producto.service.ProductoService;
import com.salesianostriana.dam.tecnocholloapp.search.util.SearchCriteria;
import com.salesianostriana.dam.tecnocholloapp.search.util.SearchCriteriaExtractor;
import com.salesianostriana.dam.tecnocholloapp.usuario.dto.UserDto;
import com.salesianostriana.dam.tecnocholloapp.usuario.model.User;
import com.salesianostriana.dam.tecnocholloapp.usuario.service.UsuarioService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.ArraySchema;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.ExampleObject;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import javax.validation.Valid;
import java.net.URI;
import java.util.List;
import java.util.UUID;

@RestController
@RequiredArgsConstructor
public class ProductoController {

    private final ProductoService productoService;

    private final ProductoRepository productoRepository;

    private final UsuarioService usuarioService;

    private final CategoriaService categoriaService;

    @Operation(summary = "Obtiene un listado de productos")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200",
                    description = "Se ha encontrado un listado de productos",
                    content = {@Content(mediaType = "application/json",
                            array = @ArraySchema(schema = @Schema(implementation = ProductDto.class)),
                            examples = {@ExampleObject(
                                    value = """                                                                                      
                                              {
                                                  "content": [
                                                      {
                                                          "id": 11,
                                                          "nombre": "Samsung Galaxy S21",
                                                          "precio": 799.99,
                                                          "descripcion": "El nuevo modelo de Samsung",
                                                          "imagen": "movil.jpg",
                                                          "fechaPublicacion": "2022-02-23",
                                                          "categoria": "Moviles",
                                                          "usuario": "mhoggins0"
                                                      },
                                                      {
                                                          "id": 12,
                                                          "nombre": "iPhone 13 Pro",
                                                          "precio": 1099.99,
                                                          "descripcion": "El Ãºltimo modelo de Apple",
                                                          "imagen": "movil.jpg",
                                                          "fechaPublicacion": "2022-02-23",
                                                          "categoria": "Moviles",
                                                          "usuario": "mhoggins0"
                                                      },
                                                      {
                                                          "id": 13,
                                                          "nombre": "OnePlus 10",
                                                          "precio": 799.99,
                                                          "descripcion": "El nuevo modelo de OnePlus",
                                                          "imagen": "movil.jpg",
                                                          "fechaPublicacion": "2022-02-23",
                                                          "categoria": "Moviles",
                                                          "usuario": "mhoggins0"
                                                      },
                                                  ],
                                                  "currentPage": 0,
                                                  "last": false,
                                                  "first": true,
                                                  "totalPages": 7,
                                                  "totalElements": 98
                                              }                                      
                                            """
                            )}
                    )}),
            @ApiResponse(responseCode = "404",
                    description = "No se ha encontrado el listado de productos",
                    content = @Content),
            @ApiResponse(responseCode = "401",
                    description = "El usuario no está loggeado",
                    content = @Content),
            @ApiResponse(responseCode = "403",
                    description = "Sesión expirada o acceso restringido",
                    content = @Content),
    })
    @GetMapping("/producto/")
    public PageDto<ProductDto> obtenerTodos(
            @RequestParam(value = "s", defaultValue = "") String search,
            @PageableDefault(size = 10, page = 0) Pageable pageable,
            @AuthenticationPrincipal User user) {
        User usuario = usuarioService.findUserProducts(user.getId());
        List<SearchCriteria> params = SearchCriteriaExtractor.extractSearchCriteriaList(search);
        return productoService.search(params, pageable, usuario);
    }


    @Operation(summary = "Obtiene una producto en base a su ID")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200",
                    description = "Se ha encontrado el producto",
                    content = {@Content(mediaType = "application/json",
                            schema = @Schema(implementation = ProductDto.class),
                            examples = {@ExampleObject(
                                    value = """
                                            {
                                                "id": 11,
                                                "nombre": "Samsung Galaxy S21",
                                                "precio": 799.99,
                                                "descripcion": "El nuevo modelo de Samsung",
                                                "imagen": "movil.jpg",
                                                "fechaPublicacion": "2022-02-23",
                                                "categoria": "Moviles",
                                                "usuario": "mhoggins0"
                                            }                                 
                                            """
                            )}
                    )}),
            @ApiResponse(responseCode = "404",
                    description = "No se ha encontrado el producto por el ID",
                    content = @Content),
            @ApiResponse(responseCode = "401",
                    description = "El usuario no está loggeado",
                    content = @Content),
            @ApiResponse(responseCode = "403",
                    description = "Sesión expirada o acceso restringido",
                    content = @Content),
    })
    @GetMapping("/producto/{id}")
    public ProductDto obtenerUno(@Valid @PathVariable Long id, @AuthenticationPrincipal User user) {
        Product product = productoService.findById(id);
        User usuario = usuarioService.findUserProducts(user.getId());
        return ProductDto.fromProduct(product, usuario);
    }

        @Operation(summary = "Obtiene una los productos publicados del usuario autenticado")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200",
                    description = "Se han obtenido las publicaciones del usuario",
                    content = {@Content(mediaType = "application/json",
                            schema = @Schema(implementation = ProductDto.class),
                            examples = {@ExampleObject(
                                    value = """
                                              {
                                                  "content": [
                                                      {
                                                          "id": 11,
                                                          "nombre": "Samsung Galaxy S21",
                                                          "precio": 799.99,
                                                          "descripcion": "El nuevo modelo de Samsung",
                                                          "imagen": "movil.jpg",
                                                          "fechaPublicacion": "2022-02-23",
                                                          "categoria": "Moviles",
                                                          "usuario": "mhoggins0"
                                                      },
                                                      {
                                                          "id": 12,
                                                          "nombre": "iPhone 13 Pro",
                                                          "precio": 1099.99,
                                                          "descripcion": "El Ãºltimo modelo de Apple",
                                                          "imagen": "movil.jpg",
                                                          "fechaPublicacion": "2022-02-23",
                                                          "categoria": "Moviles",
                                                          "usuario": "mhoggins0"
                                                      },
                                                      {
                                                          "id": 13,
                                                          "nombre": "OnePlus 10",
                                                          "precio": 799.99,
                                                          "descripcion": "El nuevo modelo de OnePlus",
                                                          "imagen": "movil.jpg",
                                                          "fechaPublicacion": "2022-02-23",
                                                          "categoria": "Moviles",
                                                          "usuario": "mhoggins0"
                                                      },
                                                  ],
                                                  "currentPage": 0,
                                                  "last": false,
                                                  "first": true,
                                                  "totalPages": 7,
                                                  "totalElements": 98
                                              }  
                                            """
                            )}
                    )}),
            @ApiResponse(responseCode = "401",
                    description = "No hay autenticación para ver los productos del usuario",
                    content = @Content),
            @ApiResponse(responseCode = "401",
                    description = "El usuario no está loggeado",
                    content = @Content),
            @ApiResponse(responseCode = "403",
                    description = "Sesión expirada o acceso restringido",
                    content = @Content),
    })
    @GetMapping("/usuario/producto/")
    public PageDto<ProductDto> mostrarMisChollos(
            @PageableDefault(size = 10, page = 0) Pageable pageable,
            @AuthenticationPrincipal User user){
        User usuario = usuarioService.findUserProducts(user.getId());
        return productoService.paginarChollos(usuario, pageable);
    }


    @Operation(summary = "Obtiene una los productos publicados de un usuario por su ID")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200",
                    description = "Se ha obtenido el usuario y sus publicaciones",
                    content = {@Content(mediaType = "application/json",
                            schema = @Schema(implementation = ProductDto.class),
                            examples = {@ExampleObject(
                                    value = """
                              {
                                                  "content": [
                                                      {
                                                          "id": 11,
                                                          "nombre": "Samsung Galaxy S21",
                                                          "precio": 799.99,
                                                          "descripcion": "El nuevo modelo de Samsung",
                                                          "imagen": "movil.jpg",
                                                          "fechaPublicacion": "2022-02-23",
                                                          "categoria": "Moviles",
                                                          "usuario": "mhoggins0"
                                                      },
                                                      {
                                                          "id": 12,
                                                          "nombre": "iPhone 13 Pro",
                                                          "precio": 1099.99,
                                                          "descripcion": "El Ãºltimo modelo de Apple",
                                                          "imagen": "movil.jpg",
                                                          "fechaPublicacion": "2022-02-23",
                                                          "categoria": "Moviles",
                                                          "usuario": "mhoggins0"
                                                      },
                                                      {
                                                          "id": 13,
                                                          "nombre": "OnePlus 10",
                                                          "precio": 799.99,
                                                          "descripcion": "El nuevo modelo de OnePlus",
                                                          "imagen": "movil.jpg",
                                                          "fechaPublicacion": "2022-02-23",
                                                          "categoria": "Moviles",
                                                          "usuario": "mhoggins0"
                                                      },
                                                  ],
                                                  "currentPage": 0,
                                                  "last": false,
                                                  "first": true,
                                                  "totalPages": 7,
                                                  "totalElements": 98
                                              }   
                                            """
                            )}
                    )}),
            @ApiResponse(responseCode = "401",
                    description = "No hay autenticación para ver los productos del usuario",
                    content = @Content),
            @ApiResponse(responseCode = "401",
                    description = "El usuario no está loggeado",
                    content = @Content),
            @ApiResponse(responseCode = "403",
                    description = "Sesión expirada o acceso restringido",
                    content = @Content),
    })
    @GetMapping("/usuario/{id}/producto/")
    public PageDto<ProductDto> mostrarPublicaciones(
            @PageableDefault(size = 5, page = 0) Pageable pageable,
            @PathVariable UUID id){
        User usuario = usuarioService.findUserProducts(id);
        return productoService.paginarChollos(usuario, pageable);
    }


    @Operation(summary = "Crea un nuevo producto")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "201",
                    description = "Se ha creado el producto",
                    content = {@Content(mediaType = "application/json",
                            schema = @Schema(implementation = ProductDto.class),
                            examples = {@ExampleObject(
                                    value = """
                                            {
                                                "id": 11,
                                                "nombre": "Samsung Galaxy S21",
                                                "precio": 799.99,
                                                "descripcion": "El nuevo modelo de Samsung",
                                                "imagen": "movil.jpg",
                                                "fechaPublicacion": "2022-02-23",
                                                "categoria": "Moviles",
                                                "usuario": "mhoggins0"
                                            }                                 
                                            """
                            )}
                    )}),
            @ApiResponse(responseCode = "400",
                    description = "Error en los datos del producto",
                    content = @Content),
            @ApiResponse(responseCode = "401",
                    description = "El usuario no está loggeado",
                    content = @Content),
            @ApiResponse(responseCode = "403",
                    description = "Sesión expirada o acceso restringido",
                    content = @Content),
    })
    @PreAuthorize("isAuthenticated()")
    @PostMapping(value = "/product", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<ProductDto>crearProducto(
            @RequestPart("body") CreateProductDto productDto,
            @AuthenticationPrincipal User user,
            @RequestPart("file")MultipartFile file){

        Product created = productoService.saveProduct(user.getId(), productDto, file);
        User usuario = usuarioService.findUserProducts(user.getId());

        URI createdURI = ServletUriComponentsBuilder
                .fromCurrentRequest()
                .path("/{id}")
                .buildAndExpand(created.getId()).toUri();

        return ResponseEntity
                .created(createdURI)
                .body(ProductDto.fromProduct(created, usuario));
    }


    @Operation(summary = "Edita un producto del usuario en base a su ID")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "201",
                    description = "Se ha editado el producto",
                    content = {@Content(mediaType = "application/json",
                            schema = @Schema(implementation = ProductDto.class),
                            examples = {@ExampleObject(
                                    value = """
                                           {
                                                "id": 11,
                                                "nombre": "Samsung Galaxy S21",
                                                "precio": 799.99,
                                                "descripcion": "El nuevo modelo de Samsung",
                                                "imagen": "movil.jpg",
                                                "fechaPublicacion": "2022-02-23",
                                                "categoria": "Moviles",
                                                "usuario": "mhoggins0"
                                            }                               
                                            """
                            )}
                    )}),
            @ApiResponse(responseCode = "400",
                    description = "Fallo en los datos al editar producto",
                    content = @Content),
            @ApiResponse(responseCode = "404",
                    description = "No se ha podido encontrar el producto por su ID",
                    content = @Content),
            @ApiResponse(responseCode = "401",
                    description = "El usuario no está loggeado",
                    content = @Content),
            @ApiResponse(responseCode = "403",
                    description = "Sesión expirada o acceso restringido",
                    content = @Content),
    })
    @PreAuthorize("isAuthenticated()")
    @PutMapping(value = "/usuario/product/{id}", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public CreateProductDto editarProducto(
            @Valid @RequestPart("body") CreateProductDto productDto,
            @AuthenticationPrincipal User user ,
            @PathVariable Long id,
            @RequestPart("file")MultipartFile file) {
        User usuario = usuarioService.findUserProducts(user.getId());
        Product edit = productoService.editMiProduct(id, productDto, usuario, file);
        return CreateProductDto.fromProducto(edit);
    }

    @Operation(summary = "Como administrador, edita un producto en base a su ID")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "201",
                    description = "Se ha editado el producto",
                    content = {@Content(mediaType = "application/json",
                            schema = @Schema(implementation = ProductDto.class),
                            examples = {@ExampleObject(
                                    value = """
                                            {
                                                "id": 11,
                                                "nombre": "Samsung Galaxy S21",
                                                "precio": 799.99,
                                                "descripcion": "El nuevo modelo de Samsung",
                                                "imagen": "movil.jpg",
                                                "fechaPublicacion": "2022-02-23",
                                                "categoria": "Moviles",
                                                "usuario": "mhoggins0"
                                            }                                  
                                            """
                            )}
                    )}),
            @ApiResponse(responseCode = "400",
                    description = "Fallo en los datos al editar producto",
                    content = @Content),
            @ApiResponse(responseCode = "404",
                    description = "No se ha podido encontrar el producto por su ID",
                    content = @Content),
            @ApiResponse(responseCode = "401",
                    description = "El usuario no está loggeado",
                    content = @Content),
            @ApiResponse(responseCode = "403",
                    description = "Sesión expirada o acceso restringido",
                    content = @Content),
    })
    @PutMapping("/admin/producto/{id}")
    public CreateProductDto editarProductoAdmin(@Valid @RequestBody CreateProductDto productDto, @PathVariable Long id) {
        Product edit = productoService.editProduct(id, productDto);
        return CreateProductDto.fromProducto(edit);
    }

    @Operation(summary = "Como administrador, elimina un producto en base a su ID")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "204",
                    description = "El producto ha sido eliminado correctamente",
                    content = {@Content(mediaType = "application/json",
                            schema = @Schema(implementation = ProductDto.class))}),
            @ApiResponse(responseCode = "404",
                    description = "No se encuentra un producto con este ID",
                    content = @Content),
            @ApiResponse(responseCode = "401",
                    description = "El usuario no está loggeado",
                    content = @Content),
            @ApiResponse(responseCode = "403",
                    description = "Sesión expirada o acceso restringido",
                    content = @Content),
    })
    @DeleteMapping("/admin/producto/{id}")
    public ResponseEntity<?> eliminarProductoAdmin(@PathVariable Long id) {

        productoService.delete(id);
        return ResponseEntity.noContent().build();
    }

    @Operation(summary = "Elimina un producto del en base a su ID")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "204",
                    description = "El producto ha sido eliminado correctamente",
                    content = {@Content(mediaType = "application/json",
                            schema = @Schema(implementation = ProductDto.class))}),
            @ApiResponse(responseCode = "404",
                    description = "No se encuentra un producto con este ID",
                    content = @Content),
            @ApiResponse(responseCode = "401",
                    description = "El usuario no está loggeado",
                    content = @Content),
            @ApiResponse(responseCode = "403",
                    description = "Sesión expirada o acceso restringido",
                    content = @Content),
    })
    @DeleteMapping("/usuario/producto/{id}")
    public ResponseEntity<?> eliminarMiProducto(@PathVariable Long id, @AuthenticationPrincipal User user) {
        User usuario = usuarioService.findUserProducts(user.getId());
        productoService.deleteMiProducto(id, usuario);
        return ResponseEntity.noContent().build();
    }


    @Operation(summary = "Agrega un producto a favoritos en base a su ID")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200",
                    description = "Se ha agregado el producto",
                    content = {@Content(mediaType = "application/json",
                            schema = @Schema(implementation = ProductDto.class),
                            examples = {@ExampleObject(
                                    value = """
                                                                             
                                            """
                            )}
                    )}),
            @ApiResponse(responseCode = "404",
                    description = "No se ha encontrado el producto por su ID",
                    content = @Content),
            @ApiResponse(responseCode = "401",
                    description = "El usuario no está loggeado",
                    content = @Content),
            @ApiResponse(responseCode = "403",
                    description = "Sesión expirada o acceso restringido",
                    content = @Content),
    })
    @PostMapping("/usuario/producto/{id}")
    public ProductDto agregarFavoritos(@AuthenticationPrincipal User user, @PathVariable Long id){
        User usuario = usuarioService.findUserFavoritos(user.getId());
        return productoService.agregarFavorito(usuario, id);
    }

    @Operation(summary = "Obtiene los productos favoritos del usuario autenticado")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200",
                    description = "Se ha obtenido el usuario y sus favoritos",
                    content = {@Content(mediaType = "application/json",
                            schema = @Schema(implementation = ProductDto.class),
                            examples = {@ExampleObject(
                                    value = """
                                            {
                                                      {
                                                          "id": 15,
                                                          "nombre": "Google Pixel 7",
                                                          "precio": 899.99,
                                                          "descripcion": "El nuevo modelo de Google",
                                                          "imagen": "movil.jpg",
                                                          "fechaPublicacion": "2022-02-23",
                                                          "categoria": "Moviles",
                                                          "usuario": "mhoggins0"
                                                      },
                                                      {
                                                          "id": 16,
                                                          "nombre": "Huawei P60",
                                                          "precio": 799.99,
                                                          "descripcion": "El nuevo modelo de Huawei",
                                                          "imagen": "movil.jpg",
                                                          "fechaPublicacion": "2022-02-23",
                                                          "categoria": "Moviles",
                                                          "usuario": "mhoggins0"
                                                      },
                                                      {
                                                          "id": 17,
                                                          "nombre": "Motorola Edge 30",
                                                          "precio": 599.99,
                                                          "descripcion": "El nuevo modelo de Motorola",
                                                          "imagen": "movil.jpg",
                                                          "fechaPublicacion": "2022-02-23",
                                                          "categoria": "Moviles",
                                                          "usuario": "mhoggins0"
                                                      },
                                              }  
                                            """
                            )}
                    )}),
            @ApiResponse(responseCode = "401",
                    description = "El usuario no está loggeado",
                    content = @Content),
            @ApiResponse(responseCode = "403",
                    description = "Sesión expirada o acceso restringido",
                    content = @Content),
    })
    @GetMapping("/usuario/favorito/")
    public PageDto<ProductDto> mostrarFavoritos(
            @PageableDefault(size = 5, page = 0) Pageable pageable,
            @AuthenticationPrincipal User user){
        User usuario = usuarioService.findUserFavoritos(user.getId());
        return productoService.paginarFavoritos(usuario, pageable);
    }

    @Operation(summary = "Elimina un favorito del en base a su ID")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "204",
                    description = "El producto ha sido eliminado correctamente",
                    content = {@Content(mediaType = "application/json",
                            schema = @Schema(implementation = ProductDto.class))}),
            @ApiResponse(responseCode = "404",
                    description = "No se encuentra un producto con este ID",
                    content = @Content),
            @ApiResponse(responseCode = "401",
                    description = "El usuario no está loggeado",
                    content = @Content),
            @ApiResponse(responseCode = "403",
                    description = "Sesión expirada o acceso restringido",
                    content = @Content),
    })
    @DeleteMapping("/usuario/favorito/{id}")
    public ResponseEntity<?> eliminarFavorito(@PathVariable Long id, @AuthenticationPrincipal User user){
        User usuario = usuarioService.findUserProducts(user.getId());
        productoService.removeFavorito(id, usuario);
        return ResponseEntity.noContent().build();
    }

}
