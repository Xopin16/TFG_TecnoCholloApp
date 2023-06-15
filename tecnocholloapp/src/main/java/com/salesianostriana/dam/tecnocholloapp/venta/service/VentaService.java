package com.salesianostriana.dam.tecnocholloapp.venta.service;

//import com.salesianostriana.dam.tecnocholloapp.carrito.service.CarritoService;
import com.salesianostriana.dam.tecnocholloapp.lineaVenta.model.LineaVenta;
import com.salesianostriana.dam.tecnocholloapp.producto.model.Product;
        import com.salesianostriana.dam.tecnocholloapp.usuario.model.User;
import com.salesianostriana.dam.tecnocholloapp.usuario.service.UsuarioService;
import com.salesianostriana.dam.tecnocholloapp.venta.model.Venta;
import com.salesianostriana.dam.tecnocholloapp.venta.model.dto.VentaDto;
import com.salesianostriana.dam.tecnocholloapp.venta.repository.VentaRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

        import javax.persistence.EntityNotFoundException;
import javax.transaction.Transactional;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class VentaService {

    private final VentaRepository ventaRepository;

    private final UsuarioService usuarioService;


    public VentaDto mostrarCarrito(User user){
        Optional<Venta> carritoOptional = user.getVentas().stream()
                .filter(Venta::isCart)
                .findFirst();

        if (carritoOptional.isPresent()) {
            Venta carrito = carritoOptional.get();
            return VentaDto.of(carrito, user);
        }else{
            throw new EntityNotFoundException("No hay carrito");
        }
    }

    public VentaDto finalizarCompra(User usuario) {
        List<Venta> ventas = usuario.getVentas();

        Optional<Venta> carritoOptional = ventas.stream()
                .filter(Venta::isCart)
                .findFirst();

        if (carritoOptional.isEmpty()) {
            throw new EntityNotFoundException("No hay carrito");
        }

        Venta carrito = carritoOptional.get();
        carrito.setFechaVenta(LocalDate.now());
        carrito.setCart(false);

        List<LineaVenta> lineasVenta = new ArrayList<>(carrito.getLineasVenta());
        carrito.getLineasVenta().clear();

        Venta venta = Venta.builder()
                .fechaVenta(carrito.getFechaVenta())
                .usuario(usuario)
                .lineasVenta(lineasVenta)
                .build();

        ventaRepository.save(venta);
        usuarioService.save(usuario);

        return VentaDto.of(venta, usuario);
    }


    public VentaDto agregarProductoAlCarrito(User usuario, Product producto) {
        List<Venta> ventas = usuario.getVentas();

        Optional<Venta> carritoOptional = ventas.stream()
                .filter(Venta::isCart)
                .findFirst();

        Venta carrito;
        if (carritoOptional.isPresent()) {
            carrito = carritoOptional.get();
        } else {
            carrito = Venta.builder()
                    .fechaVenta(LocalDate.now())
                    .cart(true)
                    .usuario(usuario)
                    .build();
            ventas.add(carrito);
        }

        Optional<LineaVenta> lineaVentaOptional = carrito.getLineasVenta().stream()
                .filter(linea -> linea.getProducto().equals(producto))
                .findFirst();

        if (lineaVentaOptional.isPresent()) {
            LineaVenta lineaVenta = lineaVentaOptional.get();
            int cantidadDisponible = producto.getCantidad();
            int cantidadActual = lineaVenta.getCantidad();

            if (cantidadActual < cantidadDisponible && !producto.isSent()) {
                lineaVenta.setCantidad(cantidadActual + 1);
                producto.setCantidad(cantidadDisponible - 1);
                if (cantidadActual + 1 == cantidadDisponible){
                    lineaVenta.getProducto().setSent(true);
                }
            } else {
                return VentaDto.of(carrito, usuario);
            }
        } else {
            LineaVenta lineaVenta = LineaVenta.builder()
                    .producto(producto)
                    .venta(carrito)
                    .cantidad(1)
                    .build();
            carrito.getLineasVenta().add(lineaVenta);
            if(producto.getCantidad() == 1){
                producto.setSent(true);
                producto.setCantidad(0);
            }
        }

        ventaRepository.save(carrito);
        usuarioService.save(usuario);

        return VentaDto.of(carrito, usuario);
    }

    public VentaDto borrarLineaVentaDelCarrito(User user, Long idProducto) {
        User usuario = usuarioService.findUserVentas(user.getId());
        List<Venta> ventas = usuario.getVentas();

        Optional<Venta> carritoOptional = ventas.stream()
                .filter(Venta::isCart)
                .findFirst();

        if (carritoOptional.isEmpty()) {
            throw new EntityNotFoundException("No hay carrito");
        }

        Venta carrito = carritoOptional.get();
        Optional<LineaVenta> lineaVentaOptional = carrito.getLineasVenta().stream().filter(lv -> Objects.equals(lv.getProducto().getId(), idProducto)).findFirst();
        if(lineaVentaOptional.isPresent()) {
            LineaVenta lineaVenta = lineaVentaOptional.get();
            Product producto = lineaVenta.getProducto();
            producto.setCantidad(lineaVenta.getCantidad() + producto.getCantidad());
            producto.setSent(false);
            carrito.getLineasVenta().remove(lineaVenta);
            ventaRepository.save(carrito);
            usuarioService.save(usuario);
            return VentaDto.of(carrito, usuario);
        }else{
            throw new EntityNotFoundException("No se encontró la línea de venta en el carrito");
        }

    }

    public Optional<Venta> findById(Long id){
        return ventaRepository.findById(id);
    }

    @Transactional
    public List<VentaDto> obtenerHistoricoUsuario(User usuario){
        List<Venta> historicoVentas = ventaRepository.findVentasByUser(usuario.getId()).stream().filter(v -> !v.getLineasVenta().isEmpty() && !v.isCart()).toList();
        return historicoVentas.stream().map(v-> VentaDto.of(v, usuario)).toList();
    }

    public List<VentaDto> obtenerHistoricoVentas(User usuario){
        return ventaRepository.findAll().stream().filter(venta -> !venta.getLineasVenta().isEmpty() && !venta.isCart()).map(v-> VentaDto.of(v, usuario)).toList();
    }

    public void borrarVenta(Venta venta){
        ventaRepository.delete(venta);
    }
}
