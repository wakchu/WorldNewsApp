package com.stefano.newsmap.repository;

import com.stefano.newsmap.model.News;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface NewsRepository extends JpaRepository<News, String> {
    List<News> findAllByCountriesIsoCodeOrderByPublishedAtDesc(String isoCode);
}
