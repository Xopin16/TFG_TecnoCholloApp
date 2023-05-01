package com.salesianostriana.dam.tecnocholloapp.carrito.repository;

import com.salesianostriana.dam.tecnocholloapp.carrito.model.Carrito;
import com.salesianostriana.dam.tecnocholloapp.lineaventa.model.LineaVenta;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;
import java.util.Optional;

public interface CarritoRepository extends JpaRepository<Carrito, Long> {

    @EntityGraph(value = "carrito-with-lineasDeVenta")
    Optional<Carrito> findFirstByUserUsername(String username);

//    @EntityGraph(value = "carrito-with-lineasDeVenta", type = EntityGraph.EntityGraphType.LOAD)
//    Optional<Carrito> findFirstByiD(Long id);
    @Query("""
            select distinct c from Carrito c
            left join fetch c.lineasDeVenta
            where c.id = :id
            """)
    Optional<Carrito> carritoConLineasVenta(Long id);

}
