package com.salesianostriana.dam.tecnocholloapp.lineaventa.model;

import com.salesianostriana.dam.tecnocholloapp.carrito.model.Carrito;
import com.salesianostriana.dam.tecnocholloapp.producto.model.Product;
import com.salesianostriana.dam.tecnocholloapp.venta.model.Venta;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.ManyToOne;

@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class LineaVenta {

    @Id
    @GeneratedValue
    private long id;

    @ManyToOne
    private Product producto;

    private int cantidad;

    @ManyToOne
    private Venta venta;

    public void addToVenta(Venta venta) {
        this.venta = venta;
        venta.getLista().add(this);
    }

    public void removeFromVenta(Venta venta) {
        venta.getLista().remove(this);
        this.venta = null;
    }

}