package sri.project.sri_project.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import sri.project.sri_project.dto.CultivoRequest;
import sri.project.sri_project.model.Cultivo;
import sri.project.sri_project.service.PerfilCultivoService;

@Controller
@RequestMapping("/perfiles")
@RequiredArgsConstructor
public class PerfilCultivoController {

    private final PerfilCultivoService perfilCultivoService;

    @GetMapping
    public String listarPerfiles(Model model) {
        model.addAttribute("cultivo", new Cultivo());
        model.addAttribute("cultivos", perfilCultivoService.listarTodasEntidades());
        return "perfil_cultivo";
    }

    @PostMapping
    public String guardarPerfil(
            @ModelAttribute Cultivo cultivo,
            RedirectAttributes redirectAttributes
    ) {
        perfilCultivoService.crear(new CultivoRequest(
                cultivo.getNombre(),
                cultivo.getHumedadMinOptima(),
                cultivo.getHumedadMaxOptima(),
                cultivo.getDuracionRiegoMinutos(),
                cultivo.getTratoRecomendado()
        ));
        redirectAttributes.addFlashAttribute("mensaje", "Perfil de cultivo guardado correctamente.");
        return "redirect:/perfiles";
    }
}
