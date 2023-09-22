package com.example.Skill.Hands.repository;

import com.example.Skill.Hands.entity.ServicesMasterEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ServiceMasterRepo extends JpaRepository<ServicesMasterEntity, Integer> {
}
