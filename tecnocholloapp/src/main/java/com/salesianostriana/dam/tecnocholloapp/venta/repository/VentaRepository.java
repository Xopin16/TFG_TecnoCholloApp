package com.salesianostriana.dam.tecnocholloapp.venta.repository;

import com.salesianostriana.dam.tecnocholloapp.usuario.model.User;
import com.salesianostriana.dam.tecnocholloapp.venta.model.Venta;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;
import java.util.UUID;

public interface VentaRepository extends JpaRepository<Venta, Long> {

    @Query("select distinct u.ventas from User u join u.ventas where u.id = :id")
    public List<Venta> findVentasByUser(UUID id);
}
