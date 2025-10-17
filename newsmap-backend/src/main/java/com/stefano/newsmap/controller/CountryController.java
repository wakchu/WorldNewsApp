package com.stefano.newsmap.controller;

import com.stefano.newsmap.model.Country;
import com.stefano.newsmap.repository.CountryRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/countries")
public class CountryController {

    @Autowired
    private CountryRepository repository;

    @GetMapping
    public List<Country> getAllCountries() {
        return repository.findAll();
    }
}
