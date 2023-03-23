package com.salesianostriana.dam.tecnocholloapp.search.spec;

import com.salesianostriana.dam.tecnocholloapp.search.util.SearchCriteria;
import com.salesianostriana.dam.tecnocholloapp.usuario.model.User;

import java.util.List;

public class UserSpecificationBuilder extends GenericSpecificationBuilder<User> {

    public UserSpecificationBuilder(List<SearchCriteria> params) {
        super(params, User.class);
    }
}
