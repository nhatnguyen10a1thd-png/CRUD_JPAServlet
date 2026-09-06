package nguyen.vn.crud_jpaservlet.controller;

import java.io.IOException;

import jakarta.mail.MessagingException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import nguyen.vn.crud_jpaservlet.entity.User;
import nguyen.vn.crud_jpaservlet.service.IUserService;
import nguyen.vn.crud_jpaservlet.service.UserServiceImpl;
import nguyen.vn.crud_jpaservlet.util.EmailUtil;
import nguyen.vn.crud_jpaservlet.util.OTPUtil;

@WebServlet(urlPatterns = {
        "/register",
        "/verify-otp",
        "/resend-otp"
})
public class RegisterController extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final long OTP_EXPIRY_MS = 5 * 60 * 1000; // 5 phút

    public IUserService userService = new UserServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        String url = req.getRequestURI();

        if (url.contains("/verify-otp")) {
            // Kiểm tra có session đăng ký không
            HttpSession session = req.getSession(false);
            if (session == null || session.getAttribute("otp") == null) {
                resp.sendRedirect(req.getContextPath() + "/register");
                return;
            }
            req.getRequestDispatcher("/views/verify-otp.jsp").forward(req, resp);
        } else if (url.contains("/register")) {
            req.getRequestDispatcher("/views/register.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        String url = req.getRequestURI();

        if (url.contains("/resend-otp")) {
            handleResendOTP(req, resp);
        } else if (url.contains("/verify-otp")) {
            handleVerifyOTP(req, resp);
        } else if (url.contains("/register")) {
            handleRegister(req, resp);
        }
    }

    /**
     * Xử lý đăng ký tài khoản mới
     */
    private void handleRegister(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username");
        String fullname = req.getParameter("fullname");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");
        String password = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");

        // Validate các trường bắt buộc
        if (username == null || username.trim().isEmpty()
                || fullname == null || fullname.trim().isEmpty()
                || email == null || email.trim().isEmpty()
                || password == null || password.trim().isEmpty()) {
            req.setAttribute("error", "Vui lòng điền đầy đủ thông tin!");
            req.setAttribute("username", username);
            req.setAttribute("fullname", fullname);
            req.setAttribute("email", email);
            req.setAttribute("phone", phone);
            req.getRequestDispatcher("/views/register.jsp").forward(req, resp);
            return;
        }

        // Validate mật khẩu khớp nhau
        if (!password.equals(confirmPassword)) {
            req.setAttribute("error", "Mật khẩu xác nhận không khớp!");
            req.setAttribute("username", username);
            req.setAttribute("fullname", fullname);
            req.setAttribute("email", email);
            req.setAttribute("phone", phone);
            req.getRequestDispatcher("/views/register.jsp").forward(req, resp);
            return;
        }

        // Tạo đối tượng User
        User user = new User();
        user.setUsername(username.trim());
        user.setFullname(fullname.trim());
        user.setEmail(email.trim());
        user.setPhone(phone != null ? phone.trim() : "");
        user.setPassword(password);
        user.setImages("avatar.png");

        // Đăng ký user (active = false)
        try {
            userService.register(user);
        } catch (RuntimeException e) {
            req.setAttribute("error", e.getMessage());
            req.setAttribute("username", username);
            req.setAttribute("fullname", fullname);
            req.setAttribute("email", email);
            req.setAttribute("phone", phone);
            req.getRequestDispatcher("/views/register.jsp").forward(req, resp);
            return;
        }

        // Tạo OTP và gửi email
        String otp = OTPUtil.generateOTP();
        try {
            EmailUtil.sendOTP(email.trim(), otp);
        } catch (MessagingException e) {
            e.printStackTrace();
            req.setAttribute("error", "Không thể gửi email OTP. Vui lòng thử lại!");
            req.getRequestDispatcher("/views/register.jsp").forward(req, resp);
            return;
        }

        // Lưu OTP vào session
        HttpSession session = req.getSession();
        session.setAttribute("otp", otp);
        session.setAttribute("otpExpiry", System.currentTimeMillis() + OTP_EXPIRY_MS);
        session.setAttribute("otpUsername", username.trim());
        session.setAttribute("otpEmail", email.trim());

        // Chuyển sang trang nhập OTP
        resp.sendRedirect(req.getContextPath() + "/verify-otp");
    }

    /**
     * Xử lý xác thực OTP
     */
    private void handleVerifyOTP(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("otp") == null) {
            resp.sendRedirect(req.getContextPath() + "/register");
            return;
        }

        // Lấy OTP từ 6 ô input riêng biệt
        StringBuilder otpInput = new StringBuilder();
        for (int i = 1; i <= 6; i++) {
            String digit = req.getParameter("otp" + i);
            if (digit != null && !digit.isEmpty()) {
                otpInput.append(digit);
            }
        }

        // Nếu chỉ có 1 trường "otp" (fallback)
        if (otpInput.length() == 0) {
            String singleOtp = req.getParameter("otp");
            if (singleOtp != null) {
                otpInput.append(singleOtp.trim());
            }
        }

        String storedOtp = (String) session.getAttribute("otp");
        long otpExpiry = (long) session.getAttribute("otpExpiry");
        String username = (String) session.getAttribute("otpUsername");

        // Kiểm tra hết hạn
        if (System.currentTimeMillis() > otpExpiry) {
            req.setAttribute("error", "Mã OTP đã hết hạn! Vui lòng gửi lại mã mới.");
            req.getRequestDispatcher("/views/verify-otp.jsp").forward(req, resp);
            return;
        }

        // Kiểm tra OTP
        if (otpInput.toString().equals(storedOtp)) {
            // Kích hoạt tài khoản
            userService.activateUser(username);

            // Xóa thông tin OTP khỏi session
            session.removeAttribute("otp");
            session.removeAttribute("otpExpiry");
            session.removeAttribute("otpUsername");
            session.removeAttribute("otpEmail");

            // Chuyển sang trang thành công
            req.getRequestDispatcher("/views/register-success.jsp").forward(req, resp);
        } else {
            req.setAttribute("error", "Mã OTP không đúng! Vui lòng thử lại.");
            req.getRequestDispatcher("/views/verify-otp.jsp").forward(req, resp);
        }
    }

    /**
     * Xử lý gửi lại OTP
     */
    private void handleResendOTP(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("otpEmail") == null) {
            resp.sendRedirect(req.getContextPath() + "/register");
            return;
        }

        String email = (String) session.getAttribute("otpEmail");

        // Tạo OTP mới
        String newOtp = OTPUtil.generateOTP();
        try {
            EmailUtil.sendOTP(email, newOtp);
        } catch (MessagingException e) {
            e.printStackTrace();
            req.setAttribute("error", "Không thể gửi lại email OTP. Vui lòng thử lại!");
            req.getRequestDispatcher("/views/verify-otp.jsp").forward(req, resp);
            return;
        }

        // Cập nhật OTP mới vào session
        session.setAttribute("otp", newOtp);
        session.setAttribute("otpExpiry", System.currentTimeMillis() + OTP_EXPIRY_MS);

        req.setAttribute("success", "Mã OTP mới đã được gửi đến email " + email);
        req.getRequestDispatcher("/views/verify-otp.jsp").forward(req, resp);
    }
}
