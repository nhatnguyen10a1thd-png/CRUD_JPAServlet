package nguyen.vn.crud_jpaservlet.service;

import nguyen.vn.crud_jpaservlet.dao.IUserDao;
import nguyen.vn.crud_jpaservlet.dao.UserDao;
import nguyen.vn.crud_jpaservlet.entity.User;

public class UserServiceImpl implements IUserService {

    public IUserDao userDao = new UserDao();

    @Override
    public void register(User user) {
        // Kiểm tra username đã tồn tại chưa
        User existingUser = userDao.findByUsername(user.getUsername());
        if (existingUser != null) {
            throw new RuntimeException("Username đã tồn tại!");
        }

        // Kiểm tra email đã tồn tại chưa
        User existingEmail = userDao.findByEmail(user.getEmail());
        if (existingEmail != null) {
            throw new RuntimeException("Email đã được sử dụng!");
        }

        // Mặc định tài khoản chưa kích hoạt
        user.setActive(false);
        user.setAdmin(false);

        userDao.insert(user);
    }

    @Override
    public void activateUser(String username) {
        User user = userDao.findByUsername(username);
        if (user != null) {
            user.setActive(true);
            userDao.update(user);
        }
    }

    @Override
    public User findByUsername(String username) {
        return userDao.findByUsername(username);
    }

    @Override
    public User findByEmail(String email) {
        return userDao.findByEmail(email);
    }

    @Override
    public User login(String username, String password) {
        User user = userDao.findByUsername(username);
        if (user == null) {
            return null;
        }
        if (!user.getActive()) {
            throw new RuntimeException("Tài khoản chưa được kích hoạt! Vui lòng kiểm tra email để xác thực OTP.");
        }
        if (!user.getPassword().equals(password)) {
            return null;
        }
        return user;
    }

    @Override
    public void resetPassword(String username, String newPassword) {
        userDao.updatePassword(username, newPassword);
    }

    @Override
    public void updateProfile(User user) {
        User existing = userDao.findByUsername(user.getUsername());
        if (existing == null) {
            throw new RuntimeException("Không tìm thấy người dùng!");
        }
        existing.setFullname(user.getFullname());
        existing.setPhone(user.getPhone());
        if (user.getImages() != null) {
            existing.setImages(user.getImages());
        }
        userDao.update(existing);
    }
}
