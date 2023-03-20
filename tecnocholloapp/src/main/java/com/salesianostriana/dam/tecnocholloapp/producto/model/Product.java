package com.salesianostriana.dam.tecnocholloapp.producto.model;

import com.salesianostriana.dam.tecnocholloapp.categoria.model.Category;
import com.salesianostriana.dam.tecnocholloapp.usuario.model.User;
import lombok.*;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import javax.persistence.*;
import java.time.LocalDate;

@Entity
//@Table(name = "productos")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@EntityListeners(AuditingEntityListener.class)
public class Product {

    @Id
    @GeneratedValue
    private Long id;

    private String nombre;

    private double precio;

    private String descripcion;

    private String imagen;

    @Column(name = "fecha_publicacion")
    @Builder.Default
    private LocalDate fechaPublicacion = LocalDate.now();

    @ManyToOne
    @JoinColumn(name = "categoria_id", foreignKey = @ForeignKey(name ="FK_PRODUCTO_CATEGORIA"))
    private Category categoria;

    @ManyToOne
    @JoinColumn(name = "usuario_id", foreignKey = @ForeignKey(name ="FK_PRODUCTO_USUARIO"))
    private User user;

    @PreRemove
    public void deleteProduct(){
        this.user.getFavoritos().remove(this);
        this.user.getProducts().remove(this);
    }

    public void addFavorito(Product product){
        this.user.getFavoritos().add(product);
    }

    public void deleteFavorito(Product product) {
        this.user.getFavoritos().remove(product);
    }

    public Product(String nombre, double precio, String descripcion, String imagen, Category categoria) {
        this.nombre = nombre;
        this.precio = precio;
        this.descripcion = descripcion;
        this.imagen = imagen;
        this.categoria = categoria;
    }
}