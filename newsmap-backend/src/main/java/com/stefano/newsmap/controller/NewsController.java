package com.stefano.newsmap.controller;

import com.stefano.newsmap.model.News;
import com.stefano.newsmap.repository.NewsRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/news")
public class NewsController {

    @Autowired
    private NewsRepository newsRepository;

    /**
     * Restituisce tutte le news salvate
     */
    @GetMapping
    public List<News> getAllNews() {
        return newsRepository.findAll();
    }

    /**
     * Restituisce tutte le news associate a un determinato paese (ISO code)
     * @param isoCode codice ISO del paese
     */
    @GetMapping("/by-country/{isoCode}")
    public List<News> getNewsByCountry(@PathVariable String isoCode) {
        return newsRepository.findAllByCountriesIsoCodeOrderByPublishedAtDesc(isoCode);
    }
}
