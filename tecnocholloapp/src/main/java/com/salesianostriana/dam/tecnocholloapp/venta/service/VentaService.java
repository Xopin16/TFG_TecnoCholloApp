package com.salesianostriana.dam.tecnocholloapp.venta.service;

import com.salesianostriana.dam.tecnocholloapp.carrito.model.Carrito;
import com.salesianostriana.dam.tecnocholloapp.carrito.repository.CarritoRepository;
import com.salesianostriana.dam.tecnocholloapp.carrito.service.CarritoService;
import com.salesianostriana.dam.tecnocholloapp.producto.model.Product;
import com.salesianostriana.dam.tecnocholloapp.producto.repository.ProductoRepository;
import com.salesianostriana.dam.tecnocholloapp.producto.service.ProductoService;
import com.salesianostriana.dam.tecnocholloapp.usuario.model.User;
import com.salesianostriana.dam.tecnocholloapp.usuario.service.UsuarioService;
import com.salesianostriana.dam.tecnocholloapp.venta.model.Venta;
import com.salesianostriana.dam.tecnocholloapp.venta.model.dto.VentaDto;
import com.salesianostriana.dam.tecnocholloapp.venta.repository.VentaRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.webjars.NotFoundException;

import javax.transaction.Transactional;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class VentaService {

    private final VentaRepository ventaRepository;

    private final CarritoService carritoService;

    private final UsuarioService usuarioService;

    public Venta finalizarCompra(User usuario) {
        Carrito carrito = usuario.getCarrito();

        Venta venta = Venta
                .builder()
                .fechaVenta(LocalDate.now())
                .build();
        venta.setUser(usuario);
        venta.setProducts(new ArrayList<>(carrito.getProductos()));

        for (Product product : carrito.getProductos()){
            product.setVenta(venta);
            product.setSent(true);
        }

        usuario.setCarrito(null);
        ventaRepository.save(venta);

        return venta;
    }

    public Optional<Venta> findById(Long id){
        return ventaRepository.findById(id);
    }
    public List<Venta> obtenerHistoricoUsuario(User usuario){
        return ventaRepository.findVentasByUser(usuario.getId());
    }

    public List<Venta> obtenerHistoricoVentas(){
        return ventaRepository.findAll();
    }

    public void borrarVenta(Venta venta){
        ventaRepository.delete(venta);
    }
}
