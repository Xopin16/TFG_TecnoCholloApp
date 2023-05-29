package com.salesianostriana.dam.tecnocholloapp.lineaVenta.model;

import com.salesianostriana.dam.tecnocholloapp.producto.model.Product;
import com.salesianostriana.dam.tecnocholloapp.venta.model.Venta;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Entity
@Data
@NoArgsConstructor @AllArgsConstructor
@Builder
public class LineaVenta {

    @Id
    @GeneratedValue
    private Long id;

    @ManyToOne
    private Product producto;

    private int cantidad;

    @ManyToOne
    private Venta venta;

}
