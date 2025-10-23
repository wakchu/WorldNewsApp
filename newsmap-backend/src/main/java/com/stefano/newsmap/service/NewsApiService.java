package com.stefano.newsmap.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.stefano.newsmap.model.Country;
import com.stefano.newsmap.model.News;
import com.stefano.newsmap.model.Source;
import com.stefano.newsmap.repository.CountryRepository;
import com.stefano.newsmap.repository.NewsRepository;
import com.stefano.newsmap.repository.SourceRepository;
import com.stefano.newsmap.repository.UserRepository;
import com.stefano.newsmap.service.dto.NewsApiResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestClient;

import java.time.LocalDateTime;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashSet;
import java.util.Set;

import org.springframework.transaction.annotation.Transactional;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Service
public class NewsApiService {

    private static final Logger logger = LoggerFactory.getLogger(NewsApiService.class);

    @Value("${newsapi.key}")
    private String apiKey;

    @Value("${newsapi.url}")
    private String apiUrl;

    @Autowired
    private NewsRepository newsRepository;

    @Autowired
    private CountryRepository countryRepository;

    @Autowired
    private SourceRepository sourceRepository;

    @Autowired
    private UserRepository userRepository;

    private final RestClient restClient = RestClient.create();

    @Transactional
    public void fetchAndSaveNews(String countryCode) {
        try {


            NewsApiResponse newsApiResponse = restClient.get()
                    .uri(apiUrl + "?country={country}&apikey={apiKey}", countryCode.toLowerCase(), apiKey)
                    .retrieve()
                    .body(NewsApiResponse.class);

            if (newsApiResponse == null || newsApiResponse.getResults() == null || newsApiResponse.getResults().isEmpty()) {
                throw new IllegalStateException("No news articles received from the API.");
            }

            logger.info("Received {} articles from the API.", newsApiResponse.getResults().size());

            for (NewsApiResponse.Article article : newsApiResponse.getResults()) {
                // Source
                Source source = sourceRepository.findByName(article.getSourceName())
                        .orElseGet(() -> {
                            Source s = new Source();
                            s.setName(article.getSourceName());
                            return sourceRepository.save(s);
                        });

                // Country
                Country country = countryRepository.findById(countryCode.toUpperCase())
                        .orElseThrow(() -> new IllegalArgumentException("Country with code \'" + countryCode.toUpperCase() + "\' not found in the database."));

                Set<Country> countries = new HashSet<>();
                countries.add(country);

                // Convert publishedAt in LocalDateTime
                LocalDateTime publishedAt = null;
                if (article.getPublishedAt() != null) {
                    publishedAt = LocalDateTime.parse(article.getPublishedAt(), DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
                }

                // News
                News news = new News();
                news.setTitle(article.getTitle());
                news.setDescription(article.getDescription());
                news.setUrl(article.getUrl());
                news.setImageUrl(article.getImageUrl());
                news.setPublishedAt(publishedAt != null ? publishedAt : LocalDateTime.now());
                news.setSource(source);
                news.setCountries(countries);

                newsRepository.save(news);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
