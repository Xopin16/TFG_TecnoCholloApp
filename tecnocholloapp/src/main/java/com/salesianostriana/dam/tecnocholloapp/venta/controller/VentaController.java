package com.salesianostriana.dam.tecnocholloapp.venta.controller;

import com.salesianostriana.dam.tecnocholloapp.usuario.model.User;
import com.salesianostriana.dam.tecnocholloapp.venta.model.Venta;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

@RestController
@RequiredArgsConstructor
public class VentaController {

    @GetMapping("/admin/historico")
    public String mostrarHistorico(Model model) {
        return null;
    }

    @GetMapping("/usuario/historico/")
    public String mostrarVentasUsuario(@AuthenticationPrincipal User user) {
        return null;
    }

    @GetMapping("/usuario/detalles/{id}")
    public String mostrarDetallesVenta(@PathVariable("id") Long id) {
        return null;
    }

    @GetMapping("/usuario/cesta/")
    public Venta mostrarCesta() {
        return null;
    }

    @PostMapping("/usuario/producto/cesta/{id}")
    public Venta agregarProductoACarrito(@PathVariable("id") Long id) {
        return null;
    }


    @DeleteMapping("/usuario/producto/cesta/{id}")
    public String borrarProductoDeCarrito(@PathVariable("id") Long id) {
        return null;
    }

}