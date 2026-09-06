package nguyen.vn.crud_jpaservlet.dao;

import nguyen.vn.crud_jpaservlet.entity.User;

public interface IUserDao {

    void insert(User user);

    void update(User user);

    User findByUsername(String username);

    User findByEmail(String email);
}
