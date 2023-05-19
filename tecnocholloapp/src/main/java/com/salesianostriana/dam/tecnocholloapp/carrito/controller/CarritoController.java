package com.salesianostriana.dam.tecnocholloapp.carrito.controller;

import com.salesianostriana.dam.tecnocholloapp.carrito.model.Carrito;
import com.salesianostriana.dam.tecnocholloapp.carrito.model.dto.CarritoDto;
import com.salesianostriana.dam.tecnocholloapp.carrito.service.CarritoService;
import com.salesianostriana.dam.tecnocholloapp.producto.model.Product;
import com.salesianostriana.dam.tecnocholloapp.producto.repository.ProductoRepository;
import com.salesianostriana.dam.tecnocholloapp.producto.service.ProductoService;
import com.salesianostriana.dam.tecnocholloapp.usuario.model.User;
import com.salesianostriana.dam.tecnocholloapp.usuario.service.UsuarioService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
public class CarritoController {

    private final CarritoService carritoService;

    private final UsuarioService usuarioService;

    private final ProductoService productoService;

    @GetMapping("/usuario/cesta/")
    public CarritoDto mostrarCarrito(@AuthenticationPrincipal User user){
        User usuario = usuarioService.findUserProducts(user.getId());
        Carrito carrito = carritoService.findCartById(user.getCarrito().getId());
        return CarritoDto.of(carrito);
    }

    @PostMapping("/usuario/cesta/producto/{idProducto}")
    public CarritoDto agregarProducto(@AuthenticationPrincipal User user, @PathVariable Long idProducto) {
        Product product = productoService.findById(idProducto);
        User usuario = usuarioService.findUserProducts(user.getId());
        return carritoService.agregarProductoAlCarrito(usuario, product);
    }

    @DeleteMapping("/usuario/cesta/{idProducto}")
    public ResponseEntity<?> borrarProducto(@AuthenticationPrincipal User user, @PathVariable Long idProducto){
        return null;
    }

    @DeleteMapping("/usuario/cesta/")
    public ResponseEntity<?> borrarCarrito(@AuthenticationPrincipal User user){
        return null;
    }




}
