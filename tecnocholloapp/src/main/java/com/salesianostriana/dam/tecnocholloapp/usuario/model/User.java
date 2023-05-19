package com.salesianostriana.dam.tecnocholloapp.usuario.model;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.salesianostriana.dam.tecnocholloapp.carrito.model.Carrito;
import com.salesianostriana.dam.tecnocholloapp.categoria.model.Category;
import com.salesianostriana.dam.tecnocholloapp.producto.model.Product;
import lombok.*;
import org.hibernate.annotations.GenericGenerator;
import org.hibernate.annotations.NaturalId;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import javax.persistence.*;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Entity
@Table(name = "usuarios")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@EntityListeners(AuditingEntityListener.class)
public class User implements UserDetails {

    @Id
    @GeneratedValue(generator = "UUID")
    @GenericGenerator(
            name = "UUID",
            strategy = "org.hibernate.id.UUIDGenerator",
            parameters = {
                    @org.hibernate.annotations.Parameter(
                            name = "uuid_gen_strategy_class",
                            value = "org.hibernate.id.uuid.CustomVersionOneStrategy"
                    )
            }
    )
    @Column(columnDefinition = "uuid")
    private UUID id;

    @NaturalId
    @Column(unique = true, updatable = false)
    private String username;

    private String password;

    private String email;

    private String fullName;

    private String avatar;

    @ManyToMany(cascade = CascadeType.ALL)
    @Builder.Default
    private List<Product> favoritos = new ArrayList<>();

    @OneToMany(mappedBy = "user", orphanRemoval = true, cascade = CascadeType.ALL)
    private List<Product> products = new ArrayList<>();

    @OneToOne
    private Carrito carrito;

    @Builder.Default
    private boolean accountNonExpired = true;
    @Builder.Default
    private boolean accountNonLocked = true;
    @Builder.Default
    private boolean credentialsNonExpired = true;
    @Builder.Default
    private boolean enabled = true;

    @Convert(converter = EnumUserRoleConverter.class)
    private EnumSet<UserRole> roles;

    @CreatedDate
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "dd/MM/yyyy HH:mm:ss")
    private LocalDateTime createdAt;

    @Builder.Default
    private LocalDateTime lastPasswordChangeAt = LocalDateTime.now();


    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return roles.stream()
                .map(role -> "ROLE_" + role)
                .map(SimpleGrantedAuthority::new)
                .collect(Collectors.toList());
    }

    @Override
    public String getPassword() {
        return password;
    }

    @Override
    public String getUsername() {
        return username;
    }

    @Override
    public boolean isAccountNonExpired() {
        return accountNonExpired;
    }

    @Override
    public boolean isAccountNonLocked() {
        return accountNonLocked;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return credentialsNonExpired;
    }

    @Override
    public boolean isEnabled() {
        return enabled;
    }

    public void addProduct(Product product) {
        products.add(product);
    }

    public void deleteProduct(Product product) {
        products.remove(product);
    }

    public void addFavorito(Product product){
        if(!favoritos.contains(product)){
            favoritos.add(product);
        }
    }

    public void deleteFavorito(Product product) {
        favoritos.remove(product);
    }

    @PreRemove
    public void deleteProductos(){
        this.getProducts().clear();
        this.getFavoritos().clear();
    }
    public User(String username, String avatar, String fullName, LocalDateTime createdAt, Category category){
        this.username = username;
        this.avatar = avatar;
        this.fullName = fullName;
        this.createdAt = createdAt;
    }

}
