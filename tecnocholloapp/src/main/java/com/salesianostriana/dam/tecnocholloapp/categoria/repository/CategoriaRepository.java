package com.salesianostriana.dam.tecnocholloapp.categoria.repository;

import com.salesianostriana.dam.tecnocholloapp.categoria.dto.CategoryDto;
import com.salesianostriana.dam.tecnocholloapp.categoria.model.Category;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;

public interface CategoriaRepository extends JpaRepository<Category, Long>, JpaSpecificationExecutor<Category> {

    @Query("""
            select new com.salesianostriana.dam.tecnocholloapp.categoria.dto.CategoryDto(c.id, c.nombre)
            from Category c
            where id = :id
            """
    )
    CategoryDto nuevaCategoriaDto(Long id);

    Category findByNombre(String nombre);
    boolean existsByNombre(String nombre);

}
