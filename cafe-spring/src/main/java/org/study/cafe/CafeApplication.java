package org.study.cafe;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.web.embedded.tomcat.TomcatServletWebServerFactory;
import org.springframework.boot.web.server.WebServerFactoryCustomizer;
import org.springframework.context.annotation.Bean;

import java.io.File;

@SpringBootApplication
public class CafeApplication {
    public static void main(String[] args) {
        SpringApplication.run(CafeApplication.class, args);
    }

    @Bean
    public WebServerFactoryCustomizer<TomcatServletWebServerFactory> customizer() {
        return factory -> {
            File webappDir = new File("cafe-spring/src/main/webapp");
            if (!webappDir.exists())
                webappDir = new File("src/main/webapp");
            if (webappDir.exists()) {
                factory.setDocumentRoot(webappDir);
            }
        };
    }
}
