package com.salesianostriana.dam.tecnocholloapp.venta.controller;

import com.salesianostriana.dam.tecnocholloapp.producto.model.Product;
import com.salesianostriana.dam.tecnocholloapp.producto.service.ProductoService;
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

    private final ProductoService productoService;

    @GetMapping("/usuario/cesta/")
    public VentaDto mostrarCarrito(@AuthenticationPrincipal User user){
        User usuario = usuarioService.findUserProducts(user.getId());
        return ventaService.mostrarCarrito(usuario);
    }

    @GetMapping("/admin/historico/")
    public List<VentaDto> mostrarHistorico(@AuthenticationPrincipal User user) {
        User usuario = usuarioService.findUserProducts(user.getId());
        return ventaService.obtenerHistoricoVentas(usuario);
    }

    @GetMapping("/usuario/historico/")
    public List<VentaDto> mostrarVentasUsuario(@AuthenticationPrincipal User user) {
        User usuario = usuarioService.findUserProducts(user.getId());
        return ventaService.obtenerHistoricoUsuario(usuario);
    }

    @PostMapping("/usuario/checkout/")
    public VentaDto finalizarCompra(@AuthenticationPrincipal User user){
        User usuario = usuarioService.findUserProducts(user.getId());
        return ventaService.finalizarCompra(usuario);
    }

    @PostMapping("/usuario/cesta/producto/{idProducto}")
    public VentaDto agregarProducto(@AuthenticationPrincipal User user, @PathVariable Long idProducto) {
        Product product = productoService.findById(idProducto);
        User usuario = usuarioService.findUserProducts(user.getId());
        return ventaService.agregarProductoAlCarrito(usuario, product);
    }

    @DeleteMapping("/usuario/cesta/{id}")
    public ResponseEntity<?> borrarDelCarrito(@AuthenticationPrincipal User user, @PathVariable Long id){
        ventaService.borrarLineaVentaDelCarrito(user, id);
        return ResponseEntity.noContent().build();
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