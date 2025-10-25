package com.stefano.newsmap.model;

import jakarta.persistence.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "country")
public class Country {

    @Id
    @Column(name = "iso_code", columnDefinition = "CHAR(2)", updatable = false)
    private String isoCode;

    @Column(nullable = false, length = 150)
    private String name;

    @Column(length = 100)
    private String region;

    @Column(name = "lat", precision = 9, scale = 6)
    private BigDecimal lat;

    @Column(name = "lon", precision = 9, scale = 6)
    private BigDecimal lon;

    @Column(length = 50)
    private String timezone;

    @Column(name = "inserted_at", updatable = false, insertable = false)
    private LocalDateTime insertedAt;

    // Costruttore di default richiesto da JPA
    public Country() {}

    // Costruttore completo
    public Country(String isoCode, String name, String region, BigDecimal lat, BigDecimal lon, String timezone) {
        this.isoCode = isoCode;
        this.name = name;
        this.region = region;
        this.lat = lat;
        this.lon = lon;
        this.timezone = timezone;
    }

    // Getter e Setter
    public String getIsoCode() {
        return isoCode;
    }

    public void setIsoCode(String isoCode) {
        this.isoCode = isoCode;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getRegion() {
        return region;
    }

    public void setRegion(String region) {
        this.region = region;
    }

    public BigDecimal getLat() {
        return lat;
    }

    public void setLat(BigDecimal lat) {
        this.lat = lat;
    }

    public BigDecimal getLon() {
        return lon;
    }

    public void setLon(BigDecimal lon) {
        this.lon = lon;
    }

    public String getTimezone() {
        return timezone;
    }

    public void setTimezone(String timezone) {
        this.timezone = timezone;
    }

    public LocalDateTime getInsertedAt() {
        return insertedAt;
    }

    @Override
    public String toString() {
        return "Country{" +
                "isoCode='" + isoCode + '\'' +
                ", name='" + name + '\'' +
                ", region='" + region + '\'' +
                ", lat=" + lat +
                ", lon=" + lon +
                ", timezone='" + timezone + '\'' +
                ", insertedAt=" + insertedAt +
                '}';
    }
}
