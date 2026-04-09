package org.study.cafe.config;

import org.springframework.boot.web.server.WebServerFactoryCustomizer;
import org.springframework.boot.web.servlet.server.ConfigurableServletWebServerFactory;
import org.springframework.context.annotation.Configuration;

import java.io.File;
import java.net.URL;

/**
 * 임베디드 Tomcat의 document root를 프로젝트의 src/main/webapp 으로 고정.
 * 작업 디렉토리가 프로젝트 루트가 아닐 때(IDE 실행 등) JSP를 못 찾는 문제를 해결.
 */
@Configuration
public class WebServerConfig implements WebServerFactoryCustomizer<ConfigurableServletWebServerFactory> {

    @Override
    public void customize(ConfigurableServletWebServerFactory factory) {
        try {
            URL location = getClass().getProtectionDomain().getCodeSource().getLocation();
            File classesDir = new File(location.toURI()); // target/classes
            File webappDir  = new File(classesDir.getParentFile().getParentFile(), "src/main/webapp");
            if (webappDir.exists()) {
                factory.setDocumentRoot(webappDir);
            }
        } catch (Exception ignored) {}
    }
}
