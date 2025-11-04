package com.stefano.newsmap.controller;

import com.stefano.newsmap.model.News;
import com.stefano.newsmap.repository.NewsRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.List;

@RestController
@RequestMapping("/api/news")
public class NewsController {

    private static final Logger logger = LoggerFactory.getLogger(NewsController.class);

    @Autowired
    private NewsRepository newsRepository;

    @GetMapping
    public List<News> getAllNews() {
        return newsRepository.findAll();
    }

    @GetMapping("/by-country/{isoCode}")
    public List<News> getNewsByCountry(@PathVariable String isoCode) {
        logger.info("Received request for news by country: {}", isoCode);
        List<News> newsList = newsRepository.findAllByCountriesIsoCodeOrderByPublishedAtDesc(isoCode.toUpperCase());
        logger.info("Returning {} news articles for country: {}", newsList.size(), isoCode);
        return newsList;
    }

    @GetMapping("/{id}")
    public ResponseEntity<News> getNewsById(@PathVariable Long id) {
        News news = newsRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "News not found"));
        return ResponseEntity.ok(news);
    }
}
