package com.salesianostriana.dam.tecnocholloapp.venta.model;

import com.salesianostriana.dam.tecnocholloapp.carrito.model.Carrito;
import com.salesianostriana.dam.tecnocholloapp.producto.model.Product;
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

    @ManyToOne
    private User user;

    @OneToMany(mappedBy = "venta", cascade = CascadeType.ALL)
    private List<Product> products = new ArrayList<>();

//    @Builder.Default
//    @ToString.Exclude
//    @EqualsAndHashCode.Exclude
//    @OneToMany(mappedBy="venta", fetch = FetchType.EAGER)
//    private List<LineaVenta> lista = new ArrayList<>();


//    public Double calcularTotal(){
//        return lista.stream()
//                .mapToDouble(linea -> linea.getProducto().getPrecio() * linea.getCantidad())
//                .sum();
//    }
//
//    public void addLineaVenta(LineaVenta lineaVenta) {
//        lineaVenta.setVenta(this);
//        lista.add(lineaVenta);
//    }
}
