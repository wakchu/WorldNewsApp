package com.stefano.newsmap.controller;

import com.stefano.newsmap.model.Country;
import com.stefano.newsmap.model.News;
import com.stefano.newsmap.model.User;
import com.stefano.newsmap.repository.CountryRepository;
import com.stefano.newsmap.repository.NewsRepository;
import com.stefano.newsmap.repository.UserRepository;
import com.stefano.newsmap.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.security.Principal;

@RestController
@RequestMapping("/api/users")
public class UserController {

    @Autowired
    private UserService userService;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private NewsRepository newsRepository;

    @Autowired
    private CountryRepository countryRepository;

    @GetMapping("/me")
    public ResponseEntity<User> getMyProfile(Principal principal) {
        User user = userService.findByUsername(principal.getName())
                .orElseThrow(() -> new UsernameNotFoundException("User not found"));
        return ResponseEntity.ok(user);
    }

    @PostMapping("/me/bookmarks/{newsId}")
    public ResponseEntity<?> addBookmark(@PathVariable Long newsId, Principal principal) {
        User user = userService.findByUsername(principal.getName())
                .orElseThrow(() -> new UsernameNotFoundException("User not found"));

        News news = newsRepository.findById(newsId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "News not found"));

        user.getFavoriteNews().add(news);
        userRepository.save(user);

        return ResponseEntity.ok().build();
    }

    @PostMapping("/me/countries/{countryIso}")
    public ResponseEntity<?> addFavoriteCountry(@PathVariable String countryIso, Principal principal) {
        User user = userService.findByUsername(principal.getName())
                .orElseThrow(() -> new UsernameNotFoundException("User not found"));

        Country country = countryRepository.findById(countryIso)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Country not found"));

        user.getFavoriteCountries().add(country);
        userRepository.save(user);

        return ResponseEntity.ok().build();
    }

    @DeleteMapping("/me/bookmarks/{newsId}")
    public ResponseEntity<?> removeBookmark(@PathVariable Long newsId, Principal principal) {
        User user = userService.findByUsername(principal.getName())
                .orElseThrow(() -> new UsernameNotFoundException("User not found"));

        News news = newsRepository.findById(newsId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "News not found"));

        user.getFavoriteNews().remove(news);
        userRepository.save(user);

        return ResponseEntity.ok().build();
    }

    @DeleteMapping("/me/countries/{countryIso}")
    public ResponseEntity<?> removeFavoriteCountry(@PathVariable String countryIso, Principal principal) {
        User user = userService.findByUsername(principal.getName())
                .orElseThrow(() -> new UsernameNotFoundException("User not found"));

        Country country = countryRepository.findById(countryIso)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Country not found"));

        user.getFavoriteCountries().remove(country);
        userRepository.save(user);

        return ResponseEntity.ok().build();
    }
}
