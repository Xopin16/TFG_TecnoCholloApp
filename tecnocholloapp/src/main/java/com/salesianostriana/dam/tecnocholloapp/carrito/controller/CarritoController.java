package com.salesianostriana.dam.tecnocholloapp.carrito.controller;

import com.salesianostriana.dam.tecnocholloapp.carrito.model.Carrito;
import com.salesianostriana.dam.tecnocholloapp.carrito.model.dto.CarritoDto;
import com.salesianostriana.dam.tecnocholloapp.carrito.repository.CarritoRepository;
import com.salesianostriana.dam.tecnocholloapp.carrito.service.CarritoService;
import com.salesianostriana.dam.tecnocholloapp.exception.ProductNotFoundException;
import com.salesianostriana.dam.tecnocholloapp.producto.dto.ProductDto;
import com.salesianostriana.dam.tecnocholloapp.producto.model.Product;
import com.salesianostriana.dam.tecnocholloapp.producto.service.ProductoService;
import com.salesianostriana.dam.tecnocholloapp.usuario.model.User;
import com.salesianostriana.dam.tecnocholloapp.usuario.service.UsuarioService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

@RestController
@RequiredArgsConstructor
public class CarritoController {

    private final CarritoService carritoService;

    private final UsuarioService usuarioService;

//    @PreAuthorize("authentication.principal.id == @carritoService.findCartById(#id).user.id")
    @GetMapping("/usuario/cesta/")
    public CarritoDto mostrarCarrito(@AuthenticationPrincipal User user){
        String username = user.getUsername();
        Carrito carrito = carritoService.getCarritoByUsername(username);
        return CarritoDto.of(carrito);
//        return carritoService.getCarritoWithLineaVenta(usuario.getCarrito().getId());
    }

    @PostMapping("/usuario/cesta/producto/{idProducto}")
    public CarritoDto agregarProducto(@AuthenticationPrincipal User user, @PathVariable Long idProducto) {
        return carritoService.agregarProducto(user, idProducto);
    }

//    @DeleteMapping("/usuario/cesta/{id}/producto/{idProducto}")
//    public ResponseEntity<?> borrarProductoDeCarrito(@PathVariable("id") Long id, @PathVariable Long idProducto) {
//        if(carritoService.findCartById(id).isPresent()){
//            carritoService.borrarProducto(id, idProducto);
//        }
//        return ResponseEntity.noContent().build();
//    }


}
