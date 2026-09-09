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
        "/forgot-password",
        "/verify-reset-otp",
        "/resend-reset-otp",
        "/reset-password"
})
public class ForgotPasswordController extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final long OTP_EXPIRY_MS = 5 * 60 * 1000; // 5 phút

    public IUserService userService = new UserServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        String url = req.getRequestURI();

        if (url.contains("/verify-reset-otp")) {
            HttpSession session = req.getSession(false);
            if (session == null || session.getAttribute("resetOtp") == null) {
                resp.sendRedirect(req.getContextPath() + "/forgot-password");
                return;
            }
            req.getRequestDispatcher("/views/verify-reset-otp.jsp").forward(req, resp);
        } else if (url.contains("/reset-password")) {
            HttpSession session = req.getSession(false);
            if (session == null || session.getAttribute("resetVerified") == null) {
                resp.sendRedirect(req.getContextPath() + "/forgot-password");
                return;
            }
            req.getRequestDispatcher("/views/reset-password.jsp").forward(req, resp);
        } else if (url.contains("/forgot-password")) {
            req.getRequestDispatcher("/views/forgot-password.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        String url = req.getRequestURI();

        if (url.contains("/resend-reset-otp")) {
            handleResendOTP(req, resp);
        } else if (url.contains("/verify-reset-otp")) {
            handleVerifyOTP(req, resp);
        } else if (url.contains("/reset-password")) {
            handleResetPassword(req, resp);
        } else if (url.contains("/forgot-password")) {
            handleForgotPassword(req, resp);
        }
    }

    private static final String EMAIL_PATTERN = "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$";

    /**
     * Xử lý gửi OTP quên mật khẩu
     */
    private void handleForgotPassword(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        String trimmedEmail = email != null ? email.trim() : "";

        if (trimmedEmail.isEmpty()) {
            req.setAttribute("error", "Vui lòng nhập địa chỉ email!");
            req.getRequestDispatcher("/views/forgot-password.jsp").forward(req, resp);
            return;
        }

        if (!trimmedEmail.matches(EMAIL_PATTERN)) {
            req.setAttribute("error", "Địa chỉ email không đúng định dạng!");
            req.setAttribute("email", trimmedEmail);
            req.getRequestDispatcher("/views/forgot-password.jsp").forward(req, resp);
            return;
        }

        // Kiểm tra email có tồn tại không
        User user = userService.findByEmail(trimmedEmail);
        if (user == null) {
            req.setAttribute("error", "Email không tồn tại trong hệ thống!");
            req.setAttribute("email", email);
            req.getRequestDispatcher("/views/forgot-password.jsp").forward(req, resp);
            return;
        }

        // Tạo OTP và gửi email
        String otp = OTPUtil.generateOTP();
        try {
            EmailUtil.sendOTP(email.trim(), otp);
        } catch (MessagingException e) {
            e.printStackTrace();
            req.setAttribute("error", "Không thể gửi email OTP. Vui lòng thử lại!");
            req.setAttribute("email", email);
            req.getRequestDispatcher("/views/forgot-password.jsp").forward(req, resp);
            return;
        }

        // Lưu vào session
        HttpSession session = req.getSession();
        session.setAttribute("resetOtp", otp);
        session.setAttribute("resetOtpExpiry", System.currentTimeMillis() + OTP_EXPIRY_MS);
        session.setAttribute("resetEmail", email.trim());
        session.setAttribute("resetUsername", user.getUsername());

        resp.sendRedirect(req.getContextPath() + "/verify-reset-otp");
    }

    /**
     * Xử lý xác thực OTP quên mật khẩu
     */
    private void handleVerifyOTP(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("resetOtp") == null) {
            resp.sendRedirect(req.getContextPath() + "/forgot-password");
            return;
        }

        // Lấy OTP từ 6 ô input
        StringBuilder otpInput = new StringBuilder();
        for (int i = 1; i <= 6; i++) {
            String digit = req.getParameter("otp" + i);
            if (digit != null && !digit.isEmpty()) {
                otpInput.append(digit);
            }
        }

        // Fallback: 1 trường "otp"
        if (otpInput.length() == 0) {
            String singleOtp = req.getParameter("otp");
            if (singleOtp != null) {
                otpInput.append(singleOtp.trim());
            }
        }

        String storedOtp = (String) session.getAttribute("resetOtp");
        long otpExpiry = (long) session.getAttribute("resetOtpExpiry");

        // Kiểm tra hết hạn
        if (System.currentTimeMillis() > otpExpiry) {
            req.setAttribute("error", "Mã OTP đã hết hạn! Vui lòng gửi lại mã mới.");
            req.getRequestDispatcher("/views/verify-reset-otp.jsp").forward(req, resp);
            return;
        }

        // Kiểm tra OTP
        if (otpInput.toString().equals(storedOtp)) {
            // Đánh dấu đã xác thực OTP
            session.setAttribute("resetVerified", true);

            // Xóa OTP khỏi session
            session.removeAttribute("resetOtp");
            session.removeAttribute("resetOtpExpiry");

            resp.sendRedirect(req.getContextPath() + "/reset-password");
        } else {
            req.setAttribute("error", "Mã OTP không đúng! Vui lòng thử lại.");
            req.getRequestDispatcher("/views/verify-reset-otp.jsp").forward(req, resp);
        }
    }

    /**
     * Xử lý gửi lại OTP
     */
    private void handleResendOTP(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("resetEmail") == null) {
            resp.sendRedirect(req.getContextPath() + "/forgot-password");
            return;
        }

        String email = (String) session.getAttribute("resetEmail");

        String newOtp = OTPUtil.generateOTP();
        try {
            EmailUtil.sendOTP(email, newOtp);
        } catch (MessagingException e) {
            e.printStackTrace();
            req.setAttribute("error", "Không thể gửi lại email OTP. Vui lòng thử lại!");
            req.getRequestDispatcher("/views/verify-reset-otp.jsp").forward(req, resp);
            return;
        }

        session.setAttribute("resetOtp", newOtp);
        session.setAttribute("resetOtpExpiry", System.currentTimeMillis() + OTP_EXPIRY_MS);

        req.setAttribute("success", "Mã OTP mới đã được gửi đến email " + email);
        req.getRequestDispatcher("/views/verify-reset-otp.jsp").forward(req, resp);
    }

    /**
     * Xử lý đặt lại mật khẩu mới
     */
    private void handleResetPassword(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("resetVerified") == null) {
            resp.sendRedirect(req.getContextPath() + "/forgot-password");
            return;
        }

        String newPassword = req.getParameter("newPassword");
        String confirmPassword = req.getParameter("confirmPassword");
        String username = (String) session.getAttribute("resetUsername");

        // Validate
        if (newPassword == null || newPassword.isEmpty()) {
            req.setAttribute("error", "Vui lòng nhập mật khẩu mới!");
            req.getRequestDispatcher("/views/reset-password.jsp").forward(req, resp);
            return;
        }

        if (newPassword.length() < 6) {
            req.setAttribute("error", "Mật khẩu mới phải có ít nhất 6 ký tự!");
            req.getRequestDispatcher("/views/reset-password.jsp").forward(req, resp);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            req.setAttribute("error", "Mật khẩu xác nhận không khớp!");
            req.getRequestDispatcher("/views/reset-password.jsp").forward(req, resp);
            return;
        }

        // Đổi mật khẩu
        userService.resetPassword(username, newPassword);

        // Xóa thông tin reset khỏi session
        session.removeAttribute("resetVerified");
        session.removeAttribute("resetEmail");
        session.removeAttribute("resetUsername");

        // Chuyển sang trang thành công
        req.getRequestDispatcher("/views/reset-success.jsp").forward(req, resp);
    }
}
