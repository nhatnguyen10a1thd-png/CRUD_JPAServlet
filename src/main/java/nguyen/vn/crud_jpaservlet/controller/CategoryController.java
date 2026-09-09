package nguyen.vn.crud_jpaservlet.controller;

import java.io.IOException;
import java.io.InputStream;
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
import nguyen.vn.crud_jpaservlet.service.CategoryServiceImpl;
import nguyen.vn.crud_jpaservlet.service.ICategoryService;

@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 5L * 1024 * 1024,
        maxRequestSize = 6L * 1024 * 1024
)
@WebServlet(urlPatterns = {
        "/admin/categories",
        "/admin/category/add",
        "/admin/category/insert",
        "/admin/category/edit",
        "/admin/category/update",
        "/admin/category/delete"
})
public class CategoryController extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final Set<String> ALLOWED_EXTENSIONS = Set.of("jpg", "jpeg", "png", "gif");
    private static final Set<String> ALLOWED_CONTENT_TYPES = Set.of(
            "image/jpeg", "image/png", "image/gif"
    );

    private final ICategoryService cateService = new CategoryServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        prepareEncoding(req, resp);
        String path = req.getServletPath();

        switch (path) {
            case "/admin/categories" -> showCategoryList(req, resp);
            case "/admin/category/add" -> showAddForm(req, resp);
            case "/admin/category/edit" -> showEditForm(req, resp);
            case "/admin/category/delete" -> deleteCategory(req, resp);
            default -> resp.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        prepareEncoding(req, resp);
        String path = req.getServletPath();

        switch (path) {
            case "/admin/category/insert" -> saveCategory(req, resp, false);
            case "/admin/category/update" -> saveCategory(req, resp, true);
            case "/admin/category/delete" -> deleteCategory(req, resp);
            default -> resp.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
        }
    }

    private void showCategoryList(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        moveFlashMessage(req, "flashSuccess");
        moveFlashMessage(req, "flashError");
        List<Category> list = cateService.findAll();
        req.setAttribute("listcate", list);
        req.getRequestDispatcher("/views/admin/category-list.jsp").forward(req, resp);
    }

    private void showAddForm(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Category category = new Category();
        category.setStatus(1);
        req.setAttribute("cate", category);
        req.setAttribute("category", category);
        req.getRequestDispatcher("/views/admin/category-add.jsp").forward(req, resp);
    }

    private void showEditForm(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Integer id = parsePositiveInt(req.getParameter("id"));
        if (id == null) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Mã danh mục không hợp lệ.");
            return;
        }

        Category category = cateService.findById(id);
        if (category == null) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy danh mục.");
            return;
        }

        req.setAttribute("cate", category);
        req.setAttribute("category", category);
        req.getRequestDispatcher("/views/admin/category-edit.jsp").forward(req, resp);
    }

    private void saveCategory(HttpServletRequest req, HttpServletResponse resp, boolean updating)
            throws ServletException, IOException {
        Category category;
        String oldImage = null;

        if (updating) {
            Integer id = parsePositiveInt(req.getParameter("categoryid"));
            if (id == null) {
                resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Mã danh mục không hợp lệ.");
                return;
            }
            category = cateService.findById(id);
            if (category == null) {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy danh mục.");
                return;
            }
            oldImage = category.getImages();
        } else {
            category = new Category();
        }

        List<String> errors = new ArrayList<>();
        String categoryName = trimToNull(req.getParameter("categoryname"));
        String imageUrl = trimToNull(req.getParameter("images"));
        Integer status = parseStatus(req.getParameter("status"), errors);

        // Validate category name
        if (categoryName == null) {
            errors.add("Tên danh mục không được để trống.");
        } else if (categoryName.length() > 255) {
            errors.add("Tên danh mục không được vượt quá 255 ký tự.");
        }

        // Validate uploaded image
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

        if (categoryName != null) {
            category.setCategoryname(categoryName);
        }
        if (status != null) {
            category.setStatus(status);
        }
        if (!hasUpload && imageUrl != null) {
            category.setImages(imageUrl);
        }

        if (!errors.isEmpty()) {
            renderFormWithErrors(req, resp, category, errors, updating);
            return;
        }

        String uploadedFileName = null;
        try {
            if (hasUpload) {
                uploadedFileName = storeUploadedImage(imagePart);
                category.setImages(uploadedFileName);
            } else if (imageUrl == null && updating) {
                category.setImages(oldImage);
            } else if (imageUrl == null) {
                category.setImages("avatar.png");
            }

            if (updating) {
                cateService.update(category);
            } else {
                cateService.insert(category);
            }
        } catch (IllegalArgumentException ex) {
            deleteLocalImageQuietly(uploadedFileName);
            errors.add(ex.getMessage());
            renderFormWithErrors(req, resp, category, errors, updating);
            return;
        } catch (RuntimeException ex) {
            deleteLocalImageQuietly(uploadedFileName);
            errors.add("Không thể lưu danh mục. Vui lòng thử lại.");
            renderFormWithErrors(req, resp, category, errors, updating);
            return;
        }

        if (updating && oldImage != null && !oldImage.equals(category.getImages())) {
            deleteLocalImageQuietly(oldImage);
        }

        HttpSession session = req.getSession();
        session.setAttribute("flashSuccess", updating
                ? "Cập nhật danh mục thành công."
                : "Thêm danh mục thành công.");
        resp.sendRedirect(req.getContextPath() + "/admin/categories");
    }

    private void deleteCategory(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Integer id = parsePositiveInt(req.getParameter("id"));
        if (id == null) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Mã danh mục không hợp lệ.");
            return;
        }

        Category category = cateService.findById(id);
        if (category == null) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy danh mục.");
            return;
        }

        HttpSession session = req.getSession();
        try {
            cateService.delete(id);
            deleteLocalImageQuietly(category.getImages());
            session.setAttribute("flashSuccess", "Xóa danh mục thành công.");
        } catch (Exception ex) {
            session.setAttribute("flashError", "Không thể xóa danh mục vì có ràng buộc dữ liệu hoặc lỗi hệ thống.");
        }
        resp.sendRedirect(req.getContextPath() + "/admin/categories");
    }

    private void renderFormWithErrors(HttpServletRequest req, HttpServletResponse resp, Category category,
                                      List<String> errors, boolean updating)
            throws ServletException, IOException {
        req.setAttribute("errors", errors);
        req.setAttribute("error", String.join(" ", errors));
        req.setAttribute("cate", category);
        req.setAttribute("category", category);
        req.getRequestDispatcher(updating
                ? "/views/admin/category-edit.jsp"
                : "/views/admin/category-add.jsp").forward(req, resp);
    }

    private Integer parseStatus(String value, List<String> errors) {
        try {
            int status = Integer.parseInt(value);
            if (status == 0 || status == 1) {
                return status;
            }
        } catch (NumberFormatException | NullPointerException ignored) {
            // Error added below
        }
        errors.add("Trạng thái danh mục không hợp lệ (phải chọn Đang hoạt động hoặc Đã khóa).");
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
        if (image == null || image.isBlank() || isValidHttpUrl(image) || "avatar.png".equals(image)) {
            return;
        }
        try {
            Path uploadDirectory = Paths.get(Constants.DIR).toAbsolutePath().normalize();
            Path target = uploadDirectory.resolve(image).normalize();
            if (target.startsWith(uploadDirectory)) {
                Files.deleteIfExists(target);
            }
        } catch (IOException | SecurityException ignored) {
            // Image cleanup failure should not prevent operation
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
