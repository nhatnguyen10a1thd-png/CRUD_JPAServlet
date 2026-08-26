package nguyen.vn.crud_jpaservlet.entity;

import java.io.Serializable;
import java.util.List;
import jakarta.persistence.*;

@Entity
@Table(name = "Users")
@NamedQuery(name = "User.findAll", query = "SELECT u FROM User u")
public class User implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @Column(name = "Username")
    private String username;

    @Column(name = "Active")
    private boolean active;

    @Column(name = "Admin")
    private boolean admin;

    @Column(name = "Email")
    private String email;

    @Column(name = "Phone")
    private String phone;

    @Column(name = "Fullname")
    private String fullname;

    @Column(name = "Password")
    private String password;

    @Column(name = "Images")
    private String images;

    // bi-directional many-to-one association to Favorite
    @OneToMany(mappedBy = "user")
    private List<Favorite> favorites;

    // bi-directional many-to-one association to Share
    @OneToMany(mappedBy = "user")
    private List<Share> shares;

    public User() {
    }

    public String getUsername() {
        return this.username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public boolean getActive() {
        return this.active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }

    public boolean getAdmin() {
        return this.admin;
    }

    public void setAdmin(boolean admin) {
        this.admin = admin;
    }

    public String getImages() {
        return images;
    }

    public void setImages(String images) {
        this.images = images;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getFullname() {
        return fullname;
    }

    public void setFullname(String fullname) {
        this.fullname = fullname;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public List<Favorite> getFavorites() {
        return this.favorites;
    }

    public void setFavorites(List<Favorite> favorites) {
        this.favorites = favorites;
    }

    public Favorite addFavorite(Favorite favorite) {
        getFavorites().add(favorite);
        favorite.setUser(this);
        return favorite;
    }

    public Favorite removeFavorite(Favorite favorite) {
        getFavorites().remove(favorite);
        favorite.setUser(null);
        return favorite;
    }

    public List<Share> getShares() {
        return this.shares;
    }

    public void setShares(List<Share> shares) {
        this.shares = shares;
    }

    public Share addShare(Share share) {
        getShares().add(share);
        share.setUser(this);
        return share;
    }

    public Share removeShare(Share share) {
        getShares().remove(share);
        share.setUser(null);
        return share;
    }
}
