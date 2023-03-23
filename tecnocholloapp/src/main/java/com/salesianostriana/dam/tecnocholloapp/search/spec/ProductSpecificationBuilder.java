package com.salesianostriana.dam.tecnocholloapp.search.spec;

import com.salesianostriana.dam.tecnocholloapp.producto.model.Product;
import com.salesianostriana.dam.tecnocholloapp.search.util.SearchCriteria;

import java.util.List;

public class ProductSpecificationBuilder extends GenericSpecificationBuilder<Product> {

    public ProductSpecificationBuilder(List<SearchCriteria> params) {
        super(params, Product.class);
    }
}
