package nguyen.vn.crud_jpaservlet.util;

import java.security.SecureRandom;

public class OTPUtil {

    private static final SecureRandom random = new SecureRandom();
    private static final int OTP_LENGTH = 6;

    /**
     * Tạo mã OTP ngẫu nhiên 6 chữ số.
     * @return mã OTP dạng String (ví dụ: "048291")
     */
    public static String generateOTP() {
        StringBuilder otp = new StringBuilder();
        for (int i = 0; i < OTP_LENGTH; i++) {
            otp.append(random.nextInt(10));
        }
        return otp.toString();
    }
}
