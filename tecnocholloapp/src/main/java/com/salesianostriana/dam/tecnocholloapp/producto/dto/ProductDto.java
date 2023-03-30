package com.salesianostriana.dam.tecnocholloapp.producto.dto;

import com.salesianostriana.dam.tecnocholloapp.producto.model.Product;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ProductDto {

    private Long id;

    private String nombre;

    private double precio;

    private String descripcion;

    private String imagen;

    private LocalDate fechaPublicacion;

    private String categoria;

    private String usuario;

    public static ProductDto fromProduct(Product p){
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