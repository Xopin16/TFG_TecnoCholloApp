package com.salesianostriana.dam.tecnocholloapp.venta.model;

import com.salesianostriana.dam.tecnocholloapp.lineaVenta.model.LineaVenta;
import com.salesianostriana.dam.tecnocholloapp.usuario.model.User;
import lombok.*;

import javax.persistence.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Venta {

    @Id
    @GeneratedValue
    private long id;

    private double precioFinal;

    private LocalDate fechaVenta;

    private boolean cart;

    @ManyToOne
    private User usuario;

    @OneToMany(cascade = CascadeType.ALL)
//    @JoinColumn(name = "venta_id")
    @Builder.Default
    private List<LineaVenta> lineasVenta = new ArrayList<>();

    public double calcularPrecioFinal() {
        double precio = 0.0;

        for (LineaVenta lineaVenta : lineasVenta) {
            double precioUnitario = lineaVenta.getProducto().getPrecio();
            int cantidad = lineaVenta.getCantidad();
            precio += precioUnitario * cantidad;
        }

        return precio;
    }

}
