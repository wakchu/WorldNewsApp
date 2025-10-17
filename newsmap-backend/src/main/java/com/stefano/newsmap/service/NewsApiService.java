package com.stefano.newsmap.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.stefano.newsmap.model.Country;
import com.stefano.newsmap.model.News;
import com.stefano.newsmap.model.Source;
import com.stefano.newsmap.repository.CountryRepository;
import com.stefano.newsmap.repository.NewsRepository;
import com.stefano.newsmap.repository.SourceRepository;
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

@Service
public class NewsApiService {

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

    private final RestClient restClient = RestClient.create();

    public void fetchAndSaveNews(String countryCode) {
        try {
            NewsApiResponse newsApiResponse = restClient.get()
                    .uri(apiUrl + "?country={country}&apiKey={apiKey}", countryCode.toLowerCase(), apiKey)
                    .retrieve()
                    .body(NewsApiResponse.class);

            if (newsApiResponse == null || newsApiResponse.getArticles() == null) {
                return;
            }

            for (NewsApiResponse.Article article : newsApiResponse.getArticles()) {
                // Source
                Source source = sourceRepository.findByName(article.getSource().getName())
                        .orElseGet(() -> {
                            Source s = new Source();
                            s.setName(article.getSource().getName());
                            return sourceRepository.save(s);
                        });

                // Country
                Country country = countryRepository.findById(countryCode).orElse(null);
                if (country == null) continue;

                Set<Country> countries = new HashSet<>();
                countries.add(country);

                // Convert publishedAt in LocalDateTime
                LocalDateTime publishedAt = null;
                if (article.getPublishedAt() != null) {
                    publishedAt = ZonedDateTime.parse(article.getPublishedAt(), DateTimeFormatter.ISO_DATE_TIME)
                            .toLocalDateTime();
                }

                // News
                News news = new News();
                news.setTitle(article.getTitle());
                news.setDescription(article.getDescription());
                news.setUrl(article.getUrl());
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
