package com.salesianostriana.dam.tecnocholloapp.exception;

import javax.persistence.EntityNotFoundException;

public class ProductNotFoundException extends EntityNotFoundException {

    public ProductNotFoundException() {
        super("The product could not be found");
    }

    public ProductNotFoundException(Long id) {
        super(String.format("The product with id %d could not be found", id));
    }
}
