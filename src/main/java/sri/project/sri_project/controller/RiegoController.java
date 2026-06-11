    package sri.project.sri_project.controller;

import org.springframework.ui.Model;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import sri.project.sri_project.service.PerfilCultivoService;

@Controller
public class RiegoController {

    private final PerfilCultivoService perfilCultivoService;

    public RiegoController(PerfilCultivoService perfilCultivoService) {
        this.perfilCultivoService = perfilCultivoService;
    }

    @GetMapping("/riego")
    public String mostrarRiego(Model model) {
        model.addAttribute("cultivos", perfilCultivoService.listarActivos());
        return "riego";
    }
}
