package com.salesianostriana.dam.tecnocholloapp.carrito.model;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.salesianostriana.dam.tecnocholloapp.lineaventa.model.LineaVenta;
import com.salesianostriana.dam.tecnocholloapp.producto.model.Product;
import com.salesianostriana.dam.tecnocholloapp.usuario.model.User;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
@NamedEntityGraph(name = "carrito-with-lineasDeVenta",
        attributeNodes = @NamedAttributeNode("lineasDeVenta"))
public class Carrito {

    @Id
    @GeneratedValue
    private Long id;

    @OneToMany(cascade = CascadeType.ALL, orphanRemoval = true)
    @Builder.Default
    private List<LineaVenta> lineasDeVenta = new ArrayList<>();

    @OneToOne
    private User user;
}
