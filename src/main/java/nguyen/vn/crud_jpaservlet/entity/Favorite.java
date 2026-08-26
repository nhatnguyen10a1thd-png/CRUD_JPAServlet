package nguyen.vn.crud_jpaservlet.entity;

import java.io.Serializable;
import java.util.Date;

import jakarta.persistence.*;

@Entity
@Table(name = "Favorites")
@NamedQuery(name = "Favorite.findAll", query = "SELECT f FROM Favorite f")
public class Favorite implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "FavoriteId")
    private int favoriteId;

    @Column(name = "LikedDate")
    private Date likedDate;

    // bi-directional many-to-one association to User
    @ManyToOne
    @JoinColumn(name = "Username")
    private User user;

    // bi-directional many-to-one association to Video
    @ManyToOne
    @JoinColumn(name = "VideoId")
    private Video video;

    public Favorite() {
    }

    public int getFavoriteId() {
        return this.favoriteId;
    }

    public void setFavoriteId(int favoriteId) {
        this.favoriteId = favoriteId;
    }

    public Date getLikedDate() {
        return this.likedDate;
    }

    public void setLikedDate(Date likedDate) {
        this.likedDate = likedDate;
    }

    public User getUser() {
        return this.user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public Video getVideo() {
        return this.video;
    }

    public void setVideo(Video video) {
        this.video = video;
    }
}
