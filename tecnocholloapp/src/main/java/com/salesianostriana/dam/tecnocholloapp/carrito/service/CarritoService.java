package com.salesianostriana.dam.tecnocholloapp.carrito.service;

import com.salesianostriana.dam.tecnocholloapp.carrito.model.Carrito;
import com.salesianostriana.dam.tecnocholloapp.carrito.model.dto.CarritoDto;
import com.salesianostriana.dam.tecnocholloapp.carrito.repository.CarritoRepository;
import com.salesianostriana.dam.tecnocholloapp.exception.CategoryNotFoundException;
import com.salesianostriana.dam.tecnocholloapp.exception.ProductNotFoundException;
import com.salesianostriana.dam.tecnocholloapp.producto.model.Product;
import com.salesianostriana.dam.tecnocholloapp.producto.repository.ProductoRepository;
import com.salesianostriana.dam.tecnocholloapp.producto.service.ProductoService;
import com.salesianostriana.dam.tecnocholloapp.usuario.model.User;
import com.salesianostriana.dam.tecnocholloapp.usuario.repository.UsuarioRepository;
import com.salesianostriana.dam.tecnocholloapp.usuario.service.UsuarioService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.webjars.NotFoundException;

import javax.transaction.Transactional;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class CarritoService {

    private final CarritoRepository carritoRepository;
    private final ProductoService productoService;

    private final UsuarioService usuarioService;

    public CarritoDto save(Carrito carrito){
        Carrito carritoSaved = carritoRepository.save(carrito);
        return CarritoDto.of(carritoSaved);
    }

    public Carrito findCartById(Long id) {
        return carritoRepository.findById(id).orElseThrow(CategoryNotFoundException::new);
    }

    public CarritoDto agregarProductoAlCarrito(User usuario, Product producto) {

        Carrito carrito = usuario.getCarrito();
        if (carrito == null) {
            carrito = new Carrito();
            carrito.setUser(usuario);
            usuario.setCarrito(carrito);
        }

        producto.setUser(usuario);

        carrito.getProductos().add(producto);

        carritoRepository.save(carrito);
        usuarioService.save(usuario);

        return CarritoDto.of(carrito);
    }

//    public Carrito findCartById(Long id) {
//        return carritoRepository.findById(id).orElseThrow(CategoryNotFoundException::new);
//    }
//
//    public Carrito getCarritoByUsername(String username) {
//        Optional<Carrito> carritoOptional = carritoRepository.findFirstByUserUsername(username);
//        if (carritoOptional.isPresent()) {
//            return carritoOptional.get();
//        } else {
//            throw new CategoryNotFoundException();
//        }
//    }
//
//    public CarritoDto findById(Long id) {
//        Optional<Carrito> cart = carritoRepository.findById(id);
//        if (cart.isPresent()) {
//            Carrito carrito = cart.get();
//            return CarritoDto.of(carrito);
//        } else {
//            throw new ProductNotFoundException();
//        }
//    }
//
//    public CarritoDto agregarProducto(User user, Long idProducto) {
//        Product product = productoService.findById(idProducto);
//        LineaVenta lineaVenta = LineaVenta.builder()
//                .producto(product)
//                .build();
//        Carrito carrito;
//        if (user.getCarrito() == null) {
//            carrito = Carrito.builder().build();
//            carrito.getLineasDeVenta().add(lineaVenta);
////            lineaVenta.setCarrito(carrito);
//            user.setCarrito(carrito);
//        } else {
//            carrito = getCarritoByUsername(user.getUsername());
//            carrito.getLineasDeVenta().add(lineaVenta);
//        }
//        carrito.setUser(user);
//        carritoRepository.save(carrito);
//        usuarioService.save(user);
//        return CarritoDto.of(carrito);
//
//    }
//
//    @Transactional
//    public CarritoDto getCarritoWithLineaVenta(Long id) {
//        Optional<Carrito> carritoOptional = carritoRepository.carritoConLineasVenta(id);
//        if (carritoOptional.isPresent()) {
//            return CarritoDto.of(carritoOptional.get());
//        } else {
//            throw new CategoryNotFoundException();
//        }
//    }
//
////    public void borrarProducto(Long idCarrito, Long idProducto){
////        Optional<Carrito> cart = carritoRepository.findById(idCarrito);
////        Product product = productoService.findById(idProducto);
////        if(cart.isPresent()){
////            Carrito carrito = cart.get();
////            Optional<LineaVenta> lineaVentaOptional = carrito.getLineasDeVenta().stream()
////                    .filter(linea -> linea.getProducto().getId().equals(idProducto))
////                    .findFirst();
////            if(lineaVentaOptional.isPresent()){
////                LineaVenta lineaVenta = lineaVentaOptional.get();
////                carrito.getLineasDeVenta().remove(lineaVenta);
////                carritoRepository.save(carrito);
////            }
////        }else{
////            throw new NotFoundException("No hay productos en el carrito");
////        }
////    }

}
