package com.salesianostriana.dam.tecnocholloapp.venta.model;

import com.salesianostriana.dam.tecnocholloapp.lineaventa.model.LineaVenta;
import com.salesianostriana.dam.tecnocholloapp.usuario.model.User;
import lombok.*;

import javax.persistence.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Venta {

    @Id
    @GeneratedValue
    private long id;

    private double precioFinal;

    private LocalDate fechaVenta;

    @ManyToOne
    private User user;

    @Builder.Default
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    @OneToMany(mappedBy="venta", fetch = FetchType.EAGER)
    private List<LineaVenta> lista = new ArrayList<>();

}
