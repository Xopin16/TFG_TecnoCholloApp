package com.salesianostriana.dam.tecnocholloapp.exception;

import javax.persistence.EntityNotFoundException;

public class CategoryNotFoundException extends EntityNotFoundException {

    public CategoryNotFoundException() {
        super("The category could not be found");
    }

    public CategoryNotFoundException(Long id) {
        super(String.format("The category with id %d could not be found", id));
    }
}