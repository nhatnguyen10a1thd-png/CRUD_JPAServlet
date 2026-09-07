package nguyen.vn.crud_jpaservlet.controller;

import java.io.IOException;
import java.io.InputStream;
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
import nguyen.vn.crud_jpaservlet.entity.User;
import nguyen.vn.crud_jpaservlet.service.IUserService;
import nguyen.vn.crud_jpaservlet.service.UserServiceImpl;

@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,      // 1 MB
        maxFileSize = 5L * 1024 * 1024,        // 5 MB
        maxRequestSize = 6L * 1024 * 1024      // 6 MB
)
@WebServlet(urlPatterns = {
        "/profile",
        "/profile/update"
})
public class ProfileController extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final Set<String> ALLOWED_EXTENSIONS = Set.of("jpg", "jpeg", "png", "gif");
    private static final Set<String> ALLOWED_CONTENT_TYPES = Set.of(
            "image/jpeg", "image/png", "image/gif"
    );

    private final IUserService userService = new UserServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        // Kiểm tra đăng nhập
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // Load thông tin user mới nhất từ DB
        User sessionUser = (User) session.getAttribute("loggedInUser");
        User user = userService.findByUsername(sessionUser.getUsername());
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // Flash messages
        moveFlashMessage(req, "flashSuccess");
        moveFlashMessage(req, "flashError");

        req.setAttribute("profileUser", user);
        req.getRequestDispatcher("/WEB-INF/views/profile.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        if (!"/profile/update".equals(req.getServletPath())) {
            resp.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
            return;
        }

        // Kiểm tra đăng nhập
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        User sessionUser = (User) session.getAttribute("loggedInUser");
        User currentUser = userService.findByUsername(sessionUser.getUsername());
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        List<String> errors = new ArrayList<>();

        // Lấy dữ liệu từ form
        String fullname = trimToNull(req.getParameter("fullname"));
        String phone = trimToNull(req.getParameter("phone"));

        // Validate fullname
        if (fullname == null) {
            errors.add("Họ tên không được để trống.");
        } else if (fullname.length() > 100) {
            errors.add("Họ tên không được vượt quá 100 ký tự.");
        }

        // Validate phone
        if (phone != null) {
            if (!phone.matches("^[0-9]{10,11}$")) {
                errors.add("Số điện thoại phải gồm 10-11 chữ số.");
            }
        }

        // Xử lý upload ảnh
        Part imagePart = null;
        try {
            imagePart = req.getPart("avatar");
        } catch (IllegalStateException ex) {
            errors.add("Ảnh tải lên vượt quá dung lượng cho phép (5 MB).");
        }

        boolean hasUpload = imagePart != null && imagePart.getSize() > 0;

        // Nếu có lỗi validation, quay lại form
        if (!errors.isEmpty()) {
            req.setAttribute("errors", errors);
            req.setAttribute("error", String.join(" ", errors));
            currentUser.setFullname(fullname != null ? fullname : currentUser.getFullname());
            currentUser.setPhone(phone);
            req.setAttribute("profileUser", currentUser);
            req.getRequestDispatcher("/WEB-INF/views/profile.jsp").forward(req, resp);
            return;
        }

        // Cập nhật thông tin user
        String oldImage = currentUser.getImages();
        currentUser.setFullname(fullname);
        currentUser.setPhone(phone);

        String uploadedFileName = null;
        try {
            if (hasUpload) {
                uploadedFileName = storeUploadedImage(imagePart);
                currentUser.setImages(uploadedFileName);
            }

            userService.updateProfile(currentUser);
        } catch (IllegalArgumentException ex) {
            // Lỗi validation ảnh
            deleteLocalImageQuietly(uploadedFileName);
            errors.add(ex.getMessage());
            req.setAttribute("errors", errors);
            req.setAttribute("error", String.join(" ", errors));
            req.setAttribute("profileUser", currentUser);
            req.getRequestDispatcher("/WEB-INF/views/profile.jsp").forward(req, resp);
            return;
        } catch (RuntimeException ex) {
            deleteLocalImageQuietly(uploadedFileName);
            errors.add("Không thể cập nhật hồ sơ. Vui lòng thử lại.");
            req.setAttribute("errors", errors);
            req.setAttribute("error", String.join(" ", errors));
            req.setAttribute("profileUser", currentUser);
            req.getRequestDispatcher("/WEB-INF/views/profile.jsp").forward(req, resp);
            return;
        }

        // Xóa ảnh cũ nếu đã upload ảnh mới
        if (hasUpload && oldImage != null && !oldImage.equals(currentUser.getImages())) {
            deleteLocalImageQuietly(oldImage);
        }

        // Cập nhật session
        User updatedUser = userService.findByUsername(currentUser.getUsername());
        session.setAttribute("loggedInUser", updatedUser);
        session.setAttribute("loggedInFullname", updatedUser.getFullname());

        session.setAttribute("flashSuccess", "Cập nhật hồ sơ thành công!");
        resp.sendRedirect(req.getContextPath() + "/profile");
    }

    /**
     * Lưu ảnh upload vào thư mục C:/uploads với tên UUID.
     */
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

    private void deleteLocalImageQuietly(String image) {
        if (image == null || image.isBlank()) {
            return;
        }
        try {
            // Skip URLs
            if (image.toLowerCase(Locale.ROOT).startsWith("http://")
                    || image.toLowerCase(Locale.ROOT).startsWith("https://")) {
                return;
            }
            Path uploadDirectory = Paths.get(Constants.DIR).toAbsolutePath().normalize();
            Path target = uploadDirectory.resolve(image).normalize();
            if (target.startsWith(uploadDirectory)) {
                Files.deleteIfExists(target);
            }
        } catch (IOException | SecurityException ignored) {
            // Cleanup failure should not invalidate a successful DB operation
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

    private String trimToNull(String value) {
        if (value == null) {
            return null;
        }
        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }
}
