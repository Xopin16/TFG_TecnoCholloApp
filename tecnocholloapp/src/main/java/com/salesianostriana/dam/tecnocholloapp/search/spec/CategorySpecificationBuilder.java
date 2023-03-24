package com.salesianostriana.dam.tecnocholloapp.search.spec;

import com.salesianostriana.dam.tecnocholloapp.categoria.model.Category;
import com.salesianostriana.dam.tecnocholloapp.search.util.SearchCriteria;

import java.util.List;

public class CategorySpecificationBuilder extends GenericSpecificationBuilder<Category>{

    public CategorySpecificationBuilder(List<SearchCriteria> params) {
        super(params, Category.class);
    }
}
