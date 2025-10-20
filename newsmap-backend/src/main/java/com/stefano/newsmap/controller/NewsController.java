package com.stefano.newsmap.controller;

import com.stefano.newsmap.model.News;
import com.stefano.newsmap.repository.NewsRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

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

    @GetMapping("/{id}")
    public ResponseEntity<News> getNewsById(@PathVariable Long id) {
        News news = newsRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "News not found"));
        return ResponseEntity.ok(news);
    }
}
