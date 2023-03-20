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
public class CreateProductDto {

    private Long id;

    private String nombre;

    private double precio;

    private String descripcion;

    private String categoria;

    @Builder.Default
    private LocalDate fechaPublicacion = LocalDate.now();

    public static Product of(CreateProductDto dto){
        return Product
                .builder()
                .nombre(dto.nombre)
                .precio(dto.precio)
                .descripcion(dto.descripcion)
                .fechaPublicacion(dto.getFechaPublicacion())
                .build();
    }

    public static CreateProductDto fromProducto(Product p){
        return CreateProductDto
                .builder()
                .id(p.getId())
                .nombre(p.getNombre())
                .precio(p.getPrecio())
                .descripcion(p.getDescripcion())
                .categoria(p.getCategoria().getNombre())
                .fechaPublicacion(p.getFechaPublicacion())
                .build();
    }
}