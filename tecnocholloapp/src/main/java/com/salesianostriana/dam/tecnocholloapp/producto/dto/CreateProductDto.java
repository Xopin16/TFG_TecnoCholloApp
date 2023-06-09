package com.salesianostriana.dam.tecnocholloapp.producto.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonView;
import com.salesianostriana.dam.tecnocholloapp.producto.model.Product;
import com.salesianostriana.dam.tecnocholloapp.usuario.dto.UserViews;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.constraints.Min;
import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;
import java.time.LocalDate;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CreateProductDto {

    private Long id;
    @JsonView({UserViews.Productos.class, UserViews.Favoritos.class})
    @NotEmpty(message = "{createProductDto.nombre.notempty}")
    private String nombre;

    @JsonView({UserViews.Productos.class, UserViews.Favoritos.class})
    @NotNull(message = "{createProductDto.precio.notempty}")
    @Min(value = 0, message = "{createProductDto.precio.min}")
    private double precio;
    @JsonView({UserViews.Productos.class, UserViews.Favoritos.class})
    private String descripcion;

    private String categoria;

    @JsonView({UserViews.Productos.class, UserViews.Favoritos.class})
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "dd/MM/yyyy")
    @Builder.Default
    private LocalDate fechaPublicacion = LocalDate.now();

    private String imagen;

    private int cantidad;

    public static Product of(CreateProductDto dto){
        return Product
                .builder()
                .nombre(dto.nombre)
                .precio(dto.precio)
                .descripcion(dto.descripcion)
                .imagen(dto.imagen)
                .cantidad(dto.cantidad)
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
                .imagen(p.getImagen())
                .categoria(p.getCategoria().getNombre())
                .fechaPublicacion(p.getFechaPublicacion())
                .cantidad(p.getCantidad())
                .build();
    }

}