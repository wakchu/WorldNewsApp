package com.stefano.newsmap.service.dto;

import java.util.List;

public class NewsApiResponse {
    private String status;
    private int totalResults;
    private List<Article> articles;

    // getter e setter
    public String getStatus() {
        return status;
    }
    public void setStatus(String status) {
        this.status = status;
    }
    public int getTotalResults() {
        return totalResults;
    }
    public void setTotalResults(int totalResults) {
        this.totalResults = totalResults;
    }
    public List<Article> getArticles() {
        return articles;
    }
    public void setArticles(List<Article> articles) {
        this.articles = articles;
    }

    public static class Article {
        private Source source;
        private String author;
        private String title;
        private String description;
        private String url;
        private String publishedAt; // parsare in LocalDateTime

        // getter e setter
        public Source getSource() {
            return source;
        }
        public void setSource(Source source) {
            this.source = source;
        }
        public String getAuthor() {
            return author;
        }
        public void setAuthor(String author) {
            this.author = author;
        }
        public String getTitle() {
            return title;
        }
        public void setTitle(String title) {
            this.title = title;
        }
        public String getDescription() {
            return description;
        }
        public void setDescription(String description) {
            this.description = description;
        }
        public String getUrl() {
            return url;
        }
        public void setUrl(String url) {
            this.url = url;
        }
        public String getPublishedAt() {
            return publishedAt;
        }
        public void setPublishedAt(String publishedAt) {
            this.publishedAt = publishedAt;
        }

        public static class Source {
            private String id;
            private String name;

            // getter e setter
            public String getId() {
                return id;
            }
            public void setId(String id) {
                this.id = id;
            }
            public String getName() {
                return name;
            }
            public void setName(String name) {
                this.name = name;
            }
        }
    }
}
