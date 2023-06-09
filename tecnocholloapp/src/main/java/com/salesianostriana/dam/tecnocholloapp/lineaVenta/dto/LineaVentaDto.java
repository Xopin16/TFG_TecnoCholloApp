package com.salesianostriana.dam.tecnocholloapp.lineaVenta.dto;

import com.salesianostriana.dam.tecnocholloapp.lineaVenta.model.LineaVenta;
import com.salesianostriana.dam.tecnocholloapp.producto.dto.ProductDto;
import com.salesianostriana.dam.tecnocholloapp.producto.model.Product;
import com.salesianostriana.dam.tecnocholloapp.usuario.model.User;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor @AllArgsConstructor
@Builder
public class LineaVentaDto {

    private Long id;
    private int cantidad;
    private ProductDto producto;


    public static LineaVentaDto fromLineaVenta(LineaVenta lineaVenta, User user) {

        LineaVentaDto lineaVentaDto = new LineaVentaDto();
        lineaVentaDto.setId(lineaVenta.getId());
        lineaVentaDto.setCantidad(lineaVenta.getCantidad());

        ProductDto productoDto = ProductDto.fromProduct(lineaVenta.getProducto(), user);
        lineaVentaDto.setProducto(productoDto);

        return lineaVentaDto;
    }
}
