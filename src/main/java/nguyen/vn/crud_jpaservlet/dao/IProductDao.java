package nguyen.vn.crud_jpaservlet.dao;

import java.util.List;

import nguyen.vn.crud_jpaservlet.entity.Product;

public interface IProductDao {

    void insert(Product product);

    void update(Product product);

    void delete(int productId);

    Product findById(int productId);

    Product findActiveById(int productId);

    List<Product> findAll();

    List<Product> findAll(int pageIndex, int pageSize);

    List<Product> findAllActive(int pageIndex, int pageSize);

    List<Product> findTop10Newest();

    long count();

    long countActive();
}
