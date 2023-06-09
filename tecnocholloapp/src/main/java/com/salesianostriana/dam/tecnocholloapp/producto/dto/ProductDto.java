package com.salesianostriana.dam.tecnocholloapp.producto.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.salesianostriana.dam.tecnocholloapp.producto.model.Product;
import com.salesianostriana.dam.tecnocholloapp.usuario.model.User;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@JsonInclude(JsonInclude.Include.NON_NULL)
public class ProductDto {

    private Long id;

    private String nombre;

    private double precio;

    private String descripcion;

    private String imagen;

    private LocalDate fechaPublicacion;

    private String categoria;

    private String usuario;

    private int cantidad;

    private boolean sent;

    private boolean inFav;

    public static ProductDto fromProduct(Product p, User user){
        return ProductDto
                .builder()
                .id(p.getId())
                .nombre(p.getNombre())
                .precio(p.getPrecio())
                .descripcion(p.getDescripcion())
                .imagen(p.getImagen())
                .fechaPublicacion(p.getFechaPublicacion())
                .categoria(p.getCategoria().getNombre())
                .usuario(p.getUser().getUsername())
                .cantidad(p.getCantidad())
                .sent(p.isSent())
                .inFav(user.getFavoritos().contains(p))
                .build();
    }

    public static Product of(ProductDto productDto){
        return Product
                .builder()
                .id(productDto.getId())
                .nombre(productDto.getNombre())
                .precio(productDto.getPrecio())
                .descripcion(productDto.getDescripcion())
                .imagen(productDto.getImagen())
                .fechaPublicacion(productDto.getFechaPublicacion())
                .build();
    }
}