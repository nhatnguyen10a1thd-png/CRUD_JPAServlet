package nguyen.vn.crud_jpaservlet.util;

import jakarta.mail.*;
import jakarta.mail.internet.*;
import java.util.Properties;

public class EmailUtil {

    // ====== CẤU HÌNH SMTP - THAY ĐỔI THEO TÀI KHOẢN CỦA BẠN ======
    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final int SMTP_PORT = 587;
    private static final String EMAIL_FROM = "your-email@gmail.com";       // ← Thay bằng Gmail của bạn
    private static final String EMAIL_PASSWORD = "your-app-password";      // ← Thay bằng App Password
    // ================================================================

    /**
     * Gửi mã OTP đến email người dùng.
     *
     * @param toEmail email người nhận
     * @param otpCode mã OTP 6 chữ số
     * @throws MessagingException nếu gửi email thất bại
     */
    public static void sendOTP(String toEmail, String otpCode) throws MessagingException {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", SMTP_HOST);
        props.put("mail.smtp.port", String.valueOf(SMTP_PORT));

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(EMAIL_FROM, EMAIL_PASSWORD);
            }
        });

        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress(EMAIL_FROM));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
        message.setSubject("Mã xác thực tài khoản - OTP Verification");

        // Nội dung HTML email
        String htmlContent = buildEmailContent(otpCode);
        message.setContent(htmlContent, "text/html; charset=UTF-8");

        Transport.send(message);
    }

    /**
     * Tạo nội dung HTML cho email OTP.
     */
    private static String buildEmailContent(String otpCode) {
        return "<!DOCTYPE html>"
                + "<html><head><meta charset='UTF-8'></head>"
                + "<body style='font-family: Arial, sans-serif; background-color: #f4f7fa; padding: 40px 0;'>"
                + "<div style='max-width: 480px; margin: 0 auto; background: #ffffff; border-radius: 12px; "
                + "box-shadow: 0 4px 24px rgba(0,0,0,0.08); overflow: hidden;'>"
                + "<div style='background: linear-gradient(135deg, #2563eb, #1d4ed8); padding: 32px; text-align: center;'>"
                + "<h1 style='color: #ffffff; margin: 0; font-size: 22px;'>Xác Thực Tài Khoản</h1>"
                + "</div>"
                + "<div style='padding: 32px;'>"
                + "<p style='color: #333; font-size: 15px; line-height: 1.6;'>"
                + "Xin chào,<br><br>"
                + "Cảm ơn bạn đã đăng ký tài khoản. Vui lòng sử dụng mã OTP bên dưới để xác thực email của bạn:"
                + "</p>"
                + "<div style='background: #f0f4ff; border: 2px dashed #2563eb; border-radius: 8px; "
                + "padding: 20px; text-align: center; margin: 24px 0;'>"
                + "<span style='font-size: 36px; font-weight: 700; letter-spacing: 8px; color: #2563eb;'>"
                + otpCode
                + "</span>"
                + "</div>"
                + "<p style='color: #666; font-size: 13px; line-height: 1.5;'>"
                + "⏰ Mã OTP có hiệu lực trong <strong>5 phút</strong>.<br>"
                + "Nếu bạn không yêu cầu mã này, vui lòng bỏ qua email."
                + "</p>"
                + "</div>"
                + "<div style='background: #f8fafc; padding: 16px 32px; text-align: center; "
                + "border-top: 1px solid #e2e8f0;'>"
                + "<p style='color: #94a3b8; font-size: 12px; margin: 0;'>"
                + "© 2026 Management System. All rights reserved."
                + "</p>"
                + "</div>"
                + "</div>"
                + "</body></html>";
    }
}
