package com.sigc.backend.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import java.io.File;
import java.io.IOException;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/uploads")
@CrossOrigin(origins = {"http://localhost:5173", "http://localhost:5174", "http://localhost:5175"})
@Tag(name = "Upload", description = "Gestión de archivos y subida de imágenes")
@SecurityRequirement(name = "JWT")
public class UploadController {

    // Carpeta raíz (no dentro de /src ni /resources)
    private static final String UPLOAD_DIR = System.getProperty("user.dir") + "/uploads/images/especialidades/";
    private static final List<String> ALLOWED_EXTENSIONS = Arrays.asList("jpg", "jpeg", "png", "gif", "webp");
    private static final long MAX_FILE_SIZE = 5 * 1024 * 1024;

    @PostMapping
    @Operation(summary = "Subir archivo", description = "Sube una imagen para especialidades médicas")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "Archivo subido exitosamente"),
        @ApiResponse(responseCode = "400", description = "Archivo inválido o demasiado grande"),
        @ApiResponse(responseCode = "401", description = "No autorizado"),
        @ApiResponse(responseCode = "500", description = "Error al guardar el archivo")
    })
    public ResponseEntity<?> uploadFile(@RequestParam("file") MultipartFile file) {
        try {
            if (file.isEmpty()) {
                return ResponseEntity.badRequest().body(createErrorResponse("El archivo está vacío"));
            }
            if (file.getSize() > MAX_FILE_SIZE) {
                return ResponseEntity.status(HttpStatus.PAYLOAD_TOO_LARGE)
                        .body(createErrorResponse("El archivo es demasiado grande (máximo 5MB)"));
            }
            String originalFilename = file.getOriginalFilename();
            if (originalFilename == null || !isValidImageExtension(originalFilename)) {
                return ResponseEntity.badRequest()
                        .body(createErrorResponse("Formato de imagen no válido. Permitidos: " + ALLOWED_EXTENSIONS));
            }
            File dir = new File(UPLOAD_DIR);
            if (!dir.exists()) dir.mkdirs();

            String uniqueFileName = System.currentTimeMillis() + "_" + sanitizeFilename(originalFilename);
            String filePath = UPLOAD_DIR + uniqueFileName;
            File destination = new File(filePath);
            file.transferTo(destination);

            String imageUrl = "/images/especialidades/" + uniqueFileName;
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("url", imageUrl);
            response.put("filename", uniqueFileName);
            response.put("size", file.getSize());
            response.put("contentType", file.getContentType());

            return ResponseEntity.ok(response);

        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(createErrorResponse("Error al guardar la imagen: " + e.getMessage()));
        }
    }

    private boolean isValidImageExtension(String filename) {
        String extension = getFileExtension(filename);
        return ALLOWED_EXTENSIONS.contains(extension.toLowerCase());
    }

    private String getFileExtension(String filename) {
        int lastDotIndex = filename.lastIndexOf('.');
        if (lastDotIndex == -1) return "";
        return filename.substring(lastDotIndex + 1);
    }

    private String sanitizeFilename(String filename) {
        return filename.replaceAll("[^a-zA-Z0-9._-]", "_");
    }

    private Map<String, Object> createErrorResponse(String message) {
        Map<String, Object> error = new HashMap<>();
        error.put("success", false);
        error.put("error", message);
        return error;
    }
}
