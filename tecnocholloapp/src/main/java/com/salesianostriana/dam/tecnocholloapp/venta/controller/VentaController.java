package com.salesianostriana.dam.tecnocholloapp.venta.controller;

import com.salesianostriana.dam.tecnocholloapp.producto.dto.ProductDto;
import com.salesianostriana.dam.tecnocholloapp.producto.model.Product;
import com.salesianostriana.dam.tecnocholloapp.producto.service.ProductoService;
import com.salesianostriana.dam.tecnocholloapp.usuario.model.User;
import com.salesianostriana.dam.tecnocholloapp.usuario.service.UsuarioService;
import com.salesianostriana.dam.tecnocholloapp.venta.model.Venta;
import com.salesianostriana.dam.tecnocholloapp.venta.model.dto.VentaDto;
import com.salesianostriana.dam.tecnocholloapp.venta.service.VentaService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.ArraySchema;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.ExampleObject;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequiredArgsConstructor
public class VentaController {

    private final VentaService ventaService;

    private final UsuarioService usuarioService;

    private final ProductoService productoService;

    @Operation(summary = "Obtiene el carrito del usuario")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200",
                    description = "Se han encontrado productos en el carrito",
                    content = {@Content(mediaType = "application/json",
                            schema = @Schema(implementation = VentaDto.class),
                            examples = {@ExampleObject(
                                    value = """
                                                {
                                                    "id": 10013,
                                                    "precio": 799.99,
                                                    "lineasVenta": [
                                                        {
                                                            "id": 10014,
                                                            "cantidad": 1,
                                                            "producto": {
                                                                "id": 11,
                                                                "nombre": "Samsung Galaxy S21",
                                                                "precio": 799.99,
                                                                "descripcion": "El nuevo modelo de Samsung",
                                                                "imagen": "movil.jpg",
                                                                "fechaPublicacion": "2022-02-23",
                                                                "categoria": "Moviles",
                                                                "usuario": "mhoggins0",
                                                                "cantidad": 0,
                                                                "sent": true,
                                                                "inFav": false
                                                            }
                                                        }
                                                    ],
                                                    "fechaVenta": "2023-06-15",
                                                    "usuario": "mhoggins0"
                                                }                             
                                            """
                            )}
                    )}),
            @ApiResponse(responseCode = "404",
                    description = "No se han encontrado productos en el carrito",
                    content = @Content),
            @ApiResponse(responseCode = "401",
                    description = "El usuario no está loggeado",
                    content = @Content),
            @ApiResponse(responseCode = "403",
                    description = "Sesión expirada o acceso restringido",
                    content = @Content),
    })
    @GetMapping("/usuario/cesta/")
    public VentaDto mostrarCarrito(@AuthenticationPrincipal User user){
        User usuario = usuarioService.findUserProducts(user.getId());
        return ventaService.mostrarCarrito(usuario);
    }
    @Operation(summary = "Obtiene un listado de las ventas de la apliación.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200",
                    description = "Se ha encontrado el listado de ventas",
                    content = {@Content(mediaType = "application/json",
                            array = @ArraySchema(schema = @Schema(implementation = VentaDto.class)),
                            examples = {@ExampleObject(
                                    value = """                                                                                      
                                                    [
                                                        {
                                                            "id": 10002,
                                                            "precio": 799.99,
                                                            "lineasVenta": [
                                                                {
                                                                    "id": 10001,
                                                                    "cantidad": 1,
                                                                    "producto": {
                                                                        "id": 11,
                                                                        "nombre": "Samsung Galaxy S21",
                                                                        "precio": 799.99,
                                                                        "descripcion": "El nuevo modelo de Samsung",
                                                                        "imagen": "movil.jpg",
                                                                        "fechaPublicacion": "2022-02-23",
                                                                        "categoria": "Moviles",
                                                                        "usuario": "mhoggins0",
                                                                        "cantidad": 0,
                                                                        "sent": true,
                                                                        "inFav": false
                                                                    }
                                                                }
                                                            ],
                                                            "fechaVenta": "2023-06-15",
                                                            "usuario": "Jose"
                                                        },
                                                        {
                                                            "id": 10007,
                                                            "precio": 2599.9700000000003,
                                                            "lineasVenta": [
                                                                {
                                                                    "id": 10004,
                                                                    "cantidad": 1,
                                                                    "producto": {
                                                                        "id": 12,
                                                                        "nombre": "iPhone 13 Pro",
                                                                        "precio": 1099.99,
                                                                        "descripcion": "El Ãºltimo modelo de Apple",
                                                                        "imagen": "movil.jpg",
                                                                        "fechaPublicacion": "2022-02-23",
                                                                        "categoria": "Moviles",
                                                                        "usuario": "mhoggins0",
                                                                        "cantidad": 0,
                                                                        "sent": true,
                                                                        "inFav": false
                                                                    }
                                                                },
                                                            ],
                                                            "fechaVenta": "2023-06-15",
                                                            "usuario": "Jose"
                                                        },
                                                        {
                                                            "id": 10010,
                                                            "precio": 799.99,
                                                            "lineasVenta": [
                                                                {
                                                                    "id": 10009,
                                                                    "cantidad": 1,
                                                                    "producto": {
                                                                        "id": 11,
                                                                        "nombre": "Samsung Galaxy S21",
                                                                        "precio": 799.99,
                                                                        "descripcion": "El nuevo modelo de Samsung",
                                                                        "imagen": "movil.jpg",
                                                                        "fechaPublicacion": "2022-02-23",
                                                                        "categoria": "Moviles",
                                                                        "usuario": "mhoggins0",
                                                                        "cantidad": 0,
                                                                        "sent": true,
                                                                        "inFav": false
                                                                    }
                                                                }
                                                            ],
                                                            "fechaVenta": "2023-06-15",
                                                            "usuario": "Jose"
                                                        }
                                                    ]                                  
                                            """
                            )}
                    )}),
            @ApiResponse(responseCode = "404",
                    description = "No se ha encontrado el listado de ventas",
                    content = @Content),
            @ApiResponse(responseCode = "401",
                    description = "El usuario no está loggeado",
                    content = @Content),
            @ApiResponse(responseCode = "403",
                    description = "Sesión expirada o acceso restringido",
                    content = @Content),
    })
    @GetMapping("/admin/historico/")
    public List<VentaDto> mostrarHistorico(@AuthenticationPrincipal User user) {
        User usuario = usuarioService.findUserProducts(user.getId());
        return ventaService.obtenerHistoricoVentas(usuario);
    }
    @Operation(summary = "Obtiene un listado de las ventas del usuario.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200",
                    description = "Se ha encontrado el listado de ventas",
                    content = {@Content(mediaType = "application/json",
                            array = @ArraySchema(schema = @Schema(implementation = VentaDto.class)),
                            examples = {@ExampleObject(
                                    value = """                                                                                      
                                                    [
                                                        {
                                                            "id": 10002,
                                                            "precio": 799.99,
                                                            "lineasVenta": [
                                                                {
                                                                    "id": 10001,
                                                                    "cantidad": 1,
                                                                    "producto": {
                                                                        "id": 11,
                                                                        "nombre": "Samsung Galaxy S21",
                                                                        "precio": 799.99,
                                                                        "descripcion": "El nuevo modelo de Samsung",
                                                                        "imagen": "movil.jpg",
                                                                        "fechaPublicacion": "2022-02-23",
                                                                        "categoria": "Moviles",
                                                                        "usuario": "mhoggins0",
                                                                        "cantidad": 0,
                                                                        "sent": true,
                                                                        "inFav": false
                                                                    }
                                                                }
                                                            ],
                                                            "fechaVenta": "2023-06-15",
                                                            "usuario": "Jose"
                                                        },
                                                        {
                                                            "id": 10007,
                                                            "precio": 2599.9700000000003,
                                                            "lineasVenta": [
                                                                {
                                                                    "id": 10004,
                                                                    "cantidad": 1,
                                                                    "producto": {
                                                                        "id": 12,
                                                                        "nombre": "iPhone 13 Pro",
                                                                        "precio": 1099.99,
                                                                        "descripcion": "El Ãºltimo modelo de Apple",
                                                                        "imagen": "movil.jpg",
                                                                        "fechaPublicacion": "2022-02-23",
                                                                        "categoria": "Moviles",
                                                                        "usuario": "mhoggins0",
                                                                        "cantidad": 0,
                                                                        "sent": true,
                                                                        "inFav": false
                                                                    }
                                                                },
                                                            ],
                                                            "fechaVenta": "2023-06-15",
                                                            "usuario": "Jose"
                                                        },
                                                        {
                                                            "id": 10010,
                                                            "precio": 799.99,
                                                            "lineasVenta": [
                                                                {
                                                                    "id": 10009,
                                                                    "cantidad": 1,
                                                                    "producto": {
                                                                        "id": 11,
                                                                        "nombre": "Samsung Galaxy S21",
                                                                        "precio": 799.99,
                                                                        "descripcion": "El nuevo modelo de Samsung",
                                                                        "imagen": "movil.jpg",
                                                                        "fechaPublicacion": "2022-02-23",
                                                                        "categoria": "Moviles",
                                                                        "usuario": "mhoggins0",
                                                                        "cantidad": 0,
                                                                        "sent": true,
                                                                        "inFav": false
                                                                    }
                                                                }
                                                            ],
                                                            "fechaVenta": "2023-06-15",
                                                            "usuario": "Jose"
                                                        }
                                                    ]                                  
                                            """
                            )}
                    )}),
            @ApiResponse(responseCode = "404",
                    description = "No se ha encontrado el listado de ventas",
                    content = @Content),
            @ApiResponse(responseCode = "401",
                    description = "El usuario no está loggeado",
                    content = @Content),
            @ApiResponse(responseCode = "403",
                    description = "Sesión expirada o acceso restringido",
                    content = @Content),
    })
    @GetMapping("/usuario/historico/")
    public List<VentaDto> mostrarVentasUsuario(@AuthenticationPrincipal User user) {
        User usuario = usuarioService.findUserProducts(user.getId());
        return ventaService.obtenerHistoricoUsuario(usuario);
    }
    @Operation(summary = "Finaliza la compra de los productos seleccionados")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200",
                    description = "Se ha agregado correctamente",
                    content = {@Content(mediaType = "application/json",
                            schema = @Schema(implementation = VentaDto.class),
                            examples = {@ExampleObject(
                                    value = """
                                                {
                                                    "id": 10013,
                                                    "precio": 799.99,
                                                    "lineasVenta": [
                                                        {
                                                            "id": 10014,
                                                            "cantidad": 1,
                                                            "producto": {
                                                                "id": 11,
                                                                "nombre": "Samsung Galaxy S21",
                                                                "precio": 799.99,
                                                                "descripcion": "El nuevo modelo de Samsung",
                                                                "imagen": "movil.jpg",
                                                                "fechaPublicacion": "2022-02-23",
                                                                "categoria": "Moviles",
                                                                "usuario": "mhoggins0",
                                                                "cantidad": 0,
                                                                "sent": true,
                                                                "inFav": false
                                                            }
                                                        }
                                                    ],
                                                    "fechaVenta": "2023-06-15",
                                                    "usuario": "mhoggins0"
                                                }                             
                                            """
                            )}
                    )}),
            @ApiResponse(responseCode = "400",
                    description = "Error al agregar el producto",
                    content = @Content),
            @ApiResponse(responseCode = "401",
                    description = "El usuario no está loggeado",
                    content = @Content),
            @ApiResponse(responseCode = "403",
                    description = "Sesión expirada o acceso restringido",
                    content = @Content),
    })
    @PostMapping("/usuario/checkout/")
    public VentaDto finalizarCompra(@AuthenticationPrincipal User user){
        User usuario = usuarioService.findUserProducts(user.getId());
        return ventaService.finalizarCompra(usuario);
    }

    @Operation(summary = "Agrega un producto al carrito")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200",
                    description = "Compra finalizada correctamente",
                    content = {@Content(mediaType = "application/json",
                            schema = @Schema(implementation = VentaDto.class),
                            examples = {@ExampleObject(
                                    value = """
                                                {
                                                    "id": 10013,
                                                    "precio": 799.99,
                                                    "lineasVenta": [
                                                        {
                                                            "id": 10014,
                                                            "cantidad": 1,
                                                            "producto": {
                                                                "id": 11,
                                                                "nombre": "Samsung Galaxy S21",
                                                                "precio": 799.99,
                                                                "descripcion": "El nuevo modelo de Samsung",
                                                                "imagen": "movil.jpg",
                                                                "fechaPublicacion": "2022-02-23",
                                                                "categoria": "Moviles",
                                                                "usuario": "mhoggins0",
                                                                "cantidad": 0,
                                                                "sent": true,
                                                                "inFav": false
                                                            }
                                                        }
                                                    ],
                                                    "fechaVenta": "2023-06-15",
                                                    "usuario": "mhoggins0"
                                                }                             
                                            """
                            )}
                    )}),
            @ApiResponse(responseCode = "400",
                    description = "Error al finalizar la compra.",
                    content = @Content),
            @ApiResponse(responseCode = "401",
                    description = "El usuario no está loggeado",
                    content = @Content),
            @ApiResponse(responseCode = "403",
                    description = "Sesión expirada o acceso restringido",
                    content = @Content),
    })
    @PostMapping("/usuario/cesta/producto/{idProducto}")
    public VentaDto agregarProducto(@AuthenticationPrincipal User user, @PathVariable Long idProducto) {
        Product product = productoService.findById(idProducto);
        User usuario = usuarioService.findUserProducts(user.getId());
        return ventaService.agregarProductoAlCarrito(usuario, product);
    }

    @Operation(summary = "Elimina un producto del carrito")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "204",
                    description = "El producto ha sido eliminado correctamente",
                    content = @Content),
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
    @DeleteMapping("/usuario/cesta/{id}")
    public ResponseEntity<?> borrarDelCarrito(@AuthenticationPrincipal User user, @PathVariable Long id){
        ventaService.borrarLineaVentaDelCarrito(user, id);
        return ResponseEntity.noContent().build();
    }

    @Operation(summary = "Borra una venta del historico")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "204",
                    description = "La venta se ha eliminado correctamente",
                    content = @Content),
            @ApiResponse(responseCode = "404",
                    description = "No se encuentra una venta con este ID",
                    content = @Content),
            @ApiResponse(responseCode = "401",
                    description = "El usuario no está loggeado",
                    content = @Content),
            @ApiResponse(responseCode = "403",
                    description = "Sesión expirada o acceso restringido",
                    content = @Content),
    })
    @DeleteMapping("/admin/venta/{id}")
    public ResponseEntity<?> borrarVentaDelHistorico(@AuthenticationPrincipal User user, @PathVariable Long id){
        Optional<Venta> ventaOptional = ventaService.findById(id);
        if(ventaOptional.isPresent()){
            Venta venta = ventaOptional.get();
            ventaService.borrarVenta(venta);
        }
        return ResponseEntity.noContent().build();
    }

}