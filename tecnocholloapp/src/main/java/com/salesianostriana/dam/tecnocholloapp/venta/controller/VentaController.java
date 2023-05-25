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

    @PostMapping("/usuario/checkout/")
    public VentaDto finalizarCompra(@AuthenticationPrincipal User user){
        User usuario = usuarioService.findUserProducts(user.getId());
        Venta venta = ventaService.finalizarCompra(usuario);
        return VentaDto.of(venta);
    }

    @GetMapping("/admin/historico/")
    public List<VentaDto> mostrarHistorico(@AuthenticationPrincipal User user) {
        return ventaService.obtenerHistoricoVentas().stream().map(VentaDto::of).toList();
    }

    @GetMapping("/usuario/historico/")
    public List<VentaDto> mostrarVentasUsuario(@AuthenticationPrincipal User user) {
        return ventaService.obtenerHistoricoUsuario(user).stream().map(VentaDto::of).toList();
    }

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