package com.stefano.newsmap.repository;

import com.stefano.newsmap.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

public interface UserRepository extends JpaRepository<User, Long> {
    Optional<User> findByUsername(String username);

    @Modifying
    @Query(value = "DELETE FROM user_favorite_news", nativeQuery = true)
    void clearFavoriteNews();
}
