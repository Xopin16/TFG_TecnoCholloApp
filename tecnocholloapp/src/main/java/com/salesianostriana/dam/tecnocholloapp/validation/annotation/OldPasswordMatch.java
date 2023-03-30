package com.salesianostriana.dam.tecnocholloapp.validation.annotation;

import com.salesianostriana.dam.tecnocholloapp.validation.validator.OldPasswordMatchValidator;

import javax.validation.Constraint;
import javax.validation.Payload;
import java.lang.annotation.*;

@Target({ElementType.TYPE})
@Retention(RetentionPolicy.RUNTIME)
@Constraint(validatedBy = OldPasswordMatchValidator.class)
@Documented
public @interface OldPasswordMatch {

    String message() default "La contraseña introducida debe ser diferente a la anterior";
    Class <?> [] groups() default {};
    Class <? extends Payload> [] payload() default {};

    String oldPasswordField();
    String newPasswordField();

}

