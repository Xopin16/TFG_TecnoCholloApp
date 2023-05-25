package com.salesianostriana.dam.tecnocholloapp.venta.model.dto;

import com.salesianostriana.dam.tecnocholloapp.producto.dto.ProductDto;
import com.salesianostriana.dam.tecnocholloapp.venta.model.Venta;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Data
@AllArgsConstructor @NoArgsConstructor
@Builder
public class VentaDto {

    private Long id;

    private double precio;

    private List<ProductDto> products = new ArrayList<>();

    private LocalDate fechaVenta;

    private String nombreUsuario;

    public static VentaDto of(Venta venta){
        return VentaDto
                .builder()
                .id(venta.getId())
                .precio(venta.calcularTotal())
                .products(venta.getProducts().stream().map(ProductDto::fromProduct).toList())
                .fechaVenta(venta.getFechaVenta())
                .nombreUsuario(venta.getUser().getUsername())
                .build();
    }
}
