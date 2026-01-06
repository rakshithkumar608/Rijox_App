import java.security.SecureRandom;

public class OtpService {
   
    public String generateOtp(int length) {
        SecureRandom secureRandom = new SecureRandom();
        StringBuilder otp = new StringBuilder();
        
        for (int i = 0; i < length; i++) {
            otp.append(secureRandom.nextInt(10)); // Appends a digit between 0-9
        }
        return otp.toString();
    }
}