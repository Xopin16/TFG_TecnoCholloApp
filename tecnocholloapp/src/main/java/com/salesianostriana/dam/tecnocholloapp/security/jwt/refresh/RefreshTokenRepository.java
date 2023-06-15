package com.salesianostriana.dam.tecnocholloapp.security.jwt.refresh;

import com.salesianostriana.dam.tecnocholloapp.usuario.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;

import java.util.Optional;

public interface RefreshTokenRepository extends JpaRepository<RefreshToken, User> {

    Optional<RefreshToken> findByToken(String token);

    @Modifying
    int deleteByUser(User user);

}
