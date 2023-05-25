package com.salesianostriana.dam.tecnocholloapp.carrito.repository;

import com.salesianostriana.dam.tecnocholloapp.carrito.model.Carrito;
import com.salesianostriana.dam.tecnocholloapp.usuario.model.User;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface CarritoRepository extends JpaRepository<Carrito, Long> {

    @Query("""
            select distinct c from Carrito c
            left join fetch c.productos
            where c.id = :id
            """)
    Carrito carritoConProductos(Long id);

}
