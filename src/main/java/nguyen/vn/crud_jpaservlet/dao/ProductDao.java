package nguyen.vn.crud_jpaservlet.dao;

import java.util.List;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.TypedQuery;
import nguyen.vn.crud_jpaservlet.config.JPAConfig;
import nguyen.vn.crud_jpaservlet.entity.Product;

public class ProductDao implements IProductDao {

    private static final int ACTIVE_STATUS = 1;

    private static final String SELECT_WITH_CATEGORY =
            "SELECT p FROM Product p JOIN FETCH p.category ";
    private static final String NEWEST_FIRST =
            "ORDER BY p.createdDate DESC, p.productId DESC";

    @Override
    public void insert(Product product) {
        EntityManager entityManager = JPAConfig.getEntityManager();
        EntityTransaction transaction = entityManager.getTransaction();
        try {
            transaction.begin();
            entityManager.persist(product);
            transaction.commit();
        } catch (RuntimeException exception) {
            rollbackIfActive(transaction);
            throw exception;
        } finally {
            entityManager.close();
        }
    }

    @Override
    public void update(Product product) {
        EntityManager entityManager = JPAConfig.getEntityManager();
        EntityTransaction transaction = entityManager.getTransaction();
        try {
            transaction.begin();
            entityManager.merge(product);
            transaction.commit();
        } catch (RuntimeException exception) {
            rollbackIfActive(transaction);
            throw exception;
        } finally {
            entityManager.close();
        }
    }

    @Override
    public void delete(int productId) {
        EntityManager entityManager = JPAConfig.getEntityManager();
        EntityTransaction transaction = entityManager.getTransaction();
        try {
            transaction.begin();
            Product product = entityManager.find(Product.class, productId);
            if (product == null) {
                throw new IllegalArgumentException("Không tìm thấy sản phẩm có mã " + productId);
            }
            entityManager.remove(product);
            transaction.commit();
        } catch (RuntimeException exception) {
            rollbackIfActive(transaction);
            throw exception;
        } finally {
            entityManager.close();
        }
    }

    @Override
    public Product findById(int productId) {
        EntityManager entityManager = JPAConfig.getEntityManager();
        try {
            return findOne(entityManager,
                    SELECT_WITH_CATEGORY + "WHERE p.productId = :productId",
                    productId);
        } finally {
            entityManager.close();
        }
    }

    @Override
    public Product findActiveById(int productId) {
        EntityManager entityManager = JPAConfig.getEntityManager();
        try {
            TypedQuery<Product> query = entityManager.createQuery(
                    SELECT_WITH_CATEGORY
                            + "WHERE p.productId = :productId AND p.status = :status",
                    Product.class);
            query.setParameter("productId", productId);
            query.setParameter("status", ACTIVE_STATUS);
            return query.getResultStream().findFirst().orElse(null);
        } finally {
            entityManager.close();
        }
    }

    @Override
    public List<Product> findAll() {
        EntityManager entityManager = JPAConfig.getEntityManager();
        try {
            return entityManager.createNamedQuery("Product.findAll", Product.class)
                    .getResultList();
        } finally {
            entityManager.close();
        }
    }

    @Override
    public List<Product> findAll(int pageIndex, int pageSize) {
        requireValidPage(pageIndex, pageSize);

        EntityManager entityManager = JPAConfig.getEntityManager();
        try {
            TypedQuery<Product> query = entityManager.createQuery(
                    SELECT_WITH_CATEGORY + NEWEST_FIRST, Product.class);
            query.setFirstResult((pageIndex - 1) * pageSize);
            query.setMaxResults(pageSize);
            return query.getResultList();
        } finally {
            entityManager.close();
        }
    }

    @Override
    public List<Product> findAllActive(int pageIndex, int pageSize) {
        requireValidPage(pageIndex, pageSize);

        EntityManager entityManager = JPAConfig.getEntityManager();
        try {
            TypedQuery<Product> query = entityManager.createQuery(
                    SELECT_WITH_CATEGORY + "WHERE p.status = :status " + NEWEST_FIRST,
                    Product.class);
            query.setParameter("status", ACTIVE_STATUS);
            query.setFirstResult((pageIndex - 1) * pageSize);
            query.setMaxResults(pageSize);
            return query.getResultList();
        } finally {
            entityManager.close();
        }
    }

    @Override
    public List<Product> findTop10Newest() {
        EntityManager entityManager = JPAConfig.getEntityManager();
        try {
            TypedQuery<Product> query = entityManager.createQuery(
                    SELECT_WITH_CATEGORY + NEWEST_FIRST, Product.class);
            query.setMaxResults(10);
            return query.getResultList();
        } finally {
            entityManager.close();
        }
    }

    @Override
    public long count() {
        EntityManager entityManager = JPAConfig.getEntityManager();
        try {
            return entityManager.createQuery("SELECT COUNT(p) FROM Product p", Long.class)
                    .getSingleResult();
        } finally {
            entityManager.close();
        }
    }

    @Override
    public long countActive() {
        EntityManager entityManager = JPAConfig.getEntityManager();
        try {
            TypedQuery<Long> query = entityManager.createQuery(
                    "SELECT COUNT(p) FROM Product p WHERE p.status = :status", Long.class);
            query.setParameter("status", ACTIVE_STATUS);
            return query.getSingleResult();
        } finally {
            entityManager.close();
        }
    }

    private Product findOne(EntityManager entityManager, String jpql, int productId) {
        TypedQuery<Product> query = entityManager.createQuery(jpql, Product.class);
        query.setParameter("productId", productId);
        return query.getResultStream().findFirst().orElse(null);
    }

    private void requireValidPage(int pageIndex, int pageSize) {
        if (pageIndex < 1) {
            throw new IllegalArgumentException("pageIndex phải bắt đầu từ 1");
        }
        if (pageSize < 1) {
            throw new IllegalArgumentException("pageSize phải lớn hơn 0");
        }
    }

    private void rollbackIfActive(EntityTransaction transaction) {
        if (transaction.isActive()) {
            transaction.rollback();
        }
    }
}
