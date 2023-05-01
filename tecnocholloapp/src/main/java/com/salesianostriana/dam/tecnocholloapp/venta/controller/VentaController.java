package com.salesianostriana.dam.tecnocholloapp.venta.controller;

import com.salesianostriana.dam.tecnocholloapp.carrito.model.Carrito;
import com.salesianostriana.dam.tecnocholloapp.carrito.service.CarritoService;
import com.salesianostriana.dam.tecnocholloapp.producto.model.Product;
import com.salesianostriana.dam.tecnocholloapp.usuario.model.User;
import com.salesianostriana.dam.tecnocholloapp.usuario.service.UsuarioService;
import com.salesianostriana.dam.tecnocholloapp.venta.model.Venta;
import com.salesianostriana.dam.tecnocholloapp.venta.model.dto.VentaDto;
import com.salesianostriana.dam.tecnocholloapp.venta.service.VentaService;
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

    @GetMapping("/admin/historico/")
    public List<VentaDto> mostrarHistorico() {
        return ventaService.mostrarHistorico();
    }

    @GetMapping("/usuario/historico/")
    public List<VentaDto> mostrarVentasUsuario(@AuthenticationPrincipal User user) {
        return ventaService.mostrarVentasUsuario(user);
    }

//    @GetMapping("/usuario/detalles/{id}")
//    public VentaDto mostrarDetallesVenta(@PathVariable("id") Long id) {
//        return ventaService.findById(id);
//    }

    @PostMapping("/usuario/checkout/")
    public ResponseEntity<VentaDto> finalizarCompra(@AuthenticationPrincipal User user){
        User usuario = usuarioService.findUserProducts(user.getId());
        return ResponseEntity.ok(ventaService.checkout(usuario));
    }
}