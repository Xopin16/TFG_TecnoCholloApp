package com.salesianostriana.dam.tecnocholloapp.producto.repository;

import com.salesianostriana.dam.tecnocholloapp.producto.dto.CreateProductDto;
import com.salesianostriana.dam.tecnocholloapp.producto.model.Product;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;

import java.util.List;
import java.util.UUID;

public interface ProductoRepository extends JpaRepository<Product, Long>, JpaSpecificationExecutor<Product> {
    @Query("""
            select new com.salesianostriana.dam.tecnocholloapp.producto.dto.CreateProductDto(p.id, p.nombre, p.precio, p.descripcion, c.nombre, p.imagen)
            from Product p left join Category c
            where id = :id
            """
    )
    CreateProductDto nuevoProductoDto(Long id);

    @Query("""
            select distinct p 
            from Product p
            left join fetch p.categoria
            """)
    List<Product> productosConCategoria();

    @Query("""
            select distinct p
            from Category c join c.products p
            where c.id = :id
            """)
    Page<Product> productosDeCategoria(Long id, Pageable pageable);

    @Query("""
            select p
            from Product p
            join p.user u
            where u.id = :id
            """)
    Page<Product> productConUser(UUID id, Pageable pageable);

    @Query("""
            select u.favoritos
            from User u join u.favoritos
            where u.id = :id
            """)
    Page<Product>favoritosDeUnUsuario(UUID id, Pageable pageable);
}
