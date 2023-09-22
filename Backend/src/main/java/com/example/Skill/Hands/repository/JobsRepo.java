package com.example.Skill.Hands.repository;

import com.example.Skill.Hands.entity.JobsEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface JobsRepo extends JpaRepository<JobsEntity, Long> {

    JobsEntity findBySkill(String skillName);
    
}
