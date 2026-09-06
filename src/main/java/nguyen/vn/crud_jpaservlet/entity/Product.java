package nguyen.vn.crud_jpaservlet.entity;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.ForeignKey;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Index;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.NamedQuery;
import jakarta.persistence.PrePersist;
import jakarta.persistence.Table;

@Entity
@Table(name = "products", indexes = {
        @Index(name = "IX_products_categoryId", columnList = "categoryId"),
        @Index(name = "IX_products_status_createdDate", columnList = "status, createdDate, productId")
})
@NamedQuery(name = "Product.findAll",
        query = "SELECT p FROM Product p JOIN FETCH p.category "
                + "ORDER BY p.createdDate DESC, p.productId DESC")
public class Product implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "productId")
    private int productId;

    @Column(name = "productName", nullable = false, columnDefinition = "NVARCHAR(255)")
    private String productName;

    @Column(name = "price", nullable = false, precision = 18, scale = 2,
            columnDefinition = "DECIMAL(18,2)")
    private BigDecimal price;

    @Column(name = "images", columnDefinition = "NVARCHAR(255) NULL")
    private String images;

    @Column(name = "description", columnDefinition = "NVARCHAR(MAX) NULL")
    private String description;

    @Column(name = "status", nullable = false)
    private int status;

    @Column(name = "createdDate", nullable = false, updatable = false,
            columnDefinition = "DATETIME2")
    private LocalDateTime createdDate;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "categoryId", nullable = false,
            foreignKey = @ForeignKey(name = "FK_products_categories"))
    private Category category;

    public Product() {
    }

    @PrePersist
    public void initializeCreatedDate() {
        if (createdDate == null) {
            createdDate = LocalDateTime.now();
        }
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public String getImages() {
        return images;
    }

    public void setImages(String images) {
        this.images = images;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public LocalDateTime getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(LocalDateTime createdDate) {
        this.createdDate = createdDate;
    }

    public Category getCategory() {
        return category;
    }

    public void setCategory(Category category) {
        this.category = category;
    }
}
