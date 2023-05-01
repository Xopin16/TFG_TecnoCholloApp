package com.salesianostriana.dam.tecnocholloapp.venta.model.dto;

import com.salesianostriana.dam.tecnocholloapp.lineaventa.dto.LineaVentaDto;
import com.salesianostriana.dam.tecnocholloapp.lineaventa.model.LineaVenta;
import com.salesianostriana.dam.tecnocholloapp.venta.model.Venta;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.ArrayList;
import java.util.List;

@Data
@AllArgsConstructor @NoArgsConstructor
@Builder
public class VentaDto {

    private Long id;
    private List<LineaVentaDto> lineasDeVentaDto = new ArrayList<>();

    private double precioFinal;

    private String nombreUsuario;

    public static VentaDto of(Venta venta) {

        return VentaDto.builder()
                .id(venta.getId())
                .lineasDeVentaDto(venta.getLista().stream().map(LineaVentaDto::of).toList())
                .nombreUsuario(venta.getUser().getUsername())
                .precioFinal(venta.calcularTotal())
                .build();
    }
}
