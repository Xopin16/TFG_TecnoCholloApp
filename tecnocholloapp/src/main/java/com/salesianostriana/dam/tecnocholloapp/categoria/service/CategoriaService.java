package com.salesianostriana.dam.tecnocholloapp.categoria.service;

import com.salesianostriana.dam.tecnocholloapp.categoria.dto.CategoryDto;
import com.salesianostriana.dam.tecnocholloapp.categoria.model.Category;
import com.salesianostriana.dam.tecnocholloapp.categoria.repository.CategoriaRepository;
import com.salesianostriana.dam.tecnocholloapp.exception.CategoryNotFoundException;
import com.salesianostriana.dam.tecnocholloapp.page.PageDto;
import com.salesianostriana.dam.tecnocholloapp.search.spec.CategorySpecificationBuilder;
import com.salesianostriana.dam.tecnocholloapp.search.util.SearchCriteria;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class CategoriaService {

    private final CategoriaRepository repository;

    public List<Category> findAll() {
        List<Category> result = repository.findAll();

        if (result.isEmpty())
            throw new CategoryNotFoundException();

        return result;
    }

    public Category findById(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new CategoryNotFoundException(id));
    }

    public Category save(CategoryDto categoryDto) {
        return repository.save(CategoryDto.of(categoryDto));
    }

    public Category edit(Long id, CategoryDto categoryDto) {
        return repository.findById(id)
                .map(categoria -> {
                    categoria.setNombre(categoryDto.getNombre());
                    return repository.save(categoria);
                }).orElseThrow(CategoryNotFoundException::new);
    }

    public void delete(Long id) {
//        if (repository.existsById(id))
        if(repository.existsById(id)){
            Category category = findById(id);
            Category otros = repository.findByNombre("Otros");
            category.getProducts().forEach(p-> p.setCategoria(otros));
            repository.deleteById(id);
        }
    }

    public PageDto<CategoryDto> search(List<SearchCriteria> params, Pageable pageable) {
        CategorySpecificationBuilder categorySpecificationBuilder =
                new CategorySpecificationBuilder(params);
        Specification<Category> spec = categorySpecificationBuilder.build();
        Page<CategoryDto> pageCategoryDto = repository.findAll(spec, pageable).map(CategoryDto::fromCateria);
        if(!pageCategoryDto.isEmpty()){
            return new PageDto<>(pageCategoryDto);
        }else {
            throw new CategoryNotFoundException();
        }
    }

//    @PreRemove
//    public void setCategoriaOtros(Category category){
//        category.getProducts().forEach(p -> p.setCategoria(repository.findByNombre("Otros")));
//    }

    public boolean categoryExists(String nombre){return repository.existsByNombre(nombre);}
}
