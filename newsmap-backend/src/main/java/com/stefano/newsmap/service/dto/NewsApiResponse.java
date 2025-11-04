package com.stefano.newsmap.service.dto;

import java.util.List;
import com.fasterxml.jackson.annotation.JsonProperty;

public class NewsApiResponse {
    private String status;
    private int totalResults;
    private List<Article> results;

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
    public List<Article> getResults() {
        return results;
    }
    public void setResults(List<Article> results) {
        this.results = results;
    }

    public static class Article {
        @JsonProperty("article_id")
        private String articleId;
        @JsonProperty("source_name")
        private String sourceName;
        private String title;
        private String description;
        @JsonProperty("link")
        private String url;
        @JsonProperty("pubDate")
        private String publishedAt;
        @JsonProperty("image_url")
        private String imageUrl;

        public String getArticleId() {
            return articleId;
        }

        public void setArticleId(String articleId) {
            this.articleId = articleId;
        }

        public String getSourceName() {
            return sourceName;
        }

        public void setSourceName(String sourceName) {
            this.sourceName = sourceName;
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

        public String getImageUrl() {
            return imageUrl;
        }

        public void setImageUrl(String imageUrl) {
            this.imageUrl = imageUrl;
        }
    }
}
