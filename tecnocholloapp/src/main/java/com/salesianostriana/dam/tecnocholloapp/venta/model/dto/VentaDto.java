package com.salesianostriana.dam.tecnocholloapp.venta.model.dto;

import com.salesianostriana.dam.tecnocholloapp.lineaVenta.dto.LineaVentaDto;
import com.salesianostriana.dam.tecnocholloapp.producto.dto.ProductDto;
import com.salesianostriana.dam.tecnocholloapp.venta.model.Venta;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Data
@AllArgsConstructor @NoArgsConstructor
@Builder
public class VentaDto {

    private Long id;

    private double precio;

    private List<LineaVentaDto> lineasVenta = new ArrayList<>();

    private LocalDate fechaVenta;


    public static VentaDto of(Venta venta) {

        VentaDto ventaDto = new VentaDto();
        ventaDto.setId(venta.getId());
        ventaDto.setFechaVenta(venta.getFechaVenta());
        ventaDto.setPrecio(venta.calcularPrecioFinal());

        List<LineaVentaDto> lineasVentaDto = venta.getLineasVenta().stream()
                .map(LineaVentaDto::fromLineaVenta)
                .toList();

        ventaDto.setLineasVenta(lineasVentaDto);

        return ventaDto;
    }
}
