package com.salesianostriana.dam.tecnocholloapp.validation.validator;

import com.salesianostriana.dam.tecnocholloapp.categoria.service.CategoriaService;
import com.salesianostriana.dam.tecnocholloapp.validation.annotation.UniqueCategoryName;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.StringUtils;

import javax.validation.ConstraintValidator;
import javax.validation.ConstraintValidatorContext;

public class UniqueCategoryNameValidator implements ConstraintValidator<UniqueCategoryName, String> {

    @Autowired
    private CategoriaService categoriaService;

    @Override
    public boolean isValid(String value, ConstraintValidatorContext context) {
        return StringUtils.hasText(value) && !categoriaService.categoryExists(value);
    }
}
