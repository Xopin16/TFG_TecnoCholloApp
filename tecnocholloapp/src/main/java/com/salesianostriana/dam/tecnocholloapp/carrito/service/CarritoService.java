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

    public Carrito edit(Carrito carrito){
       return carritoRepository.save(carrito);
    }

    public Carrito saveAndFlush(Carrito carrito){
        return carritoRepository.saveAndFlush(carrito);
    }

    public Carrito findCartById(Long id) {
        return carritoRepository.findById(id).orElseThrow(CategoryNotFoundException::new);
    }

    public CarritoDto agregarProductoAlCarrito(User usuario, Product producto) {

        Carrito carrito = usuario.getCarrito();
        if (carrito == null) {
            carrito = new Carrito();
            usuario.setCarrito(carrito);
            carrito.setUser(usuario);
        }
        producto.setInCart(true);
        producto.setCarrito(carrito);
        carrito.getProductos().add(producto);

        carritoRepository.save(carrito);
        usuarioService.save(usuario);

        return CarritoDto.of(carrito);
    }
    @Transactional
    public Carrito getCarritoWithProducts(Long id){
        return carritoRepository.carritoConProductos(id);
    }

    public void borrarProductoDelCarrito(Long id, User user){
        Carrito carrito = getCarritoWithProducts(user.getCarrito().getId());
        Product product = productoService.findById(id);
        product.setInCart(false);
        carrito.removeProduct(product);
        carritoRepository.saveAndFlush(carrito);
    }

    public void borrarCarrito(User user){
        carritoRepository.delete(user.getCarrito());
    }

}
