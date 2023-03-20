package com.salesianostriana.dam.tecnocholloapp.categoria.model;

import com.salesianostriana.dam.tecnocholloapp.producto.model.Product;
import lombok.*;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Entity
//@Table(name = "categorias")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@EntityListeners(AuditingEntityListener.class)
public class Category {

    @Id
    @GeneratedValue
    private Long id;

    private String nombre;

    @OneToMany(mappedBy = "categoria")
    @Builder.Default
    private List<Product> products = new ArrayList<>();

//    @PreRemove
//    public void setNullProductos(){
//        products.forEach(p -> p.setCategoria(null));}
}
