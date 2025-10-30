package com.stefano.newsmap.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "news")
public class News {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "source_id", nullable = false)
    private Source source;

    @Column(nullable = false)
    private String title;

    @Column(columnDefinition = "TEXT")
    private String description;
    @Column(length = 2048)
    private String url;
    @Column(length = 2048)
    private String imageUrl;
    private LocalDateTime publishedAt;

    @ManyToMany(cascade = {CascadeType.MERGE, CascadeType.PERSIST, CascadeType.REFRESH, CascadeType.DETACH})
    @JoinTable(
        name = "news_country",
        joinColumns = @JoinColumn(name = "news_id"),
        inverseJoinColumns = @JoinColumn(name = "country_iso", referencedColumnName = "iso_code")
    )
    private Set<Country> countries = new HashSet<>();

    // costruttori, getter e setter
    public News() {
    }
    public News(Source source, String title, String description, String url, String imageUrl, LocalDateTime publishedAt, Set<Country> countries) {
        this.source = source;
        this.title = title;
        this.description = description;
        this.url = url;
        this.imageUrl = imageUrl;
        this.publishedAt = publishedAt;
        this.countries = countries;
    }
    public Long getId() {
        return id;
    }
    public void setId(Long id) {
        this.id = id;
    }
    public Source getSource() {
        return source;
    }
    public void setSource(Source source) {
        this.source = source;
    }
    public String getTitle() {
        return title;
    }
    public void setTitle(String title) {
        this.title = title;
    }
    public String getDescription() {
        return description;
    }
    public void setDescription(String description) {
        this.description = description;
    }
    public String getUrl() {
        return url;
    }
    public void setUrl(String url) {
        this.url = url;
    }
    public String getImageUrl() {
        return imageUrl;
    }
    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }
    public LocalDateTime getPublishedAt() {
        return publishedAt;
    }
    public void setPublishedAt(LocalDateTime publishedAt) {
        this.publishedAt = publishedAt;
    }
    public Set<Country> getCountries() {
        return countries;
    }
    public void setCountries(Set<Country> countries) {
        this.countries = countries;
    }

    //To string
    @Override
    public String toString() {
        return "News{" +
                "id=" + id +
                ", source=" + source +
                ", title='" + title + '\'' +
                ", description='" + description + '\'' +
                ", url='" + url + '\'' +
                ", imageUrl='" + imageUrl + '\'' +
                ", publishedAt=" + publishedAt +
                ", countries=" + countries +
                '}';
    }
}
