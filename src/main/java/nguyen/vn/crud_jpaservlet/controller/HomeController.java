package nguyen.vn.crud_jpaservlet.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import nguyen.vn.crud_jpaservlet.service.IProductService;
import nguyen.vn.crud_jpaservlet.service.ProductServiceImpl;

@WebServlet(urlPatterns = "/home")
public class HomeController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final IProductService productService = new ProductServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        req.setAttribute("newestProducts", productService.findTop10Newest());
        req.getRequestDispatcher("/WEB-INF/views/home.jsp").forward(req, resp);
    }
}
