package sri.project.sri_project.controller;


import lombok.AllArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import sri.project.sri_project.model.enums.ModoRiego;
import sri.project.sri_project.repository.EventoRiegoRepository;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;


@AllArgsConstructor
@Controller
public class DashboardController {




    private final EventoRiegoRepository eventoRiegoRepository;


    @GetMapping("/dashboard")
    public String cargarDashboard(Model model) {


        String nombreAgricultor = "Christian";
        int humedadActual = 42;


        LocalDateTime ahora = LocalDateTime.now();
        DateTimeFormatter formato = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss");
        String fechaFormateada = ahora.format(formato);



        List<Integer> historialHumedad = Arrays.asList(
                40, 45, 52, 60, 67, 73, 66, 68, 62, 60,
                54, 52, 45, 42, 35, 32, 27, 29, 25, 26,
                24, 27, 26, 30, 32, 36, 34, 38, 40
        );


        String valoresHumedadJSP = historialHumedad.stream()
                .map(String::valueOf)
                .collect(Collectors.joining(", "));


        model.addAttribute("usuarioNombre", nombreAgricultor);
        model.addAttribute("fechaActual", fechaFormateada);
        model.addAttribute("humedadActual", humedadActual);
        model.addAttribute("valoresHumedadJSP", valoresHumedadJSP);

        return "dashboard";
    }

    @GetMapping("/estadisticas")
    public String mostrarEstadisticas(Model model) {
        long countManual = 0;
        long countAutomatico = 0;

        try {
            List<Object[]> riegosPorModo = eventoRiegoRepository.contarRiegosPorModoMesActual();

            if (riegosPorModo != null) {
                for (Object[] fila : riegosPorModo) {
                    if (fila != null && fila[0] != null && fila[1] != null) {
                        ModoRiego modo = (ModoRiego) fila[0];
                        Long cantidad = (Long) fila[1];
                        if (modo == ModoRiego.MANUAL) countManual = cantidad;
                        if (modo == ModoRiego.AUTOMATICO) countAutomatico = cantidad;
                    }
                }
            }
        } catch (Exception e) {
            System.err.println(" Error al obtener datos de la BD: " + e.getMessage());
            e.printStackTrace();
        }


        String fechasJS = "['Lun', 'Mar', 'Mie', 'Jue', 'Vie', 'Sab', 'Dom']";
        String duracionJS = "[1200, 1500, 900, 1800, 2000, 800, 1000]";


        model.addAttribute("manuales", countManual);
        model.addAttribute("automaticos", countAutomatico);
        model.addAttribute("labelsDias", fechasJS);
        model.addAttribute("datosDuracion", duracionJS);

        return "estadisticas";
    }









}
