package com.salesianostriana.dam.tecnocholloapp.carrito.model.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.salesianostriana.dam.tecnocholloapp.carrito.model.Carrito;
import com.salesianostriana.dam.tecnocholloapp.producto.dto.ProductDto;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;


import lombok.Builder;

import java.util.ArrayList;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@JsonInclude(JsonInclude.Include.NON_NULL)
public class CarritoDto {

    private Long id;

    @Builder.Default
    private List<ProductDto> productos = new ArrayList<>();

    private double total;

    public static CarritoDto of(Carrito carrito){
        return CarritoDto
                .builder()
                .id(carrito.getId())
                .productos(carrito.getProductos().stream().map(ProductDto::fromProduct).toList())
                .total(carrito.calcularTotal())
                .build();
    }


}

