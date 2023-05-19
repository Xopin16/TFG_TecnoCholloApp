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
        UUID userId = usuario.getId();

        List<Product> productosEnCarrito = usuario.getCarrito().getProductos()
                .stream()
                .filter(producto -> producto.getUser().getId().equals(userId))
                .toList();

        Venta venta = Venta
                .builder()
                .fechaVenta(LocalDate.now())
                .build();
        venta.setUser(usuario);

        venta.setProducts(productosEnCarrito);

        ventaRepository.save(venta);

        usuario.getCarrito().removeProductos(productosEnCarrito);

        carritoService.save(usuario.getCarrito());
        usuarioService.save(usuario);

        return venta;
    }


//    public Optional<Venta> findVentaById(Long id){
//        return ventaRepository.findById(id);
//    }
//    public VentaDto findById(Long id){
//        Optional<Venta> ventaOptional = ventaRepository.findById(id);
//        if(ventaOptional.isPresent()){
//            Venta venta = ventaOptional.get();
//            return VentaDto.of(venta);
//        }else{
//            throw new NotFoundException("No se ha encontrado la venta.");
//        }
//
//    }
//
//    public List<VentaDto> mostrarHistorico (){
//        List<VentaDto> ventaDtoList = ventaRepository.findAll().stream().map(VentaDto::of).toList();
//        return ventaDtoList;
//    }
//    public List<VentaDto> mostrarVentasUsuario(User user){
//        List<VentaDto> ventaDtoList = ventaRepository.obtenerVentas(user).stream().map(VentaDto::of).toList();
//        return ventaDtoList;
//    }
//
//    @Transactional
//    public VentaDto checkout(User user){
//
//        Carrito carrito = carritoService.getCarritoByUsername(user.getUsername());
//        double total = carrito.getLineasDeVenta().stream()
//                .mapToDouble(linea -> linea.getProducto().getPrecio() * linea.getCantidad())
//                .sum();
//
//        Venta venta = Venta
//                .builder()
//                .fechaVenta(LocalDate.now())
//                .precioFinal(total)
//                .user(user)
//                .build();
//
//        List<LineaVenta> lineasDeVenta = carrito.getLineasDeVenta();
//        for (LineaVenta lineaDeVenta : lineasDeVenta) {
//            lineaDeVenta.addToVenta(venta);
//        }
////        venta.addLineaVenta(lineasDeVenta);
//        lineasDeVenta.forEach(venta::addLineaVenta);
//
//        ventaRepository.save(venta);
//
//        return VentaDto.of(venta);
//    }
}
