package com.salesianostriana.dam.tecnocholloapp.usuario.repository;

import com.salesianostriana.dam.tecnocholloapp.usuario.dto.UserDto;
import com.salesianostriana.dam.tecnocholloapp.usuario.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface UsuarioRepository extends JpaRepository<User, UUID>, JpaSpecificationExecutor<User> {

    boolean existsByUsername(String username);

    boolean existsByEmail(String email);
    Optional<User> findFirstByUsername(String username);

    @Query("""
            select new com.salesianostriana.dam.tecnocholloapp.usuario.dto.UserDto(u.username, u.avatar, u.fullName, u.createdAt)
            from User u
            where id = :id
            """
    )
    UserDto nuevoUserDto(UUID id);


    @Query("""
            select distinct u from User u
            left join fetch u.products
            """)
    List<User> usuariosConProductos();

    @Query("""
            select p.user.id
            from Product p
            where p.id = :id
            """)
    UUID findUserIdByProduct(Long id);


    @Query("""
            select u from User u
            left join fetch u.products
            where u.id = :id
            """)
    User usuarioConProductos(UUID id);

    @Query("""
            select distinct u from User u
            left join fetch u.favoritos
            """)
    List<User> usuariosConFavoritos();



    @Query("""
            select u from User u
            left join fetch u.favoritos
            where u.id = :id
            """)
    User usuarioConFavoritos(UUID id);

}
