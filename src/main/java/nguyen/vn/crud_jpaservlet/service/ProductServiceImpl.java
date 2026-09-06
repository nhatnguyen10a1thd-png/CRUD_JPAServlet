package nguyen.vn.crud_jpaservlet.service;

import java.util.List;
import java.util.Objects;

import nguyen.vn.crud_jpaservlet.dao.IProductDao;
import nguyen.vn.crud_jpaservlet.dao.ProductDao;
import nguyen.vn.crud_jpaservlet.entity.Product;

public class ProductServiceImpl implements IProductService {

    private final IProductDao productDao;

    public ProductServiceImpl() {
        this(new ProductDao());
    }

    public ProductServiceImpl(IProductDao productDao) {
        this.productDao = Objects.requireNonNull(productDao);
    }

    @Override
    public void insert(Product product) {
        productDao.insert(product);
    }

    @Override
    public void update(Product product) {
        productDao.update(product);
    }

    @Override
    public void delete(int productId) {
        productDao.delete(productId);
    }

    @Override
    public Product findById(int productId) {
        return productDao.findById(productId);
    }

    @Override
    public Product findActiveById(int productId) {
        return productDao.findActiveById(productId);
    }

    @Override
    public List<Product> findAll() {
        return productDao.findAll();
    }

    @Override
    public List<Product> findAll(int pageIndex, int pageSize) {
        return productDao.findAll(pageIndex, pageSize);
    }

    @Override
    public List<Product> findAllActive(int pageIndex, int pageSize) {
        return productDao.findAllActive(pageIndex, pageSize);
    }

    @Override
    public List<Product> findTop10Newest() {
        return productDao.findTop10Newest();
    }

    @Override
    public long count() {
        return productDao.count();
    }

    @Override
    public long countActive() {
        return productDao.countActive();
    }
}
