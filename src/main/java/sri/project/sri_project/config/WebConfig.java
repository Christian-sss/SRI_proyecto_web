package sri.project.sri_project.config;

import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
@RequiredArgsConstructor
public class WebConfig implements WebMvcConfigurer {

    private final AuthInterceptor authInterceptor;

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(authInterceptor)
                .addPathPatterns(
                        "/dashboard",
                        "/estadisticas",
                        "/sensor/**",
                        "/riego",
                        "/api/riego/**",
                        "/mqtt/**",
                        "/perfiles/**",
                        "/api/cultivos/**",
                        "/api/estadisticas/**",
                        "/reportes/**",
                        "/api/reportes/**"
                );
    }
}
