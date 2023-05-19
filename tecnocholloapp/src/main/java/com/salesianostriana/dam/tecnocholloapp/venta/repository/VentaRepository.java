package com.salesianostriana.dam.tecnocholloapp.venta.repository;

import com.salesianostriana.dam.tecnocholloapp.usuario.model.User;
import com.salesianostriana.dam.tecnocholloapp.venta.model.Venta;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface VentaRepository extends JpaRepository<Venta, Long> {

//    @Query("select v from Venta v where v.user = user")
//    public List<Venta> obtenerVentas(User user);
}
