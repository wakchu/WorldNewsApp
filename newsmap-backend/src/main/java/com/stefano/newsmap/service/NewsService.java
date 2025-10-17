package com.stefano.newsmap.service;

import com.stefano.newsmap.model.Country;
import com.stefano.newsmap.model.News;
import com.stefano.newsmap.model.Source;
import com.stefano.newsmap.repository.CountryRepository;
import com.stefano.newsmap.repository.NewsRepository;
import com.stefano.newsmap.repository.SourceRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.List;
import java.util.Set;


@Service
public class NewsService {

    @Autowired
    private NewsRepository newsRepository;

    @Autowired
    private CountryRepository countryRepository;

    @Autowired
    private SourceRepository sourceRepository;

    /**
     * Salva una notizia nel database.
     * @param title titolo della news
     * @param description descrizione
     * @param url url dell'articolo
     * @param publishedAt data pubblicazione
     * @param sourceName nome della fonte
     * @param countryCodes lista di ISO code dei paesi associati
     */
    @Transactional
    public void saveNews(String title, String description, String url,
                         LocalDateTime publishedAt, String sourceName, List<String> countryCodes) {

        // Recupera o crea la fonte
        Source source = sourceRepository.findByName(sourceName)
                .orElseGet(() -> {
                    Source s = new Source();
                    s.setName(sourceName);
                    return sourceRepository.save(s);
                });

        // Recupera i country dal DB
        Set<Country> countries = new HashSet<>();
        for (String code : countryCodes) {
            countryRepository.findById(code).ifPresent(countries::add);
        }

        // Crea la news
        News news = new News();
        news.setTitle(title);
        news.setDescription(description);
        news.setUrl(url);
        news.setPublishedAt(publishedAt);
        news.setSource(source);

        // Salva la news
        newsRepository.save(news);
    }
}
