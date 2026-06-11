package sri.project.sri_project.controller;


import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import sri.project.sri_project.model.User;
import sri.project.sri_project.service.UsuarioService;

import java.security.SecureRandom;

@RequiredArgsConstructor
@Controller
public class LoginController {

    private static final String CAPTCHA_SESSION_KEY = "LOGIN_CAPTCHA";
    private static final String CAPTCHA_CHARS = "ABCDEFGHJKLMNPQRSTUVWXYZ";
    private static final SecureRandom RANDOM = new SecureRandom();

    private final UsuarioService usuarioService;

    @GetMapping("/login")
    public String inicio(Model model, HttpSession session) {
        prepararCaptcha(model, session);
        return "login";
    }

    @PostMapping("/login")
    public String ingresar(
            @RequestParam String username,
            @RequestParam String password,
            @RequestParam String captcha,
            Model model,
            HttpSession session
    ) {
        String captchaEsperado = (String) session.getAttribute(CAPTCHA_SESSION_KEY);

        if (captchaEsperado == null || !captchaEsperado.equalsIgnoreCase(captcha.trim())) {
            model.addAttribute("error", "Captcha incorrecto. Intenta nuevamente.");
            prepararCaptcha(model, session);
            return "login";
        }

        try {
            User usuario = usuarioService.ejecutar(username.trim(), password.trim());
            session.setAttribute("usuarioLogueado", usuario);
            session.removeAttribute(CAPTCHA_SESSION_KEY);
            return "redirect:/dashboard";
        } catch (Exception e) {
            model.addAttribute("error", "Usuario o contraseña incorrectos");
            prepararCaptcha(model, session);
            return "login";
        }
    }

    @GetMapping("/registro")
    public String vistaRegistro(Model model, HttpSession session) {
        prepararCaptcha(model, session);
        return "registro";
    }

    @PostMapping("/registro")
    public String registrar(
            @RequestParam String username,
            @RequestParam String password,
            Model model,
            HttpSession session
    ) {
        try {
            usuarioService.registrar(username.trim(), password.trim());
            model.addAttribute("mensajeExito", "¡Registro exitoso! Ya puedes ingresar.");
            prepararCaptcha(model, session);
            return "login";
        } catch (IllegalArgumentException e) {
            model.addAttribute("error", e.getMessage());
            return "registro";
        } catch (Exception e) {
            model.addAttribute("error", "Ocurrió un error en el registro.");
            return "registro";
        }
    }

    @GetMapping("/logout")
    public String salir(HttpSession session) {
        session.invalidate();
        return "redirect:/login";
    }

    @PostMapping("/login/google")
    public String ingresarConGoogle(@RequestParam("credential") String credential, Model model, HttpSession session) {
        try {
            User usuario = usuarioService.autenticarConGoogle(credential);
            session.setAttribute("usuarioLogueado", usuario);
            return "redirect:/dashboard";
        } catch (Exception e) {
            e.printStackTrace();
            String mensajeDetalle = e.getCause() != null ? e.getCause().getMessage() : e.getMessage();
            model.addAttribute("error", "Error autenticando con Google: " + mensajeDetalle);
            prepararCaptcha(model, session);
            return "login";
        }
    }

    private void prepararCaptcha(Model model, HttpSession session) {
        String captcha = generarCaptcha();
        session.setAttribute(CAPTCHA_SESSION_KEY, captcha);
        model.addAttribute("captchaTexto", captcha);
    }

    private String generarCaptcha() {
        StringBuilder captcha = new StringBuilder();
        for (int i = 0; i < 5; i++) {
            int index = RANDOM.nextInt(CAPTCHA_CHARS.length());
            captcha.append(CAPTCHA_CHARS.charAt(index));
        }
        return captcha.toString();
    }

}
