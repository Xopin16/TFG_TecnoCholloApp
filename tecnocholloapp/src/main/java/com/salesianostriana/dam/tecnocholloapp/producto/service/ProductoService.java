package com.salesianostriana.dam.tecnocholloapp.producto.service;

import com.salesianostriana.dam.tecnocholloapp.categoria.service.CategoriaService;
import com.salesianostriana.dam.tecnocholloapp.exception.ProductNotFoundException;
import com.salesianostriana.dam.tecnocholloapp.file.StorageService;
import com.salesianostriana.dam.tecnocholloapp.page.PageDto;
import com.salesianostriana.dam.tecnocholloapp.producto.dto.CreateProductDto;
import com.salesianostriana.dam.tecnocholloapp.producto.dto.ProductDto;
import com.salesianostriana.dam.tecnocholloapp.producto.model.Product;
import com.salesianostriana.dam.tecnocholloapp.producto.repository.ProductoRepository;
import com.salesianostriana.dam.tecnocholloapp.search.spec.ProductSpecificationBuilder;
import com.salesianostriana.dam.tecnocholloapp.search.util.SearchCriteria;
import com.salesianostriana.dam.tecnocholloapp.usuario.model.User;
import com.salesianostriana.dam.tecnocholloapp.usuario.service.UsuarioService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import javax.transaction.Transactional;
import java.util.List;
import java.util.UUID;

@RestController
@RequiredArgsConstructor
public class ProductoService {

    private final ProductoRepository productoRepository;

    private final UsuarioService usuarioService;

    private final CategoriaService categoriaService;

    private final StorageService storageService;

    public Product edit(Product product){
       return productoRepository.save(product);
    }

    public List<Product> findAll() {
        List<Product> result = productoRepository.findAll();

        if (result.isEmpty())
            throw new ProductNotFoundException();

        return result;
    }


    public Product findById(Long id) {
        return productoRepository.findById(id)
                .orElseThrow(() -> new ProductNotFoundException(id));
    }

    public Product save(UUID id, CreateProductDto productDto, Long idCategoria) {
        User user = usuarioService.findUserById(id);
        Product product = CreateProductDto.of(productDto);
        product.setCategoria(categoriaService.findById(idCategoria));
        product.setUser(user);
//        product.setFechaPublicacion(productDto.getFechaPublicacion());
        user.addProduct(product);
        return productoRepository.save(product);
    }

    public Product add(CreateProductDto createProductDto) {
        return productoRepository.save(CreateProductDto.of(createProductDto));
    }

    public PageDto<ProductDto> search(List<SearchCriteria> params, Pageable pageable) {
        ProductSpecificationBuilder productSpecificationBuilder =
                new ProductSpecificationBuilder(params);
        Specification<Product> spec = productSpecificationBuilder.build();
        Page<ProductDto> pageProductDto = productoRepository.findAll(spec, pageable).map(ProductDto::fromProduct);
        if (!pageProductDto.isEmpty()) {
            return new PageDto<>(pageProductDto);
        } else {
            throw new ProductNotFoundException();
        }
    }

    public Product editProduct(Long id, CreateProductDto productDto) {
        return productoRepository.findById(id)
                .map(producto -> {
                    producto.setNombre(productDto.getNombre());
                    producto.setPrecio(productDto.getPrecio());
                    producto.setDescripcion(productDto.getDescripcion());
                    return productoRepository.save(producto);
                }).orElseThrow(ProductNotFoundException::new);
    }

    public Product editMiProduct(Long id, CreateProductDto productDto, User user) {
        Product product = findById(id);
        product.setNombre(productDto.getNombre());
        product.setPrecio(productDto.getPrecio());
        product.setDescripcion(productDto.getDescripcion());
        return productoRepository.save(product);
    }


    public Page<Product> findAll(Pageable pageable) {
        return productoRepository.findAll(pageable);
    }

    public void delete(Long id) {
        if (productoRepository.existsById(id))
            productoRepository.deleteById(id);

    }

    public void deleteMiProducto(Long id, User user) {
        Product product = findById(id);
        if (productoRepository.existsById(id) && user.getProducts().contains(product)) {
            productoRepository.deleteById(id);
        } else {
            throw new ProductNotFoundException(id);
        }
    }

    public PageDto<ProductDto> paginarProductos(User user, Pageable pageable) {
        List<ProductDto> productos = user.getProducts().stream().map(ProductDto::fromProduct).toList();
        if (!productos.isEmpty()) {
            Page<ProductDto> pageProduct = new PageImpl<>(productos, pageable, productos.size());
            return new PageDto<>(pageProduct);
        } else {
            throw new ProductNotFoundException();
        }
    }

    public ProductDto agregarFavorito(User user, Long idProducto){
        Product product = findById(idProducto);
//        product.setInFav(true);
        user.addFavorito(product);
        productoRepository.save(product);
        usuarioService.save(user);
        return ProductDto.fromProduct(product);
    }

    public void removeFavorito(Long id, User user) {
        Product product = findById(id);
//        product.setInFav(false);
        user.deleteFavorito(product);
        productoRepository.save(product);
        usuarioService.save(user);
//        if (productoRepository.existsById(id)) {
//            user.deleteFavorito(product);
//        } else {
//            throw new ProductNotFoundException(id);
//        }
    }
    public PageDto<ProductDto> paginarFavoritos(User user, Pageable pageable) {
//        List<ProductDto> favoritos = user.getFavoritos().stream().map(ProductDto::fromProduct).toList();
        Page<ProductDto> pageFavoritos = productoRepository.favoritosDeUnUsuario(user.getId(), pageable).map(ProductDto::fromProduct);
        return new PageDto<>(pageFavoritos);
    }

    public PageDto<ProductDto> paginarChollos(User user, Pageable pageable) {
        Page<ProductDto> pageFavoritos = productoRepository.productConUser(user.getId(), pageable).map(ProductDto::fromProduct);
        return new PageDto<>(pageFavoritos);
    }

    @Transactional
    public Product saveFile(Long id, MultipartFile file) {
        String filename = storageService.store(file);

        Product product = findById(id);
        product.setImagen(filename);
        return productoRepository.save(product);
    }

    @Transactional
    public PageDto<ProductDto> findProductsCategory(Long id, Pageable pageable) {
        Page<ProductDto> pageProductsCategory = productoRepository.productosDeCategoria(id, pageable).map(ProductDto::fromProduct);
        return new PageDto<>(pageProductsCategory);
    }


}