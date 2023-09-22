package com.example.Skill.Hands.repository;

import com.example.Skill.Hands.entity.SkillsEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface SkillsRepo extends JpaRepository<SkillsEntity, Long> {

    List<SkillsEntity> findByJobsEntityJobId(Long id);

    List<SkillsEntity> findByDistrictEntityDistrictCodeAndJobsEntityJobId(int districtCode, int jobId);
    public SkillsEntity findByName(String name);

}
