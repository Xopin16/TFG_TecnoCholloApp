package com.salesianostriana.dam.tecnocholloapp.usuario.service;

import com.salesianostriana.dam.tecnocholloapp.exception.UserNotFoundException;
import com.salesianostriana.dam.tecnocholloapp.file.StorageService;
import com.salesianostriana.dam.tecnocholloapp.page.PageDto;
import com.salesianostriana.dam.tecnocholloapp.producto.repository.ProductoRepository;
import com.salesianostriana.dam.tecnocholloapp.search.spec.UserSpecificationBuilder;
import com.salesianostriana.dam.tecnocholloapp.search.util.SearchCriteria;
import com.salesianostriana.dam.tecnocholloapp.usuario.dto.CreateUserDto;
import com.salesianostriana.dam.tecnocholloapp.usuario.dto.EditUserDto;
import com.salesianostriana.dam.tecnocholloapp.usuario.dto.UserDto;
import com.salesianostriana.dam.tecnocholloapp.usuario.model.User;
import com.salesianostriana.dam.tecnocholloapp.usuario.model.UserRole;
import com.salesianostriana.dam.tecnocholloapp.usuario.repository.UsuarioRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import javax.transaction.Transactional;
import java.time.LocalDateTime;
import java.util.EnumSet;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class UsuarioService {

    private final UsuarioRepository usuarioRepository;

    private final ProductoRepository productoRepository;
    private final PasswordEncoder passwordEncoder;

    private final StorageService storageService;

    public User createUser(CreateUserDto createUserDto, EnumSet<UserRole> roles) {
        User user =  User.builder()
                .username(createUserDto.getUsername())
                .password(passwordEncoder.encode(createUserDto.getPassword()))
                .fullName(createUserDto.getFullName())
                .roles(roles)
                .createdAt(LocalDateTime.now())
                .email(createUserDto.getEmail())
                .build();

        return usuarioRepository.save(user);
    }

    public User createUserWithUserRole(CreateUserDto createUserDto) {
        return createUser(createUserDto, EnumSet.of(UserRole.USER));
    }

    public User createUserWithAdminRole(CreateUserDto createUserDto) {
        return createUser(createUserDto, EnumSet.of(UserRole.ADMIN));
    }

    public List<User> findAll() {
        return usuarioRepository.findAll();
    }

    public List<User> findAllUsers(){
        List<User> result = usuarioRepository.findAll();

        if (result.isEmpty())
            throw new UserNotFoundException();

        return result;
    }

    public User save(User user){
        return usuarioRepository.save(user);
    }

    public Optional<User> findById(UUID id) {
        return usuarioRepository.findById(id);
    }

    public User findUserById(UUID id) {
        return usuarioRepository.findById(id)
                .orElseThrow(() -> new UserNotFoundException(id));
    }

    public Optional<User> findByUsername(String username) {
        return usuarioRepository.findFirstByUsername(username);
    }

    public User edit(UUID id, EditUserDto dto) {
        return usuarioRepository.findById(id)
                .map(u -> {
                    u.setAvatar(dto.getAvatar());
                    u.setFullName(dto.getFullName());
                    return usuarioRepository.save(u);
                }).orElseThrow(UserNotFoundException::new);
    }


    public User editPassword(UUID userId, String newPassword) {

        // Aquí no se realizan comprobaciones de seguridad. Tan solo se modifica

        return usuarioRepository.findById(userId)
                .map(u -> {
                    u.setPassword(passwordEncoder.encode(newPassword));
                    return usuarioRepository.save(u);
                }).orElseThrow(()-> new UserNotFoundException(userId));

    }

    public PageDto<UserDto> search(List<SearchCriteria> params, Pageable pageable) {
        UserSpecificationBuilder userSpecificationBuilder =
                new UserSpecificationBuilder(params);
        Specification<User> spec =  userSpecificationBuilder.build();
        Page<UserDto> pageUserDto = usuarioRepository.findAll(spec, pageable).map(UserDto::fromUser);
        if(!pageUserDto.isEmpty()){
            return new PageDto<>(pageUserDto);
        }else {
            throw new UserNotFoundException();
        }
    }

    public Optional<User> findByNombre(String username){
        return usuarioRepository.findFirstByUsername(username);
    }

    public void delete(UUID id) {
        if(usuarioRepository.existsById(id)){
            deleteById(id);
        }else{
            throw new UserNotFoundException(id);
        }

    }

    @Transactional
    public List<User> findUsersProducts(){

        List<User> result =
                usuarioRepository.usuariosConProductos();

        if (!result.isEmpty())
            productoRepository.productosConCategoria();

        return result;

    }

    @Transactional
    public User findUserProducts(UUID id){
        return usuarioRepository.usuarioConProductos(id);
    }

    @Transactional
    public User findUserFavoritos(UUID id){
        return usuarioRepository.usuarioConFavoritos(id);
    }


    public void deleteById(UUID id) {
        if (usuarioRepository.existsById(id))
            usuarioRepository.deleteById(id);
    }

    public boolean passwordMatch(User user, String clearPassword) {
        return passwordEncoder.matches(clearPassword, user.getPassword());
    }

    public boolean userExists(String username) {
        return usuarioRepository.existsByUsername(username);
    }

    public boolean emailExists(String email) {return usuarioRepository.existsByEmail(email);}

    @Transactional
    public User saveFile(User user, MultipartFile file) {
        String filename = storageService.store(file);

        user.setAvatar(filename);
        return usuarioRepository.save(user);
    }

}
