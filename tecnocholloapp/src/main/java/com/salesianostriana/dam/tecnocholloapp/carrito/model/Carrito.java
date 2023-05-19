package com.salesianostriana.dam.tecnocholloapp.carrito.model;

import com.salesianostriana.dam.tecnocholloapp.producto.model.Product;
import com.salesianostriana.dam.tecnocholloapp.usuario.model.User;
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
@AllArgsConstructor
@NoArgsConstructor
@Builder
//@NamedEntityGraph(name = "carrito-with-lineasDeVenta",
//        attributeNodes = @NamedAttributeNode("lineasDeVenta"))
public class Carrito {

    @Id
    @GeneratedValue
    private Long id;

    @OneToMany(cascade = CascadeType.ALL, orphanRemoval = true)
    @Builder.Default
    private List<Product> productos = new ArrayList<>();

    @ManyToOne
    private User user;

    @ManyToOne
    private Venta venta;

    public double calcularTotal() {
        double total = 0;
        for (Product producto : productos) {
            total += producto.getPrecio();
        }
        return total;
    }

    public void removeProductos(List<Product> productos){
        this.productos.removeAll(productos);
    }


}
