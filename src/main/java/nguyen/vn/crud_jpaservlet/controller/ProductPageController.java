package nguyen.vn.crud_jpaservlet.controller;

import java.io.IOException;
import java.util.Collections;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import nguyen.vn.crud_jpaservlet.entity.Product;
import nguyen.vn.crud_jpaservlet.service.IProductService;
import nguyen.vn.crud_jpaservlet.service.ProductServiceImpl;

@WebServlet(urlPatterns = {"/product", "/product/detail"})
public class ProductPageController extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final int PAGE_SIZE = 6;

    private final IProductService productService = new ProductServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        switch (req.getServletPath()) {
            case "/product" -> showProductList(req, resp);
            case "/product/detail" -> showProductDetail(req, resp);
            default -> resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void showProductList(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Integer currentPage = parsePositiveInt(req.getParameter("page"));
        if (currentPage == null) {
            if (req.getParameter("page") != null) {
                resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Tham số page phải là số nguyên dương.");
                return;
            }
            currentPage = 1;
        }

        long totalItems = productService.count();
        int totalPages = (int) ((totalItems + PAGE_SIZE - 1) / PAGE_SIZE);

        if (totalPages > 0 && currentPage > totalPages) {
            resp.sendRedirect(req.getContextPath() + "/product?page=" + totalPages);
            return;
        }

        req.setAttribute("listProduct",
                totalItems == 0 ? Collections.emptyList() : productService.findAll(currentPage, PAGE_SIZE));
        req.setAttribute("currentPage", currentPage);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("totalItems", totalItems);
        req.setAttribute("pageSize", PAGE_SIZE);
        req.getRequestDispatcher("/views/product-list.jsp").forward(req, resp);
    }

    private void showProductDetail(HttpServletRequest req, HttpServletResponse resp)
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
        req.getRequestDispatcher("/views/product-detail.jsp").forward(req, resp);
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
}
