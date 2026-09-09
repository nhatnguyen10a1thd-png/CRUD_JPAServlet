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

    private static final String USERNAME_PATTERN = "^[a-zA-Z0-9_]{3,50}$";
    private static final String EMAIL_PATTERN = "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$";
    private static final String PHONE_PATTERN = "^[0-9]{10,11}$";

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

        String trimmedUsername = username != null ? username.trim() : "";
        String trimmedFullname = fullname != null ? fullname.trim() : "";
        String trimmedEmail = email != null ? email.trim() : "";
        String trimmedPhone = phone != null ? phone.trim() : "";

        java.util.List<String> errors = new java.util.ArrayList<>();

        // Validate username
        if (trimmedUsername.isEmpty()) {
            errors.add("Tên đăng nhập không được để trống.");
        } else if (!trimmedUsername.matches(USERNAME_PATTERN)) {
            errors.add("Tên đăng nhập phải từ 3 đến 50 ký tự, chỉ gồm chữ cái, số và dấu gạch dưới (_).");
        }

        // Validate fullname
        if (trimmedFullname.isEmpty()) {
            errors.add("Họ và tên không được để trống.");
        } else if (trimmedFullname.length() > 100) {
            errors.add("Họ và tên không được vượt quá 100 ký tự.");
        }

        // Validate email
        if (trimmedEmail.isEmpty()) {
            errors.add("Email không được để trống.");
        } else if (trimmedEmail.length() > 100) {
            errors.add("Email không được vượt quá 100 ký tự.");
        } else if (!trimmedEmail.matches(EMAIL_PATTERN)) {
            errors.add("Địa chỉ email không đúng định dạng.");
        }

        // Validate phone (optional)
        if (!trimmedPhone.isEmpty() && !trimmedPhone.matches(PHONE_PATTERN)) {
            errors.add("Số điện thoại phải gồm 10 đến 11 chữ số.");
        }

        // Validate password
        if (password == null || password.isEmpty()) {
            errors.add("Mật khẩu không được để trống.");
        } else if (password.length() < 6) {
            errors.add("Mật khẩu phải có ít nhất 6 ký tự.");
        }

        // Validate confirm password
        if (confirmPassword == null || confirmPassword.isEmpty()) {
            errors.add("Vui lòng xác nhận mật khẩu.");
        } else if (password != null && !password.equals(confirmPassword)) {
            errors.add("Mật khẩu xác nhận không khớp.");
        }

        if (!errors.isEmpty()) {
            req.setAttribute("errors", errors);
            req.setAttribute("error", String.join(" ", errors));
            req.setAttribute("username", trimmedUsername);
            req.setAttribute("fullname", trimmedFullname);
            req.setAttribute("email", trimmedEmail);
            req.setAttribute("phone", trimmedPhone);
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
