package com.salesianostriana.dam.tecnocholloapp.categoria.controller;

import com.salesianostriana.dam.tecnocholloapp.categoria.dto.CategoryDto;
import com.salesianostriana.dam.tecnocholloapp.categoria.model.Category;
import com.salesianostriana.dam.tecnocholloapp.categoria.service.CategoriaService;
import com.salesianostriana.dam.tecnocholloapp.page.PageDto;
import com.salesianostriana.dam.tecnocholloapp.producto.dto.ProductDto;
import com.salesianostriana.dam.tecnocholloapp.producto.service.ProductoService;
import com.salesianostriana.dam.tecnocholloapp.search.util.SearchCriteria;
import com.salesianostriana.dam.tecnocholloapp.search.util.SearchCriteriaExtractor;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.ArraySchema;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.ExampleObject;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import javax.validation.Valid;
import java.net.URI;
import java.util.List;

@RestController
@RequiredArgsConstructor
public class CategoriaController {

    private final CategoriaService categoriaService;

    private final ProductoService productoService;

    @Operation(summary = "Obtiene un listado de categorias")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200",
                    description = "Se ha encontrado un listado de categorias",
                    content = {@Content(mediaType = "application/json",
                            array = @ArraySchema(schema = @Schema(implementation = Category.class)),
                            examples = {@ExampleObject(
                                    value = """                                                                                      
                                            {
                                                "content": [
                                                    {
                                                        "id": 1,
                                                        "nombre": "Teclados"
                                                    },
                                                    {
                                                        "id": 2,
                                                        "nombre": "Ratones"
                                                    },
                                                    {
                                                        "id": 3,
                                                        "nombre": "Altavoces"
                                                    },
                                                    {
                                                        "id": 4,
                                                        "nombre": "Moviles"
                                                    },
                                                    {
                                                        "id": 5,
                                                        "nombre": "Tarjetas grÃ¡ficas"
                                                    }
                                                ],
                                                "currentPage": 0,
                                                "last": false,
                                                "first": true,
                                                "totalPages": 3,
                                                "totalElements": 11
                                            }                                   
                                            """
                            )}
                    )}),
            @ApiResponse(responseCode = "404",
                    description = "No se ha encontrado el listado de categorias",
                    content = @Content),
    })
    @GetMapping("/categoria/")
    public PageDto<CategoryDto> obtenerTodos(
            @RequestParam(value = "s", defaultValue = "") String search,
            @PageableDefault(size = 5, page = 0) Pageable pageable) {

        List<SearchCriteria> params = SearchCriteriaExtractor.extractSearchCriteriaList(search);
        return categoriaService.search(params, pageable);
    }


    @Operation(summary = "Obtiene un listado de los productos de una categoria")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200",
                    description = "Se ha encontrado un listado de productos",
                    content = {@Content(mediaType = "application/json",
                            array = @ArraySchema(schema = @Schema(implementation = ProductDto.class)),
                            examples = {@ExampleObject(
                                    value = """                                                                                      
                                            {
                                                "content": [
                                                    {
                                                        "id": 1,
                                                        "nombre": "Teclados"
                                                    },
                                                    {
                                                        "id": 2,
                                                        "nombre": "Ratones"
                                                    },
                                                    {
                                                        "id": 3,
                                                        "nombre": "Altavoces"
                                                    },
                                                    {
                                                        "id": 4,
                                                        "nombre": "Moviles"
                                                    },
                                                    {
                                                        "id": 5,
                                                        "nombre": "Tarjetas grÃ¡ficas"
                                                    }
                                                ],
                                                "currentPage": 0,
                                                "last": false,
                                                "first": true,
                                                "totalPages": 3,
                                                "totalElements": 11
                                            }                                   
                                            """
                            )}
                    )}),
            @ApiResponse(responseCode = "404",
                    description = "No se ha encontrado el listado de productos",
                    content = @Content),
    })
    @GetMapping("/categoria/producto/{id}")
    public PageDto<ProductDto> obtenerProductosCategoria(
            @PathVariable Long id,
            @PageableDefault(size = 5, page = 0) Pageable pageable
    ){
        return productoService.findProductsCategory(id, pageable);
    }


    @Operation(summary = "Obtiene una categoria en base a su ID")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200",
                    description = "Se ha encontrado la categoria",
                    content = {@Content(mediaType = "application/json",
                            schema = @Schema(implementation = Category.class),
                            examples = {@ExampleObject(
                                    value = """
                                             {
                                                 "id": 4,
                                                 "nombre": "Moviles"
                                             }                               
                                            """
                            )}
                    )}),
            @ApiResponse(responseCode = "404",
                    description = "No se ha encontrado una categoria con este ID",
                    content = @Content),
    })
    @GetMapping("/categoria/{id}")
    public CategoryDto obtenerUno(@Valid @PathVariable Long id) {
        Category category = categoriaService.findById(id);
        return CategoryDto.fromCateria(category);
    }

    //ADMIN

    @Operation(summary = "Como administrador, agrega una nueva categoria")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200",
                    description = "Se ha agregado la categoria correctamente",
                    content = {@Content(mediaType = "application/json",
                            schema = @Schema(implementation = Category.class),
                            examples = {@ExampleObject(
                                    value = """
                                              {
                                                  "id": 4,
                                                  "nombre": "Moviles"
                                              }                               
                                            """
                            )}
                    )}),
            @ApiResponse(responseCode = "400",
                    description = "Error en los datos de la categoria",
                    content = @Content),
    })
    @PostMapping("/admin/categoria/")
    public ResponseEntity<CategoryDto> nuevaCategoria(@Valid @RequestBody CategoryDto categoryDto) {
        Category created = categoriaService.save(categoryDto);

        URI createdURI = ServletUriComponentsBuilder
                .fromCurrentRequest()
                .path("/{id}")
                .buildAndExpand(created.getId()).toUri();

        CategoryDto dto = CategoryDto.fromCateria(created);
        return ResponseEntity
                .created(createdURI)
                .body(dto);
    }

    @Operation(summary = "Como administrador, edita una categoria en base a su ID")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200",
                    description = "Se ha encontrado la categoria",
                    content = {@Content(mediaType = "application/json",
                            schema = @Schema(implementation = Category.class),
                            examples = {@ExampleObject(
                                    value = """
                                                {
                                                    "id": 4,
                                                    "nombre": "Moviles"
                                                }                             
                                            """
                            )}
                    )}),
            @ApiResponse(responseCode = "404",
                    description = "No se ha encontrado una categoria con este ID",
                    content = @Content),
            @ApiResponse(responseCode = "404",
                    description = "Error en los datos de la categoria",
                    content = @Content),
    })
    @PutMapping("/admin/categoria/{id}")
    public CategoryDto editarCategoria(@Valid @RequestBody CategoryDto categoryDto, @PathVariable Long id) {
        Category category = categoriaService.edit(id, categoryDto);
        CategoryDto dto = CategoryDto.fromCateria(category);
        return dto;
    }

    @Operation(summary = "Como administrador, elimina un categoria en base a su ID")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "204",
                    description = "La categoria ha sido eliminada correctamente",
                    content = {@Content(mediaType = "application/json",
                            schema = @Schema(implementation = Category.class))}),
            @ApiResponse(responseCode = "404",
                    description = "No se encuentra una categoria con este ID",
                    content = @Content),
    })
    @DeleteMapping("/admin/categoria/{id}")
    public ResponseEntity<?> eliminarCategoria(@PathVariable Long id) {

        categoriaService.delete(id);
        return ResponseEntity.noContent().build();
    }
}
