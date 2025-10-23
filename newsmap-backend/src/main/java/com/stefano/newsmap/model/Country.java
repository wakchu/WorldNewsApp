package com.stefano.newsmap.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "country")
public class Country {

    @Id
    @Column(name = "iso_code", columnDefinition = "CHAR(2)", updatable = false)
    private String isoCode;

    @Column(nullable = false)
    private String name;

    private String region;

    // Costruttore di default richiesto da JPA
    public Country() {
    }

    // Costruttore completo
    public Country(String isoCode, String name, String region) {
        this.isoCode = isoCode;
        this.name = name;
        this.region = region;
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

    // toString() utile per debug
    @Override
    public String toString() {
        return "Country{" +
                "isoCode='" + isoCode + '\'' +
                ", name='" + name + '\'' +
                ", region='" + region + '\'' +
                '}';
    }
}
