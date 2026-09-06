package nguyen.vn.crud_jpaservlet.controller;

import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.net.URI;
import java.net.URISyntaxException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Set;
import java.util.UUID;

import javax.imageio.ImageIO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import nguyen.vn.crud_jpaservlet.config.Constants;
import nguyen.vn.crud_jpaservlet.entity.Category;
import nguyen.vn.crud_jpaservlet.entity.Product;
import nguyen.vn.crud_jpaservlet.service.CategoryServiceImpl;
import nguyen.vn.crud_jpaservlet.service.ICategoryService;
import nguyen.vn.crud_jpaservlet.service.IProductService;
import nguyen.vn.crud_jpaservlet.service.ProductServiceImpl;

@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 5L * 1024 * 1024,
        maxRequestSize = 6L * 1024 * 1024
)
@WebServlet(urlPatterns = {
        "/admin/products",
        "/admin/product/add",
        "/admin/product/insert",
        "/admin/product/edit",
        "/admin/product/update",
        "/admin/product/delete"
})
public class ProductController extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final Set<String> ALLOWED_EXTENSIONS = Set.of("jpg", "jpeg", "png", "gif");
    private static final Set<String> ALLOWED_CONTENT_TYPES = Set.of(
            "image/jpeg", "image/png", "image/gif"
    );

    private final IProductService productService = new ProductServiceImpl();
    private final ICategoryService categoryService = new CategoryServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        prepareEncoding(req, resp);

        switch (req.getServletPath()) {
            case "/admin/products" -> showProductList(req, resp);
            case "/admin/product/add" -> showAddForm(req, resp);
            case "/admin/product/edit" -> showEditForm(req, resp);
            default -> resp.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        prepareEncoding(req, resp);

        switch (req.getServletPath()) {
            case "/admin/product/insert" -> saveProduct(req, resp, false);
            case "/admin/product/update" -> saveProduct(req, resp, true);
            case "/admin/product/delete" -> deleteProduct(req, resp);
            default -> resp.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
        }
    }

    private void showProductList(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        moveFlashMessage(req, "flashSuccess");
        moveFlashMessage(req, "flashError");
        req.setAttribute("listProduct", productService.findAll());
        req.getRequestDispatcher("/views/admin/product-list.jsp").forward(req, resp);
    }

    private void showAddForm(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Product product = new Product();
        product.setStatus(1);
        req.setAttribute("formProduct", product);
        loadCategories(req);
        req.getRequestDispatcher("/views/admin/product-add.jsp").forward(req, resp);
    }

    private void showEditForm(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Integer id = parsePositiveInt(req.getParameter("id"));
        if (id == null) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Tham số id phải là số nguyên dương.");
            return;
        }

        Product product = productService.findById(id);
        if (product == null) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy sản phẩm.");
            return;
        }

        req.setAttribute("product", product);
        req.setAttribute("formProduct", product);
        loadCategories(req);
        req.getRequestDispatcher("/views/admin/product-edit.jsp").forward(req, resp);
    }

    private void saveProduct(HttpServletRequest req, HttpServletResponse resp, boolean updating)
            throws ServletException, IOException {
        Product product;
        String oldImage = null;

        if (updating) {
            Integer id = parsePositiveInt(req.getParameter("productId"));
            if (id == null) {
                resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Mã sản phẩm không hợp lệ.");
                return;
            }
            product = productService.findById(id);
            if (product == null) {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy sản phẩm.");
                return;
            }
            oldImage = product.getImages();
        } else {
            product = new Product();
        }

        List<String> errors = new ArrayList<>();
        String productName = trimToNull(req.getParameter("productName"));
        String priceValue = trimToNull(req.getParameter("price"));
        String description = trimToNull(req.getParameter("description"));
        String imageUrl = trimToNull(req.getParameter("images"));

        BigDecimal price = parsePrice(priceValue, errors);
        Integer status = parseStatus(req.getParameter("status"), errors);
        Integer categoryId = parsePositiveInt(req.getParameter("categoryId"));
        Category category = null;

        if (productName == null) {
            errors.add("Tên sản phẩm không được để trống.");
        } else if (productName.length() > 255) {
            errors.add("Tên sản phẩm không được vượt quá 255 ký tự.");
        }

        if (categoryId == null) {
            errors.add("Vui lòng chọn danh mục hợp lệ.");
        } else {
            category = categoryService.findById(categoryId);
            if (category == null) {
                errors.add("Danh mục đã chọn không tồn tại.");
            }
        }

        Part imagePart = null;
        try {
            imagePart = req.getPart("images1");
        } catch (IllegalStateException ex) {
            errors.add("Ảnh tải lên vượt quá dung lượng cho phép 5 MB.");
        }

        boolean hasUpload = imagePart != null && imagePart.getSize() > 0;
        if (!hasUpload && imageUrl != null) {
            if (imageUrl.length() > 255) {
                errors.add("URL ảnh không được vượt quá 255 ký tự.");
            } else if (!isValidHttpUrl(imageUrl)) {
                errors.add("URL ảnh phải bắt đầu bằng http:// hoặc https:// và có địa chỉ hợp lệ.");
            }
        }

        if (productName != null) {
            product.setProductName(productName);
        }
        if (price != null) {
            product.setPrice(price);
        }
        product.setDescription(description);
        if (status != null) {
            product.setStatus(status);
        }
        if (category != null) {
            product.setCategory(category);
        }
        if (!hasUpload && imageUrl != null) {
            product.setImages(imageUrl);
        }

        req.setAttribute("submittedPrice", priceValue);
        req.setAttribute("submittedImageUrl", imageUrl);

        if (!errors.isEmpty()) {
            renderFormWithErrors(req, resp, product, errors, updating);
            return;
        }

        String uploadedFileName = null;
        try {
            if (hasUpload) {
                uploadedFileName = storeUploadedImage(imagePart);
                product.setImages(uploadedFileName);
            } else if (imageUrl == null && updating) {
                product.setImages(oldImage);
            } else if (imageUrl == null) {
                product.setImages(null);
            }

            if (updating) {
                productService.update(product);
            } else {
                productService.insert(product);
            }
        } catch (IllegalArgumentException ex) {
            deleteLocalImageQuietly(uploadedFileName);
            errors.add(ex.getMessage());
            renderFormWithErrors(req, resp, product, errors, updating);
            return;
        } catch (RuntimeException ex) {
            deleteLocalImageQuietly(uploadedFileName);
            errors.add("Không thể lưu sản phẩm. Vui lòng thử lại.");
            renderFormWithErrors(req, resp, product, errors, updating);
            return;
        }

        if (updating && oldImage != null && !oldImage.equals(product.getImages())) {
            deleteLocalImageQuietly(oldImage);
        }

        HttpSession session = req.getSession();
        session.setAttribute("flashSuccess", updating
                ? "Cập nhật sản phẩm thành công."
                : "Thêm sản phẩm thành công.");
        resp.sendRedirect(req.getContextPath() + "/admin/products");
    }

    private void deleteProduct(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Integer id = parsePositiveInt(req.getParameter("id"));
        if (id == null) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Mã sản phẩm không hợp lệ.");
            return;
        }

        Product product = productService.findById(id);
        if (product == null) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy sản phẩm.");
            return;
        }

        HttpSession session = req.getSession();
        try {
            productService.delete(id);
            deleteLocalImageQuietly(product.getImages());
            session.setAttribute("flashSuccess", "Xóa sản phẩm thành công.");
        } catch (RuntimeException ex) {
            session.setAttribute("flashError", "Không thể xóa sản phẩm. Vui lòng thử lại.");
        }
        resp.sendRedirect(req.getContextPath() + "/admin/products");
    }

    private void renderFormWithErrors(HttpServletRequest req, HttpServletResponse resp, Product product,
                                      List<String> errors, boolean updating)
            throws ServletException, IOException {
        req.setAttribute("errors", errors);
        req.setAttribute("error", String.join(" ", errors));
        req.setAttribute("formProduct", product);
        req.setAttribute("product", product);
        loadCategories(req);
        req.getRequestDispatcher(updating
                ? "/views/admin/product-edit.jsp"
                : "/views/admin/product-add.jsp").forward(req, resp);
    }

    private void loadCategories(HttpServletRequest req) {
        req.setAttribute("categories", categoryService.findAll());
    }

    private BigDecimal parsePrice(String value, List<String> errors) {
        if (value == null) {
            errors.add("Giá sản phẩm không được để trống.");
            return null;
        }
        try {
            BigDecimal price = new BigDecimal(value);
            if (price.signum() < 0) {
                errors.add("Giá sản phẩm phải lớn hơn hoặc bằng 0.");
                return null;
            }
            if (price.scale() > 2) {
                errors.add("Giá sản phẩm chỉ được có tối đa 2 chữ số thập phân.");
                return null;
            }
            if (price.precision() - Math.max(price.scale(), 0) > 16) {
                errors.add("Giá sản phẩm vượt quá giới hạn cho phép.");
                return null;
            }
            return price;
        } catch (NumberFormatException ex) {
            errors.add("Giá sản phẩm không hợp lệ.");
            return null;
        }
    }

    private Integer parseStatus(String value, List<String> errors) {
        try {
            int status = Integer.parseInt(value);
            if (status == 0 || status == 1) {
                return status;
            }
        } catch (NumberFormatException | NullPointerException ignored) {
            // Validation message is added below.
        }
        errors.add("Trạng thái sản phẩm không hợp lệ.");
        return null;
    }

    private Integer parsePositiveInt(String value) {
        if (value == null || value.isBlank()) {
            return null;
        }
        try {
            int parsed = Integer.parseInt(value);
            return parsed > 0 ? parsed : null;
        } catch (NumberFormatException ex) {
            return null;
        }
    }

    private String storeUploadedImage(Part part) throws IOException {
        String submittedName = Paths.get(part.getSubmittedFileName()).getFileName().toString();
        int dotIndex = submittedName.lastIndexOf('.');
        if (dotIndex < 0 || dotIndex == submittedName.length() - 1) {
            throw new IllegalArgumentException("Tệp ảnh phải có phần mở rộng hợp lệ.");
        }

        String extension = submittedName.substring(dotIndex + 1).toLowerCase(Locale.ROOT);
        String contentType = part.getContentType() == null
                ? ""
                : part.getContentType().toLowerCase(Locale.ROOT);
        if (!ALLOWED_EXTENSIONS.contains(extension) || !ALLOWED_CONTENT_TYPES.contains(contentType)) {
            throw new IllegalArgumentException("Chỉ chấp nhận ảnh JPG, PNG hoặc GIF.");
        }

        try (InputStream input = part.getInputStream()) {
            if (ImageIO.read(input) == null) {
                throw new IllegalArgumentException("Nội dung tệp tải lên không phải là ảnh hợp lệ.");
            }
        }

        Path uploadDirectory = Paths.get(Constants.DIR).toAbsolutePath().normalize();
        Files.createDirectories(uploadDirectory);
        String storedName = UUID.randomUUID() + "." + extension;
        Path target = uploadDirectory.resolve(storedName).normalize();
        if (!target.startsWith(uploadDirectory)) {
            throw new IOException("Đường dẫn lưu ảnh không hợp lệ.");
        }

        try (InputStream input = part.getInputStream()) {
            Files.copy(input, target);
        }
        return storedName;
    }

    private boolean isValidHttpUrl(String value) {
        try {
            URI uri = new URI(value);
            String scheme = uri.getScheme();
            return uri.getHost() != null
                    && ("http".equalsIgnoreCase(scheme) || "https".equalsIgnoreCase(scheme));
        } catch (URISyntaxException ex) {
            return false;
        }
    }

    private void deleteLocalImageQuietly(String image) {
        if (image == null || image.isBlank() || isValidHttpUrl(image)) {
            return;
        }
        try {
            Path uploadDirectory = Paths.get(Constants.DIR).toAbsolutePath().normalize();
            Path target = uploadDirectory.resolve(image).normalize();
            if (target.startsWith(uploadDirectory)) {
                Files.deleteIfExists(target);
            }
        } catch (IOException | SecurityException ignored) {
            // Image cleanup must not invalidate an otherwise successful database operation.
        }
    }

    private void moveFlashMessage(HttpServletRequest req, String name) {
        HttpSession session = req.getSession(false);
        if (session == null) {
            return;
        }
        Object value = session.getAttribute(name);
        if (value != null) {
            req.setAttribute(name, value);
            session.removeAttribute(name);
        }
    }

    private void prepareEncoding(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
    }

    private String trimToNull(String value) {
        if (value == null) {
            return null;
        }
        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }
}
