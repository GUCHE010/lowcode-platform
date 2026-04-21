package com.platform.system.service;

import com.platform.system.entity.PostEntity;
import com.platform.system.repository.PostRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.time.LocalDateTime;
import java.util.List;

@Service
public class PostService {

    @Autowired
    private PostRepository postRepository;

    public List<PostEntity> listByTenant(Long tenantId) {
        return postRepository.findByTenantIdOrderBySortOrder(tenantId);
    }

    public PostEntity findById(Long id) {
        return postRepository.findById(id).orElse(null);
    }

    @Transactional
    public void create(PostEntity post) {
        post.setCreatedAt(LocalDateTime.now());
        post.setStatus("active");
        if (post.getSortOrder() == null) {
            post.setSortOrder(0);
        }
        postRepository.save(post);
    }

    @Transactional
    public void update(PostEntity post) {
        post.setUpdatedAt(LocalDateTime.now());
        postRepository.save(post);
    }

    @Transactional
    public void delete(Long id) {
        postRepository.deleteById(id);
    }
}
