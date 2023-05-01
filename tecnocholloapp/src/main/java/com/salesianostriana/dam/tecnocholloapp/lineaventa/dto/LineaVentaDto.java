package com.salesianostriana.dam.tecnocholloapp.lineaventa.dto;

import com.salesianostriana.dam.tecnocholloapp.lineaventa.model.LineaVenta;
import com.salesianostriana.dam.tecnocholloapp.producto.dto.ProductDto;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class LineaVentaDto {

    private Long id;

    private int cantidad;

    private ProductDto productDto;

    public static LineaVentaDto of(LineaVenta lv){
        return LineaVentaDto
                .builder()
                .id(lv.getId())
                .cantidad(lv.getCantidad())
                .productDto(ProductDto.fromProduct(lv.getProducto()))
                .build();
    }
}
