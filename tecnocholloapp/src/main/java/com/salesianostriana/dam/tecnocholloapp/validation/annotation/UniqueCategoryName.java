package com.salesianostriana.dam.tecnocholloapp.validation.annotation;

import com.salesianostriana.dam.tecnocholloapp.validation.validator.UniqueCategoryNameValidator;

import javax.validation.Constraint;
import javax.validation.Payload;
import java.lang.annotation.*;

@Target({ElementType.METHOD, ElementType.FIELD})
@Retention(RetentionPolicy.RUNTIME)
@Constraint(validatedBy = UniqueCategoryNameValidator.class)
@Documented
public @interface UniqueCategoryName {

    String message() default "El nombre de la categoría ya existe";

    Class<?>[] groups() default {};

    Class<? extends Payload>[] payload() default {};
}
