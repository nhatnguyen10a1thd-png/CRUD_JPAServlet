package nguyen.vn.crud_jpaservlet.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import nguyen.vn.crud_jpaservlet.entity.User;
import nguyen.vn.crud_jpaservlet.service.IUserService;
import nguyen.vn.crud_jpaservlet.service.UserServiceImpl;

@WebServlet(urlPatterns = {
        "/login",
        "/logout"
})
public class LoginController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    public IUserService userService = new UserServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        String url = req.getRequestURI();

        if (url.contains("/logout")) {
            HttpSession session = req.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // Nếu đã đăng nhập rồi, chuyển về trang chủ
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("loggedInUser") != null) {
            resp.sendRedirect(req.getContextPath() + "/");
            return;
        }

        req.getRequestDispatcher("/views/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String username = req.getParameter("username");
        String password = req.getParameter("password");

        // Validate input
        if (username == null || username.trim().isEmpty()
                || password == null || password.trim().isEmpty()) {
            req.setAttribute("error", "Vui lòng nhập đầy đủ tên đăng nhập và mật khẩu!");
            req.setAttribute("username", username);
            req.getRequestDispatcher("/views/login.jsp").forward(req, resp);
            return;
        }

        try {
            User user = userService.login(username.trim(), password);
            if (user != null) {
                // Đăng nhập thành công
                HttpSession session = req.getSession();
                session.setAttribute("loggedInUser", user);
                session.setAttribute("loggedInFullname", user.getFullname());
                session.setAttribute("loggedInUsername", user.getUsername());
                session.setMaxInactiveInterval(30 * 60); // 30 phút

                resp.sendRedirect(req.getContextPath() + "/");
            } else {
                req.setAttribute("error", "Tên đăng nhập hoặc mật khẩu không đúng!");
                req.setAttribute("username", username);
                req.getRequestDispatcher("/views/login.jsp").forward(req, resp);
            }
        } catch (RuntimeException e) {
            // Tài khoản chưa kích hoạt
            req.setAttribute("error", e.getMessage());
            req.setAttribute("username", username);
            req.getRequestDispatcher("/views/login.jsp").forward(req, resp);
        }
    }
}
