package com.stefano.newsmap.controller;

import com.stefano.newsmap.service.NewsApiService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/fetch-news")
public class NewsApiController {

    @Autowired
    private NewsApiService newsApiService;

    @PostMapping("/{countryCode}")
    public String fetchNewsForCountry(@PathVariable String countryCode) {
        newsApiService.fetchAndSaveNews(countryCode);
        return "Richiesta inviata per il paese: " + countryCode;
    }
}
