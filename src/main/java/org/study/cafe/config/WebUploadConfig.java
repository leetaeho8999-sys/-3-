package org.study.cafe.config;

import jakarta.annotation.PostConstruct;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;

/**
 * 외부 디렉토리(`app.upload.dir`) 를 `app.upload.url-prefix/**` URL 로 서빙.
 * - dev:   ./uploads  → /resources/upload/**
 * - Docker: /app/uploads (volume mount) → /resources/upload/**
 * 기동 시 디렉토리 자동 생성. 절대 경로로 정규화하여 ResourceHandler 등록.
 */
@Configuration
public class WebUploadConfig implements WebMvcConfigurer {

    private static final Logger log = LoggerFactory.getLogger(WebUploadConfig.class);

    @Value("${app.upload.dir}")
    private String uploadDir;

    @Value("${app.upload.url-prefix}")
    private String urlPrefix;

    private Path resolvedPath;

    @PostConstruct
    public void init() {
        // 절대 경로 정규화 + 디렉토리 자동 생성
        this.resolvedPath = Paths.get(uploadDir).toAbsolutePath().normalize();
        File dir = resolvedPath.toFile();
        if (!dir.exists()) {
            boolean created = dir.mkdirs();
            log.info("업로드 디렉토리 생성: {} (created={})", resolvedPath, created);
        } else {
            log.info("업로드 디렉토리 확인: {}", resolvedPath);
        }
        if (!dir.canWrite()) {
            log.warn("업로드 디렉토리 쓰기 권한 없음: {}", resolvedPath);
        }
    }

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // file:///absolute/path/ 형태 URI 로 등록 (반드시 trailing slash)
        String location = resolvedPath.toUri().toString();
        registry.addResourceHandler(urlPrefix + "/**")
                .addResourceLocations(location);
        log.info("ResourceHandler 등록: {}/** → {}", urlPrefix, location);
    }

    /** BoardController 등에서 디렉토리 위치를 참조할 때 사용 */
    public Path getResolvedPath() {
        return resolvedPath;
    }

    public String getUrlPrefix() {
        return urlPrefix;
    }
}
