package com.salesianostriana.dam.tecnocholloapp.usuario.service;

import com.salesianostriana.dam.tecnocholloapp.usuario.model.User;
import com.salesianostriana.dam.tecnocholloapp.usuario.repository.UsuarioRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
@RequiredArgsConstructor
public class UsuarioService {

    private final UsuarioRepository usuarioRepository;
    public boolean userExists(String username) {
        return usuarioRepository.existsByUsername(username);
    }

    public Optional<User> findByUsername(String username) {
        return usuarioRepository.findFirstByUsername(username);
    }

    public boolean emailExists(String email) {return usuarioRepository.existsByEmail(email);}


}
