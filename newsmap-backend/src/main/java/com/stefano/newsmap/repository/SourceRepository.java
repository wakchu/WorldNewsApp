package com.stefano.newsmap.repository;

import com.stefano.newsmap.model.Source;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface SourceRepository extends JpaRepository<Source, String> {
    Optional<Source> findByName(String name);
}
