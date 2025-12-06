package com.sigc.backend.adapter.out.persistence;

import com.sigc.backend.model.Usuario;
import com.sigc.backend.domain.port.IUsuarioRepository;
import com.sigc.backend.repository.UsuarioRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Repository
public class JpaUsuarioAdapter implements IUsuarioRepository {

    private final UsuarioRepository usuarioRepository;

    public JpaUsuarioAdapter(UsuarioRepository usuarioRepository) {
        this.usuarioRepository = usuarioRepository;
    }

    @Override
    public Optional<Usuario> findById(Long id) {
        if (id == null) {
            return Optional.empty();
        }
        return usuarioRepository.findById(id);
    }

    @Override
    public Optional<Usuario> findByEmail(String email) {
        return Optional.ofNullable(usuarioRepository.findByEmail(email));
    }

    @Override
    public boolean existsByEmail(String email) {
        return usuarioRepository.findByEmail(email) != null;
    }

    @Override
    public Usuario save(Usuario usuario) {
        return usuarioRepository.save(usuario);
    }

    @Override
    public long count() {
        return usuarioRepository.count();
    }

    @Override
    public List<Usuario> findAll() {
        return usuarioRepository.findAll();
    }

    @Override
    public void deleteById(Long id) {
        if (id != null) {
            usuarioRepository.deleteById(id);
        }
    }
}
