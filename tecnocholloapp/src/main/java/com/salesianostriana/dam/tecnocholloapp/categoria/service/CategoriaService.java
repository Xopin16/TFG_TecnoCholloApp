package com.salesianostriana.dam.tecnocholloapp.categoria.service;

import com.salesianostriana.dam.tecnocholloapp.categoria.repository.CategoriaRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class CategoriaService {

    private final CategoriaRepository repository;

    public boolean categoryExists(String nombre){return repository.existsByNombre(nombre);}

}
