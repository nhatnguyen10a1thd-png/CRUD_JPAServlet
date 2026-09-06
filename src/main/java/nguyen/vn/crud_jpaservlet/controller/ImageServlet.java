package nguyen.vn.crud_jpaservlet.controller;

import java.io.IOException;
import java.nio.file.InvalidPathException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Locale;
import java.util.Set;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import nguyen.vn.crud_jpaservlet.config.Constants;

@WebServlet(urlPatterns = {"/image"})
public class ImageServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final Set<String> ALLOWED_EXTENSIONS = Set.of("jpg", "jpeg", "png", "gif", "webp");

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String fname = req.getParameter("fname");
        if (fname == null || fname.isEmpty()) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        Path uploadDirectory = Paths.get(Constants.DIR).toAbsolutePath().normalize();
        Path file;
        try {
            file = uploadDirectory.resolve(fname).normalize();
        } catch (InvalidPathException ex) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        String extension = extensionOf(fname);
        if (!file.startsWith(uploadDirectory)
                || !file.getParent().equals(uploadDirectory)
                || !Files.isRegularFile(file)
                || !ALLOWED_EXTENSIONS.contains(extension)) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        resp.setContentType(contentTypeFor(extension));
        resp.setHeader("X-Content-Type-Options", "nosniff");
        resp.setContentLengthLong(Files.size(file));
        Files.copy(file, resp.getOutputStream());
    }

    private String extensionOf(String fileName) {
        int dotIndex = fileName.lastIndexOf('.');
        if (dotIndex < 0 || dotIndex == fileName.length() - 1) {
            return "";
        }
        return fileName.substring(dotIndex + 1).toLowerCase(Locale.ROOT);
    }

    private String contentTypeFor(String extension) {
        return switch (extension) {
            case "jpg", "jpeg" -> "image/jpeg";
            case "png" -> "image/png";
            case "gif" -> "image/gif";
            case "webp" -> "image/webp";
            default -> "application/octet-stream";
        };
    }
}
