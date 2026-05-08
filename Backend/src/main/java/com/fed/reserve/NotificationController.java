package com.fed.reserve;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import java.time.LocalDateTime;
import java.util.Map;

@RestController
public class NotificationController {

    @GetMapping("/api/notifications")
    public Map<String, Object> getNotifications() {
        return Map.of(
            "source", "SPRING_BOOT_MICROSERVICE",
            "status", "FedRAMP_HIGH_COMPLIANT",
            "timestamp", LocalDateTime.now().toString(),
            "message", "Secure notification delivered via GovCloud"
        );
    }
    
    @GetMapping("/actuator/health")
    public String health() {
        return "UP";
    }
}
