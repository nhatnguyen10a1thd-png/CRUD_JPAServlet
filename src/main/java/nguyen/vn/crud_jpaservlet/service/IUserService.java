package nguyen.vn.crud_jpaservlet.service;

import nguyen.vn.crud_jpaservlet.entity.User;

public interface IUserService {

    void register(User user);

    void activateUser(String username);

    User findByUsername(String username);

    User findByEmail(String email);

    User login(String username, String password);

    void resetPassword(String username, String newPassword);
}
