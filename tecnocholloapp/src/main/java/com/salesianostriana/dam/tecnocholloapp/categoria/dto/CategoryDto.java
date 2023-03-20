package com.salesianostriana.dam.tecnocholloapp.categoria.dto;

import com.salesianostriana.dam.tecnocholloapp.categoria.model.Category;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.constraints.NotEmpty;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CategoryDto {

    private Long id;
    private String nombre;

    public static Category of(CategoryDto categoryDto){
        return Category
                .builder()
                .nombre(categoryDto.nombre)
                .build();
    }

    public static CategoryDto fromCateria(Category category){
        return CategoryDto
                .builder()
                .id(category.getId())
                .nombre(category.getNombre())
                .build();
    }
}