package com.stefano.newsmap.model;

import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.persistence.*;
import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "app_user")
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name="username", unique = true, nullable = false)
    private String username;

    @Column(name="password_hash", nullable = false)
    @JsonProperty(access = JsonProperty.Access.WRITE_ONLY)
    private String password_hash;

    @Column(name = "email")
    private String email;

    @Column(name="role", nullable = false)
    private String role = "USER"; // default USER


    @ManyToMany
    @JoinTable(
        name = "user_favorite_countries",
        joinColumns = @JoinColumn(name = "user_id"),
        inverseJoinColumns = @JoinColumn(name = "country_iso", referencedColumnName = "iso_code")
    )
    private Set<Country> favoriteCountries = new HashSet<>();

    @ManyToMany
    @JoinTable(
        name = "user_favorite_news",
        joinColumns = @JoinColumn(name = "user_id"),
        inverseJoinColumns = @JoinColumn(name = "news_id")
    )
    private Set<News> favoriteNews = new HashSet<>();

    // Getters & Setters
    public Long getId() { return id; }
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    public String getPassword() { return password_hash; }
    public void setPassword(String password) { this.password_hash = password; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getRole() {return role;}
    public void setRole(String role) {this.role = role;}
    public Set<Country> getFavoriteCountries() { return favoriteCountries; }
    public void setFavoriteCountries(Set<Country> favoriteCountries) { this.favoriteCountries = favoriteCountries; }
    public Set<News> getFavoriteNews() { return favoriteNews; }
    public void setFavoriteNews(Set<News> favoriteNews) { this.favoriteNews = favoriteNews; }
}
