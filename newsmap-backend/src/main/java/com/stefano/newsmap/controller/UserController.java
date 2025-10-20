package com.stefano.newsmap.controller;

import com.stefano.newsmap.model.News;
import com.stefano.newsmap.model.User;
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
}
