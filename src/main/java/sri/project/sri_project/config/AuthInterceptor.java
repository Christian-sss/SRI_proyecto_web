package sri.project.sri_project.config;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import java.nio.charset.StandardCharsets;

@Component
public class AuthInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(
            HttpServletRequest request,
            HttpServletResponse response,
            Object handler
    ) throws Exception {
        String path = request.getRequestURI();

        if (path.startsWith("/css/") || path.startsWith("/js/") || path.startsWith("/img/")) {
            return true;
        }

        if (request.getSession().getAttribute("usuarioLogueado") != null) {
            return true;
        }

        response.sendRedirect("/login");
        return false;
    }
}
