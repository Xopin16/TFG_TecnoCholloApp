package com.salesianostriana.dam.tecnocholloapp.carrito.model.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.salesianostriana.dam.tecnocholloapp.carrito.model.Carrito;
import com.salesianostriana.dam.tecnocholloapp.lineaventa.model.LineaVenta;
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

//    private String nombreUsuario;

    public static CarritoDto of(Carrito carrito) {

        List<ProductDto> productos = carrito.getLineasDeVenta().stream()
                .map(linea -> ProductDto.builder()
                        .nombre(linea.getProducto().getNombre())
                        .precio(linea.getProducto().getPrecio())
                        .build())
                .toList();

        double total = carrito.getLineasDeVenta().stream()
                .mapToDouble(linea -> linea.getCantidad() > 0 ? linea.getProducto().getPrecio() * linea.getCantidad()
                        : linea.getProducto().getPrecio() * 1)
                .sum();

        return CarritoDto.builder()
                .id(carrito.getId())
                .productos(productos)
                .total(total)
//                .nombreUsuario(carrito.getUser().getUsername())
                .build();
    }
}

