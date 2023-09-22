package com.example.Skill.Hands.repository;

import com.example.Skill.Hands.entity.ServiceAvailedEntity;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ServiceAvailedRepo extends JpaRepository<ServiceAvailedEntity, Integer> {

    List<ServiceAvailedEntity> findByRegisterEntityId(int citizenId);

    List<ServiceAvailedEntity> findByServicesMasterEntityServiceId(int serviceId);

}
