package sri.project.sri_project.controller;


import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import sri.project.sri_project.integration.Esp32MqttConnectionManager;
import sri.project.sri_project.integration.Esp32MqttSensor;

@Controller
@RequestMapping("/mqtt")
@RequiredArgsConstructor
public class MqttController {

    private final Esp32MqttConnectionManager mqttManager;
    private final Esp32MqttSensor mqttSensor;

    @GetMapping
    public String vistaMqtt(Model model) {

        String estado = mqttManager.estaConectado()
                ? "CONECTADO"
                : "DESCONECTADO";

        model.addAttribute("estado", estado);

        return "mqtt";
    }

    @PostMapping("/connect")
    public String connect(
            @RequestParam String username,
            @RequestParam String password,
            RedirectAttributes redirectAttributes
    ) {
        try {
            mqttManager.conectar(username, password);
            try {
                mqttSensor.iniciar();
            } catch (Exception subscriptionException) {
                mqttManager.desconectar();
                throw new IllegalStateException(
                        "HiveMQ acepto la conexion, pero fallo la suscripcion a upt/riego/datos: "
                                + obtenerCausa(subscriptionException),
                        subscriptionException
                );
            }
            redirectAttributes.addFlashAttribute("mensaje", "Conexión MQTT establecida correctamente.");
        } catch (Exception e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute(
                    "error",
                    "No se pudo conectar a MQTT: " + obtenerCausa(e)
            );
        }

        return "redirect:/mqtt";
    }

    private String obtenerCausa(Throwable error) {
        Throwable actual = error;
        String mensaje = error.getMessage();

        while (actual.getCause() != null) {
            actual = actual.getCause();
            if (actual.getMessage() != null && !actual.getMessage().isBlank()) {
                mensaje = actual.getMessage();
            }
        }

        return mensaje != null && !mensaje.isBlank() ? mensaje : "causa desconocida";
    }

    @PostMapping("/disconnect")
    public String disconnect(RedirectAttributes redirectAttributes) {
        mqttManager.desconectar();
        redirectAttributes.addFlashAttribute("mensaje", "Conexion MQTT cerrada correctamente.");

        return "redirect:/mqtt";
    }

}
