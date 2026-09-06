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
}
